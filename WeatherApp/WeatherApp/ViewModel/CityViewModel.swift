//
//  CityViewModel.swift
//  WeatherApp
//
//  Created by Surendra Karibandi on 07/06/21.
//

import Foundation

class CityViewModel {
    init(model: CityModel?) {
        if let inputModel = model {
            cityData = inputModel
        }
    }
    var cityData: CityModel?
}

extension CityViewModel{
    
    func fetchWeatherData(completion: @escaping (Result<CityModel, Error>) -> Void) {
            HTTPManager.shared.get(urlString: weatherURL , completionBlock: { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .failure(let error):
                    print ("failure", error)
                case .success(let data) :
                    let decoder = JSONDecoder()
                    do
                    {
                        self.cityData = try decoder.decode(CityModel.self, from: data)
                        completion(.success(try decoder.decode(CityModel.self, from: data)))
                    } catch {
                        // deal with error from JSON decoding if used in production
                        print(error)
                    }
                }
            })
        }
}
