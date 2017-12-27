//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Srinivas Kasanna on 12/26/17.
//  Copyright © 2017 asdf. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    
    var weatherVC : WeatherViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        weatherVC = WeatherViewController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        weatherVC = nil
    }
    
    //ServiceTests
    func testOpenWeatherURLIsNotEmpty() {
        let url = WeatherUtils.searchURLByCity(city: "Dallas")
        XCTAssertNotNil(url)
    }
    func testOpenWeatherUrlForCity() {
        let url = WeatherUtils.searchURLByCity(city: "Dallas")
        XCTAssertEqual(url, URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Dallas,US&appid=214c5ece3ab2c6620d26a515e588ace5"))
    }
    func testOpenWeatherService() {
        let url = WeatherUtils.searchURLByCity(city: "Dallas")
        WebServiceManager.getWeatherInformation(url: url) { (resultData, error) in
            XCTAssertNotNil(resultData)
        }
    }
    
    //MARK:- Positive TestCases
    func testServiceWithJsonValidDataBool() {
        let viewModal = WeatherViewController()
        viewModal.weatherInfoResponse = WeatherDataModel.init(json: kMockJsonValidResponse)
        XCTAssertNotNil(viewModal.weatherInfoResponse)
    }
    
    func testServiceWithJsonValidDataWeather() {
        let viewModal = WeatherViewController()
        viewModal.weatherInfoResponse = WeatherDataModel.init(json: kMockJsonValidResponse)
        XCTAssertNotNil(viewModal.weatherInfoResponse?.weather)
    }
    
    func testServiceWithJsonValidDataMain() {
        let viewModal = WeatherViewController()
        viewModal.weatherInfoResponse = WeatherDataModel.init(json: kMockJsonValidResponse)
        XCTAssertNotNil(viewModal.weatherInfoResponse?.main)
    }
    
    func testServiceWithJsonValidData() {
        let viewModal = WeatherViewController()
        viewModal.weatherInfoResponse = WeatherDataModel.init(json: kMockJsonValidResponse)
        XCTAssertEqual(viewModal.weatherInfoResponse?.name, "Dallas")
    }
    
    func testServiceWithJsonValidDataSys() {
        let viewModal = WeatherViewController()
        viewModal.weatherInfoResponse = WeatherDataModel.init(json: kMockJsonValidResponse)
        XCTAssertNotNil(viewModal.weatherInfoResponse?.sys)
    }
    
    func testServiceWithJsonValidCountry() {
        let viewModal = WeatherViewController()
        viewModal.weatherInfoResponse = WeatherDataModel.init(json: kMockJsonValidResponse)
        XCTAssertEqual(viewModal.weatherInfoResponse?.sys?.country, "US")
    }
    
    //MARK:- JSON with Empty Resposne
    func testServiceWithEmptyJson() {
        let viewModal = WeatherViewController()
        viewModal.weatherInfoResponse = WeatherDataModel.init(json: JSON())
        XCTAssertNotNil(viewModal.weatherInfoResponse)
    }
    
    func testServiceWithEmptyJsonMain() {
        let viewModal = WeatherViewController()
        viewModal.weatherInfoResponse = WeatherDataModel.init(json: JSON())
        XCTAssertNil(viewModal.weatherInfoResponse?.main)
    }
    
    //Negative Test cases
    func testServiceWithMissingWeatherJson() {
        let viewModal = WeatherViewController()
        viewModal.weatherInfoResponse = WeatherDataModel.init(json: kMockJsonInValidWeatherMissing)
        XCTAssertNil(viewModal.weatherInfoResponse?.weather)
        XCTAssertNotNil(viewModal.weatherInfoResponse?.main)
    }
    func testServiceWithMissingWeatherJsonMainCheck() {
        let viewModal = WeatherViewController()
        viewModal.weatherInfoResponse = WeatherDataModel.init(json: kMockJsonInValidWeatherMissing)
        XCTAssertNotNil(viewModal.weatherInfoResponse?.main)
    }
    
    func testServiceWithMissingValuesInJson() {
        let viewModal = WeatherViewController()
        viewModal.weatherInfoResponse = WeatherDataModel.init(json: kMockJsonInValidWeatherMissing)
        XCTAssertNotNil(viewModal.weatherInfoResponse?.main)
    }
    
    func testServiceWithMissingValuesInJsonGetValue() {
        let viewModal = WeatherViewController()
        viewModal.weatherInfoResponse = WeatherDataModel.init(json: kMockJsonInValidValues)
        XCTAssertNotNil(viewModal.weatherInfoResponse?.main?.temp_max)
    }

    
}
