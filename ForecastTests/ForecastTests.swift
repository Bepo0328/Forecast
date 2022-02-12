//
//  ForecastTests.swift
//  ForecastTests
//
//  Created by 전윤현 on 2022/02/12.
//

import XCTest
@testable import Forecast

let mockData = """
{"response":{"header":{"resultCode":"00","resultMsg":"NORMAL_SERVICE"},"body":{"dataType":"JSON","items":{"item":[{"baseDate":"20220212","baseTime":"0500","category":"TMP","fcstDate":"20220212","fcstTime":"0600","fcstValue":"-9","nx":55,"ny":127},{"baseDate":"20220212","baseTime":"0500","category":"UUU","fcstDate":"20220212","fcstTime":"0600","fcstValue":"2.1","nx":55,"ny":127},{"baseDate":"20220212","baseTime":"0500","category":"VVV","fcstDate":"20220212","fcstTime":"0600","fcstValue":"-2.7","nx":55,"ny":127},{"baseDate":"20220212","baseTime":"0500","category":"VEC","fcstDate":"20220212","fcstTime":"0600","fcstValue":"322","nx":55,"ny":127},{"baseDate":"20220212","baseTime":"0500","category":"WSD","fcstDate":"20220212","fcstTime":"0600","fcstValue":"3.4","nx":55,"ny":127}]},"pageNo":1,"numOfRows":5,"totalCount":809}}}
"""

class ForecastTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_날씨_데이터() {
        do {
            let data = mockData.data(using: .utf8)!
            let result = try? JSONDecoder().decode(APIResult.self, from: data)
            
            XCTAssertTrue(result != nil)
            XCTAssertTrue(result?.response.header.code == "00")
            XCTAssertTrue(result?.response.header.message == "NORMAL_SERVICE")
            
            XCTAssertTrue(result?.response.body.pageNo == 1)
            XCTAssertTrue(result?.response.body.numberOfRows == 5)
            XCTAssertTrue(result?.response.body.totalCount == 809)
            
            XCTAssertTrue(result?.response.body.items.list.count == 5)
            XCTAssertTrue(result?.response.body.items.list[0].category == "TMP")
        } catch {
            print(error)
        }
    }
}
