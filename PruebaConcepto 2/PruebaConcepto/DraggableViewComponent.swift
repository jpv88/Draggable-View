//
//  DraggableViewComponent.swift
//  PruebaConcepto
//
//  Created by Jared Perez Vega on 18/2/18.
//  Copyright © 2018 Jared Perez Vega. All rights reserved.
//

import UIKit

class DraggableViewComponent: DraggableViewProtocol {
    
    var lastOrientation: UIDeviceOrientation
    
    var isCollapsed: Bool
    
    var topConstraint: NSLayoutConstraint
    
    var cellHeight: CGFloat
    
    var parent: UIViewController
    
    var data: [String]!
    
    var tableView: UITableView
    
    var delegate: DraggableTableViewController!
    
    var avoidFirstRotation = false
    
    var panGesture = UIPanGestureRecognizer()
    
    var distanceTraveled: CGFloat = 0.0
    
    var firstPoint: CGPoint = CGPoint(x: 0, y: 0)
        
    init(parent: UIViewController, dataModel: Any) {
        self.parent = parent
        self.cellHeight = 30.0
        self.isCollapsed = true
        self.topConstraint = NSLayoutConstraint.init()
        self.lastOrientation = UIDevice.current.orientation
        if let data = dataModel as? [String] {
            self.data = data
        }
        self.tableView = UITableView()
        delegate = DraggableTableViewController(dataModel: data)
        tableView.delegate = delegate
        tableView.dataSource = delegate
        tableView.bounces = false
        tableView.rowHeight = cellHeight
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(DraggableViewComponent.draggedView(_:)))
        panGesture.cancelsTouchesInView = true        
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(panGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(DraggableViewComponent.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func setup() {
        setupListView()
        parent.view.layoutIfNeeded()
    }
    
    @objc func rotated() {
        if self.avoidFirstRotation {
            if UIDevice.current.orientation != self.lastOrientation {
                self.reDrawComponent()
            }
        }
        self.avoidFirstRotation = true
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        let translation = sender.translation(in: parent.view)
        let tablePositionY = tableView.frame.origin.y + translation.y
        if (tablePositionY > 20) && (tablePositionY < parent.view.frame.height - cellHeight) {
            tableView.center = CGPoint(x: tableView.center.x, y: tableView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: parent.view)
            if sender.state == UIGestureRecognizerState.ended {
                sender.isEnabled = false
                if isCollapsed {
                    updateListViewToTopWithAnimation(completion: {
                        sender.isEnabled = true
                    })
                } else {
                    updateListViewToBottomWithAnimation(completion: {
                        sender.isEnabled = true
                    })
                }
            }
        }
    }
    
    func removeDraggableView() {
        NotificationCenter.default.removeObserver(self)
        tableView.removeFromSuperview()
    }
}
