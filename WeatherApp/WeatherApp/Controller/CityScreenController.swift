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
        cityModelView?.viewModelDelegate = self
        DispatchQueue.main.async {
            LoadingView.shared.show()
            self.cityModelView?.fetchWeatherDetail()
        }
    }
}

extension CityScreenController: CityViewModelProtocol {
    func sendErrorReport(errorMessage: Error) {
        DispatchQueue.main.async {
            LoadingView.shared.dismiss()
            let alertMessage = UIAlertController(title: "Something Went Wrong", message: errorMessage.localizedDescription, preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alertMessage, animated: true)
            
        }
    }
    
    func reloadCityScreen(cityScreenData: CityScreenData) {
        DispatchQueue.main.async {
            LoadingView.shared.dismiss()
            self.cityNameLabel.text = cityScreenData.cityNameValue
            self.temparatureLab.text = cityScreenData.temparatureValue
            self.humidityLabel.text = cityScreenData.humidityValue
            self.rainyStatusLabel.text = cityScreenData.rainyStatusValue
            self.windInfoLabel.text = cityScreenData.windInfoValue
        }
    }
    
}

