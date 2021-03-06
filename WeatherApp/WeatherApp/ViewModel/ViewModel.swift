//
//  Model.swift
//  WeatherApp
//
//  Created by Surendra Karibandi on 06/06/21.
//

import Foundation
import MapKit.MKPlacemark
import UIKit

protocol HomeViewModelProtocol {
    func reloadHomeScreenWith(annotation:MKPointAnnotation)
    func reloadHomeScreenAfterAnnotation(annotationToRemoce:MKPointAnnotation)
}

class HomeViewModel{

    var tableFeed = [[String:Any]]()
    var viewModelDelegate:HomeViewModelProtocol? = nil

    func prepareMapViewDataGiven(placemark:Placemark) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        var dict = [String:Any]()
        dict["name"] = placemark.name
        dict["latitude"] = placemark.coordinate.latitude
        dict["longitude"] = placemark.coordinate.longitude
        tableFeed.append(dict)
        viewModelDelegate?.reloadHomeScreenWith(annotation: annotation)
    }
    func removeAnnotation(latitude:Double, longitude:Double) {
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotationToRemove = MKPointAnnotation()
        annotationToRemove.coordinate = coordinate
        viewModelDelegate?.reloadHomeScreenAfterAnnotation(annotationToRemoce: annotationToRemove)
        
    }
}

