//
//  RouteListViewController.swift
//  Tripper
//
//  Created by Denis Cherniy on 03.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit

class RouteListViewController: UITableViewController {
    
    var route: RouteDataModel!
    
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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // This formula calculate overall number of route points and roads.
        return route.points.count * 2 - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 { // Route Stop Point
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.routePointCell, for: indexPath) as! RoutePointCell
            
            // We divide indexPath.row by 2 to conform index of route point in route.points array.
            cell.configure(for: route.points[indexPath.row / 2])
            
            return cell
        } else { // Road
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.roadCell, for: indexPath) as! RoadCell
            
            let currentRoutePointIndex = indexPath.row / 2
            cell.configureRoad(from: route.points[currentRoutePointIndex], to: route.points[currentRoutePointIndex + 1])
            
            return cell
        }
        
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
