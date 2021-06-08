////
////  WeatherAppTests.swift
////  WeatherAppTests
////
////  Created by Surendra Karibandi on 06/06/21.
////
//
//import XCTest
//@testable import WeatherApp
//
//class WeatherAppTests: XCTestCase {
//
//    
//    var viewModel: CityViewModel? = nil
//
//    var service: HTTPManager!
//    var sessionUnderTest : URLSession!
//    var url: URL?
//
//
//    override func setUp() {
//        super.setUp()
//
//        // setting default session configuration
//        sessionUnderTest = URLSession(configuration : URLSessionConfiguration.default)
//        weatherURL = "http://api.openweathermap.org/data/2.5/weather?lat=13.1&lon=80.3&appid=fae7190d7e6433ec3a45285ffcf55c86"
//        // setting url string directy with query parameters
//        url = URL(string: weatherURL)
//    }
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//
//    //MARK: Slow failure Async test
//    // API success test case
//    func testAPISuccessStatus200(){
//
//        // status code 200
//        let promise = expectation(description: "Status code : 200")
//
//        sessionUnderTest.dataTask(with: url!) { (data, response, error) in
//            if let error = error{
//                XCTFail("Error: \(error.localizedDescription)")
//                return
//            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                if statusCode == 200 {
//                    promise.fulfill()
//                } else{
//                    XCTFail("Status code = \(statusCode)")
//                }
//            }
//        }.resume()
//        waitForExpectations(timeout: 5, handler: nil)
//    }
//}
