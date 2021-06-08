//
//  CityScreenController.swift
//  WeatherApp
//
//  Created by Surendra Karibandi on 06/06/21.
//

import UIKit
import CoreLocation.CLLocation


class CityScreenController: UIViewController {
    
    var latitude: Double?
    var longitude : Double?
    var cityModel:CityModel? = nil
    var cityModelView : CityViewModel?
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var stackContainer: UIStackView!
    
    
    @IBOutlet weak var temparatureLab: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var rainyStatusLabel: UILabel!
    
    @IBOutlet weak var windInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            LoadingView.shared.show()
        }
        
        weatherURL = construct_url(latString: latitude?.toString() ?? "0", longiString: longitude?.toString() ?? "0")
        print(weatherURL)
        cityModelView = CityViewModel(model: cityModel)
        cityModelView?.fetchWeatherData { [weak self] dat in
            
            DispatchQueue.main.async {
                
                LoadingView.shared.dismiss()
                self?.cityNameLabel.text = self?.cityModelView?.cityData?.name
                
                guard let temparatureValue = self?.cityModelView?.cityData?.main?.temp else{
                    self?.temparatureLab.text = "N/A"
                    return
                }
                self?.temparatureLab.text = CITY_TEMPARATURE + String(temparatureValue)
                
                guard let humidityVal = self?.cityModelView?.cityData?.main?.humidity else{
                    self?.humidityLabel.text = "N/A"
                    return
                }
                self?.humidityLabel.text = CITY_HUMIDITY + String(humidityVal) + HUMIDITY_UNIT
                guard let rainStatus = self?.cityModelView?.cityData?.weather?[0].weatherDescription else{
                    self?.rainyStatusLabel.text = "N/A"
                    return
                }
                self?.rainyStatusLabel.text = RAIN_CHANCES +  rainStatus
                
                guard let windSpeed = self?.cityModelView?.cityData?.wind?.speed else{
                    self?.windInfoLabel.text = "N/A"
                    return
                }
                self?.windInfoLabel.text = WIND_SPEED + windSpeed.toString() + WIND_UNIT
            }
           
        }
    }
    

}

extension CityScreenController{
    func construct_url(latString:String, longiString:String) -> String {
        let url_string = "http://api.openweathermap.org/data/2.5/weather?lat=\(latString)&lon=\(longiString)&appid=fae7190d7e6433ec3a45285ffcf55c86"
        return url_string
    }
}
