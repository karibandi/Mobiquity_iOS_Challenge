//
//  ViewController.swift
//  WeatherApp
//
//  Created by Surendra Karibandi on 06/06/21.
//

import UIKit
import MapKit


protocol HandleMapSearch {
    func dropPinZoomIn(placemark:Placemark)
}

class ViewController: UIViewController {
    @IBOutlet weak var citiesList: UITableView!
    
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var infoButton: UIButton!
    

    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    var placeMarkArray = [String]()
    private var viewModel = HomeViewModel()
    var tableFeed = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = appColor
        locationManagerFunction()
        setUpSearchController()
        setUpSearchbar()
        userInterfaceModifications()
    }
    
    func locationManagerFunction(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func setUpSearchController(){
        let locationSearchTable = UIStoryboard(name: "SearchResults", bundle: nil).instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        locationSearchTable.mapView = mapview
        locationSearchTable.handleMapSearchDelegate = self

        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as UISearchResultsUpdating
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    func setUpSearchbar() {
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.searchController = resultSearchController
    }
    
    func userInterfaceModifications(){
        infoButton.applyButtonCornerRadius(_cornerRadius: 20)
    }
    
    @IBAction func infoButton(_ sender: Any) {
        let webview = storyboard?.instantiateViewController(identifier: "RulesScreenController") as! RulesScreenController
        present(webview, animated: true, completion: nil)
    }
}

extension ViewController : CLLocationManagerDelegate {
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.mapview.setRegion(region, animated: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("manager didFailWithError: \(error.localizedDescription)")
    }
}

extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:Placemark){
        
        resultSearchController?.searchBar.text  = nil
        selectedPin = placemark.toMKPlacemark
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        var dict = [String:Any]()
        dict["name"] = placemark.name
        dict["latitude"] = placemark.coordinate.latitude
        dict["longitude"] = placemark.coordinate.longitude
        tableFeed.append(dict)
        placeMarkArray.append(placemark.name!)
        mapview.addAnnotation(annotation)
        citiesList.reloadData()
        let span =  MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapview.setRegion(region, animated: true)
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = tableFeed[indexPath.row]
        let cityView = storyboard?.instantiateViewController(identifier: "CityScreenController") as! CityScreenController
        cityView.latitude = data["latitude"] as? Double
        cityView.longitude = data["longitude"] as? Double
        self.navigationController?.pushViewController(cityView, animated: true)
        
    }
    
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableFeed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let data = tableFeed[indexPath.row]
        cell.textLabel?.text = (data["name"] as! String)
        return cell
    }
}
