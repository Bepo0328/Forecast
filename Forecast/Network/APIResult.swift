//
//  APIResult.swift
//  Forecast
//
//  Created by 전윤현 on 2022/02/12.
//

import Foundation

struct APIResult: Codable {
    let response: Response
}

struct Response: Codable {
    let header: Header
    let body: Body
}

extension Response {
    struct Header: Codable {
        
        enum CodingKeys: String, CodingKey {
            case code = "resultCode"
            case message = "resultMsg"
        }
        
        let code: String
        let message: String
    }
    
    struct Body: Codable {
        
        enum CodingKeys: String, CodingKey {
            case items
            case pageNo
            case numberOfRows = "numOfRows"
            case totalCount
        }
        
        let items: Items
        let pageNo: Int
        let numberOfRows: Int
        let totalCount: Int
    }
}

extension Response.Body {
    struct Items: Codable {
        let list: [Item]
        
        enum CodingKeys: String, CodingKey {
            case list = "item"
        }
    }
    
    struct Item: Codable {
        
        enum CodingKeys: String, CodingKey {
            case data           = "baseDate"
            case baseTime       = "baseTime"
            case category
            case forecastDate   = "fcstDate"
            case forecastTime   = "fcstTime"
            case value          = "fcstValue"
            case x              = "nx"
            case y              = "ny"
        }
        
        let data: String
        let baseTime: String
        let category: String
        let forecastDate: String
        let forecastTime: String
        let value: String
        let x: Int
        let y: Int
    }
}
