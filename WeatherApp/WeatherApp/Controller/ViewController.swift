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

    private var viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = appColor
        locationManagerFunction()
        setUpSearchController()
        setUpSearchbar()
        userInterfaceModifications()
        
        //setup viewmodel
        viewModel.viewModelDelegate = self
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
        viewModel.prepareMapViewDataGiven(placemark: placemark)
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.tableFeed[indexPath.row]
        let cityView = storyboard?.instantiateViewController(identifier: "CityScreenController") as! CityScreenController
        cityView.cityModelView = CityViewModel.init(latitude: data["latitude"] as? Double ?? 0, longitude: data["longitude"] as? Double ?? 0)
        self.navigationController?.pushViewController(cityView, animated: true)
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableFeed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let data = viewModel.tableFeed[indexPath.row]
        cell.textLabel?.text = (data["name"] as! String)
        return cell
    }
}

extension ViewController: HomeViewModelProtocol{
    func reloadHomeScreenWith(annotation: MKPointAnnotation) {
        resultSearchController?.searchBar.text  = nil
        mapview.addAnnotation(annotation)
        citiesList.reloadData()
        let span =  MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapview.setRegion(region, animated: true)
    }
}

