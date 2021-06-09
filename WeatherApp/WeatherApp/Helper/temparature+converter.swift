//
//  temparature+converter.swift
//  WeatherApp
//
//  Created by Surendra Karibandi on 09/06/21.
//

import Foundation

import Foundation

struct TemperatureConverter {
    
    // MARK: convert kelvis to Celsius
    static func kelvinToCelsius(_ degrees: Double) -> Int {
        return Int(round(degrees - 273.15))
    }
    
    // MARK: convert kelvis to Fahrenheit
    static func kelvinToFahrenheit(_ degrees: Double) -> Int {
        return Int(round(degrees * 9 / 5 - 459.67))
    }
}
