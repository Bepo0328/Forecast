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
    init(result: APIResult, now: Date) throws {
        let list = result.response.body.items.list
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"

        let dateString = formatter.string(from: now)

        guard let tmx = list.first(where: {$0.category == "TMX" && $0.forecastDate == dateString})?.value,
              let high = Double(tmx),
              let tmn = list.first(where: {$0.category == "TMN" && $0.forecastDate == dateString})?.value,
              let low = Double(tmn) else {
                  throw DailyWeatherError.invalidTemperature(message: "최저기온과 최고 기온을 가져올 수 없어요.")
              }

        guard let skyInfo = list.first(where: {$0.category == "SKY"})?.value,
              let skyValue = Int(skyInfo),
              let ptyInfo = list.first(where: {$0.category == "PTY"})?.value,
              let ptyValue = Int(ptyInfo) else {
                  throw DailyWeatherError.invalidTemperature(message: "현재 하늘 상태를 가져올 수 없어요.")
        }

        let sky: Sky

        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH00"

        let targetHour = hourFormatter.string(from: now)

        guard let currentInfo = list.first(where: {$0.category == "TMP" && $0.forecastTime == targetHour})?.value,
              let current = Double(currentInfo) else {
                  throw DailyWeatherError.invalidTemperature(message: "현재 온도 정보를 가져올 수 없습니다.")
              }
        
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
        
        self.sky = sky
        self.temerature = DailyTemperature(current: current, low: low, high: high)
    }
}
