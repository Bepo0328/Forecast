//
//  NetworkForecastUseCase.swift
//  Forecast
//
//  Created by 전윤현 on 2022/02/13.
//

import Foundation

enum NetworkError: Error {
    case dataNotExists
}

final class NetworkForecastUseCase: ForecastUseCase {
    func requestForecast(at date: Date, completion: @escaping ((Result<DailyWeather, Error>) -> ())) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        var components = URLComponents(string: "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst")
        
        components?.queryItems = [
            URLQueryItem(name: "ServiceKey", value: "your api key"),
            URLQueryItem(name: "numOfRows", value: "100"),
            URLQueryItem(name: "dataType", value: "JSON"),
            URLQueryItem(name: "base_date", value: dateFormatter.string(from: date)),
            URLQueryItem(name: "base_time", value: "0200"),
            URLQueryItem(name: "nx", value: "1"),
            URLQueryItem(name: "ny", value: "1")
        ]
        
        var request = URLRequest(url: (components!.url)!)
        
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        if let url = components?.url {
            print("url : \(url.absoluteURL)")
        }
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.dataNotExists))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(APIResult.self, from: data)
                let weather = try DailyWeather(result: result, now: date)
                
                DispatchQueue.main.async {
                    completion(.success(weather))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        })
        
        task.resume()
    }
}
