//
//  TableViewDataSourceDelegate.swift
//  PruebaConcepto
//
//  Created by Jared Perez Vega on 18/2/18.
//  Copyright © 2018 Jared Perez Vega. All rights reserved.
//

import UIKit    
    
class DraggableTableViewController: NSObject, UITableViewDataSource, UITableViewDelegate {

    var data: [String]

    init(dataModel: [String]) {
        self.data = dataModel
    }

    func numberOfSections(in tableView: UITableView) -> Int {
     return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("click at: " + data[indexPath.row])
    }
    
    
}
