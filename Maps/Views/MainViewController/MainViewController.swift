//
//  ViewController.swift
//  Maps
//
//  Created by Bodya on 18.03.2018.
//  Copyright © 2018 Bodya. All rights reserved.
//

import UIKit
import GooglePlaces


class MainViewController: UIViewController {

    @IBOutlet weak var googleMapView: GoogleMapsView!
    @IBOutlet weak var originBt: UIButton!
    @IBOutlet weak var arrivalBt: UIButton!
    @IBOutlet weak var otherBt: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let routeManager = RouteManager.shared
    
    private var presedButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset = .zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        googleMapView.setupWithRoute(route: routeManager.representRoute)
    }
    
    @IBAction func startActionBt(_ sender: Any) {
        if routeManager.representRoute.origin == nil || routeManager.representRoute.destination == nil {
            showAlert(string: Constants.mainVCAlert)
        } else {
            routeManager.directionFor(route: routeManager.representRoute, complition: { (path, polilyne) in
                self.googleMapView.writePolilyne(polilyne: polilyne)
                self.googleMapView.animateCar(marker: CarMarker(), forPath: path, complition: {
                    self.routeManager.saveRoute(route: self.routeManager.representRoute)
                    self.routeManager.newRepresentRoute()
                    self.clearState()
                })
            }, failure: {
                self.showAlert(string:Constants.mainVCDirectionFailure)
            })
        }
    }
    
    @IBAction func selectLocationActionBt(_ sender: UIButton) {
        if sender == originBt, routeManager.representRoute.waypoints.count >= 5 {
            showAlert(string: Constants.mainVCAlertWaipoint)
        }
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        presedButton = sender
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func clearBt(_ sender: Any) {
        clearState()
    }
    
    func addPlace(place: GMSPlace) {
        if presedButton == originBt {
            routeManager.representRoute.origin = Location(place.coordinate, place.name)
            originBt.setTitle(place.name, for: .normal)
        }
        if presedButton == arrivalBt {
            routeManager.representRoute.destination = Location(place.coordinate, place.name)
            arrivalBt.setTitle(place.name, for: .normal)
        }
        if presedButton == otherBt {
            routeManager.representRoute.addWaypoint(location: Location(place.coordinate, place.name))
            tableView.reloadData()
        }
        googleMapView.setupWithRoute(route: routeManager.representRoute)
    }
    
    func clearState() {
        googleMapView.googleMap.clear()
        routeManager.newRepresentRoute()
        tableView.reloadData()
        originBt.setTitle(Constants.mainVCOriginBtText, for: .normal)
        arrivalBt.setTitle(Constants.mainVCArrivalBtText, for: .normal)
        otherBt.setTitle(Constants.mainVCOtherBtText, for: .normal)
    }
    
    func showAlert(string: String) {
        let alert = UIAlertController(title: nil, message: string, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        addPlace(place: place)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeManager.representRoute.waypoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Constants.mainVCCell)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: Constants.mainVCCell)
        }
        cell?.textLabel?.text = routeManager.representRoute.waypoints[indexPath.row].name
        return cell!
    }
}

extension MainViewController: UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            routeManager.representRoute.removeWaypoint(atIndex: indexPath.row)
            googleMapView.setupWithRoute(route: routeManager.representRoute)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

