//
//  Model.swift
//  WeatherApp
//
//  Created by Surendra Karibandi on 06/06/21.
//

import Foundation
import MapKit.MKPlacemark


class HomeViewModel{
    private var _placemarks: [Placemark] = []
    
    var placemarks: [Placemark] = []
    var delegate: HandleMapSearch?


}

extension HomeViewModel{
    func add(placemark: Placemark){
        var placemarks = self._placemarks
        placemarks.append(placemark)
       
    }
    
    func deletePlacemark(at index: Int) {
        let placemark = placemarks[index]
        _placemarks.removeAll { (_placemark) -> Bool in
            return _placemark == placemark
        }
    }
    
    func placemark(at coordinate: CLLocationCoordinate2D) -> Placemark? {
        return _placemarks.first { (placemark) -> Bool in
            return placemark.coordinate.latitude == coordinate.latitude &&
                placemark.coordinate.longitude == coordinate.longitude
        }
    }
}
