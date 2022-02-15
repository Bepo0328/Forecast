//
//  ViewController.swift
//  Forecast
//
//  Created by 전윤현 on 2022/02/12.
//

import UIKit

extension Double {
    func asTemperature() -> String {
        return floor(self) == self ? "\(Int(self))" : "\(self)"
    }
}

extension Sky {
    var image: UIImage {
        switch self {
        case .sunny:
            return UIImage(named: "clear")!
        case .cloudy:
            return UIImage(named: "cloudy")!
        case .rainy:
            return UIImage(named: "rain")!
        case .snow:
            return UIImage(named: "rain")!
        }
    }
}

class MainViewController: UIViewController {
    let useCase: ForecastUseCase = NetworkForecastUseCase()
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var iconView: UIImageView!
    @IBOutlet weak private var temperatureLabel: UILabel!
    @IBOutlet weak private var lowHighTemperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iconView.image = nil
        self.temperatureLabel.text = "-"
        self.lowHighTemperatureLabel.text = "최고 - / 최저 - "
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(requestForecast), for: .valueChanged)
        self.scrollView.refreshControl = refreshControl
    }
    
    func updateForecast(_ data: DailyWeather?) {
        if let data = data {
            self.iconView.image = data.sky.image
            self.temperatureLabel.text = data.temerature.current?.asTemperature()
            self.lowHighTemperatureLabel.text = "최고 \(data.temerature.high?.asTemperature() ?? "-") / 최저 \(data.temerature.low?.asTemperature() ?? "-") "
        } else {
            self.iconView.image = nil
            self.temperatureLabel.text = "-"
            self.lowHighTemperatureLabel.text = "최고 - / 최저 - "
        }
    }
    
    @objc private func requestForecast() {
        useCase.requestForecast(at: Date(), completion: { [weak self] result in
            switch result {
            case let .success(data):
                self?.updateForecast(data)
            case let .failure(error):
                print(error)
                self?.updateForecast(nil)
            }
            self?.scrollView.refreshControl?.endRefreshing()
        })
    }
}

