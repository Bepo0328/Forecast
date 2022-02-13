//
//  ForecaseUseCase.swift
//  Forecast
//
//  Created by 전윤현 on 2022/02/13.
//

import Foundation

protocol ForecastUseCase {
    func requestForecast(at date: Date, completion: @escaping ((Result<DailyWeather, Error>) -> ()))
}
