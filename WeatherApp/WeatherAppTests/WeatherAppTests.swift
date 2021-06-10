//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Surendra Karibandi on 06/06/21.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    
    
    var viewModel: CityViewModel? = nil
    var homeViewModel: HomeViewModel? = nil
    
    var service: HTTPManager!
    var sessionUnderTest : URLSession!
    var url: URL?
    
    
    override func setUp() {
        super.setUp()
        
        // setting default session configuration
        sessionUnderTest = URLSession(configuration : URLSessionConfiguration.default)
        let  weatherURL = "http://api.openweathermap.org/data/2.5/weather?lat=13.1&lon=80.3&appid=fae7190d7e6433ec3a45285ffcf55c86"
        // setting url string directy with query parameters
        url = URL(string: weatherURL)
    }
    
    
    //MARK: Slow failure Async test
    // API success test case
    func testAPISuccessStatus200(){
        
        // status code 200
        let promise = expectation(description: "Status code : 200")
        
        sessionUnderTest.dataTask(with: url!) { (data, response, error) in
            if let error = error{
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else{
                    XCTFail("Status code = \(statusCode)")
                }
            }
        }.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //MARK: Lat/long tests
    func testLatitude() {
        let latitude = viewModel?.latitude
        XCTAssertEqual(latitude, 10.56, "latitude mismatch")
    }
    
    func testLongitude() {
        let longitude = viewModel?.latitude
        XCTAssertEqual(longitude, 9.5644, "longitude mismatch")
    }
    
    func testcityDataCheck() {
        let data = homeViewModel?.tableFeed
        XCTAssertEqual(data?.count, 10, "city count mismatch found")
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }
    
}
