//
//  RouteListViewController.swift
//  Tripper
//
//  Created by Denis Cherniy on 03.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit

class RouteListViewController: UITableViewController {
    
    var subroutes: [Subroute]!
    
    struct TableView {
        struct CellIdentifiers {
            static let roadCell = "RoadCell"
            static let routePointCell = "RoutePointCell"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var cellNib = UINib(nibName: TableView.CellIdentifiers.roadCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.roadCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.routePointCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.routePointCell)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subroutes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let anotherSubroute = subroutes[indexPath.row]
        
        switch anotherSubroute {
        case is InRoad:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.roadCell, for: indexPath) as! RoadCell
            
            cell.configure(for: anotherSubroute as! InRoad)
            
            return cell
            
        case is Staying:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.routePointCell, for: indexPath) as! RoutePointCell
            
            cell.configure(for: anotherSubroute as! Staying)
            
            return cell
            
        default:
            display(message: "*** It's impossible to be here!")
            return UITableViewCell()
        }
        
    }

}
