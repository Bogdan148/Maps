//
//  AllRoutesViewController.swift
//  Maps
//
//  Created by Bodya on 20.03.2018.
//  Copyright © 2018 Bodya. All rights reserved.
//

import UIKit

class AllRoutesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let routeManager = RouteManager.shared
    var dataSource = RouteManager.shared.allSavedRoutes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset = .zero
    }
}

extension AllRoutesViewController: UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Constants.allRoutesVCCell) as? AllRouteTableViewCell
        if cell == nil {
            cell = AllRouteTableViewCell(style: .default, reuseIdentifier: Constants.allRoutesVCCell)
        }
        cell?.originLabel.text = "From: \(String(describing: dataSource[indexPath.row].origin!.name))"
        cell?.arrivalLabel.text = "To: \(String(describing: dataSource[indexPath.row].destination!.name))"
        cell?.waypointsLabel.text = "Waypoints count: \(dataSource[indexPath.row].waypoints.count)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            routeManager.deleteRoute(route: dataSource[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

extension AllRoutesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        routeManager.representRoute = dataSource[indexPath.row]
        navigationController?.popToRootViewController(animated: true)
    }
}

class AllRouteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var waypointsLabel: UILabel!

}
