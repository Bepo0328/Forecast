//
//  DailyWeather.swift
//  Forecast
//
//  Created by 전윤현 on 2022/02/13.
//

import Foundation

enum Sky {
    case sunny
    case cloudy
    case rainy
    case snow
}

struct DailyTemperature {
    let current: Double
    let low: Double
    let high: Double
}

struct DailyWeather {
    let sky: Sky
    let temerature: DailyTemperature
}
