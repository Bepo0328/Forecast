//
//  DailyWeather+APIResponse.swift
//  Forecast
//
//  Created by 전윤현 on 2022/02/13.
//

import Foundation

enum DailyWeatherError: Error {
    case invalidTemperature(message: String)
}

extension DailyWeather {
    init ?(result: APIResult, now: Date) {
        let list = result.response.body.items.list
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"

        let dateString = formatter.string(from: now)

        let tmx = list.first(where: {$0.category == "TMX" && $0.forecastDate == dateString})?.value ?? ""
        let high = Double(tmx) ?? 0.0
        
        let tmn = list.first(where: {$0.category == "TMN" && $0.forecastDate == dateString})?.value ?? ""
        let low = Double(tmn) ?? 0.0

        let skyInfo = list.first(where: {$0.category == "SKY"})?.value ?? ""
        let skyValue = Int(skyInfo) ?? 0
                
        let ptyInfo = list.first(where: {$0.category == "PTY"})?.value ?? ""
        let ptyValue = Int(ptyInfo) ?? 0

        let sky: Sky

        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH00"

        let targetHour = hourFormatter.string(from: now)

        let currentInfo = list.first(where: {$0.category == "TMP" && $0.forecastTime == targetHour})?.value ?? ""
        let current = Double(currentInfo) ?? 0.0
        
        switch ptyValue {
        case 1, 2, 4:
            sky = .rainy
        case 3:
            sky = .snow
        default:
            if skyValue == 3 || skyValue == 4 {
                sky = .cloudy
            } else {
                sky = .sunny
            }
        }
        
        print(skyValue, ptyValue, current, low, high)
        
        self.sky = sky
        self.temerature = DailyTemperature(current: current, low: low, high: high)
    }
}
