//
//  ViewController.swift
//  PruebaConcepto
//
//  Created by Jared Perez Vega on 18/2/18.
//  Copyright © 2018 Jared Perez Vega. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let array = ["perro", "gato", "delfín", "elefante", "león"]
    
    var object: DraggableViewComponent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Always create the object in viewDidLoad
        object = DraggableViewComponent(parent: self, dataModel: array)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Add tableView Component to view as subview
        object?.setup()
    }
}

