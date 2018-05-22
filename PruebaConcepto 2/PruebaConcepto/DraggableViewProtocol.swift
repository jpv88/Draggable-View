//
//  DraggableViewProtocol.swift
//  PruebaConcepto
//
//  Created by Jared Perez Vega on 18/2/18.
//  Copyright © 2018 Jared Perez Vega. All rights reserved.
//

import UIKit

@objc protocol DraggableViewProtocol {
    var parent: UIViewController { get set }
    var tableView: UITableView! { get set }
    var cellHeight: CGFloat { get set }
    var isCollapsed: Bool { get set }
    var topConstraint: NSLayoutConstraint { get set }
    var lastOrientation: UIDeviceOrientation { get set }
}

extension DraggableViewProtocol {
    
    func setupListView() {
        
        self.parent.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.leadingAnchor.constraint(equalTo: self.parent.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.parent.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: parent.view.safeAreaLayoutGuide.heightAnchor).isActive = true
        
        // Update all the time this constraint
        topConstraint = tableView.topAnchor.constraint(equalTo: parent.view.safeAreaLayoutGuide.topAnchor)
        if deviceType() == UIUserInterfaceIdiom.phone {
            topConstraint.constant = getCurrentPosition()
        } else {
            topConstraint.constant = UIScreen.main.bounds.height - cellHeight - 20
        }
        topConstraint.isActive = true
        isCollapsed = true
        
    }
    
    func reDrawComponent() {
        if isCollapsed {
            if deviceType() == UIUserInterfaceIdiom.pad {
                topConstraint.constant = UIScreen.main.bounds.width - cellHeight - 20
            } else {
                topConstraint.constant = getCurrentPosition()
            }
        }
        lastOrientation = UIDevice.current.orientation
    }
    
    private func getCurrentPosition() -> CGFloat {
        var constant: CGFloat = 0.0
        switch UIApplication.shared.statusBarOrientation {
        case .portrait:
            constant = UIScreen.main.bounds.height - cellHeight - 20
            break
        case .portraitUpsideDown:
            constant = UIScreen.main.bounds.height - cellHeight - 20
            break
        case .landscapeLeft:
            constant = UIScreen.main.bounds.height - cellHeight
            break
        case .landscapeRight:
            constant = UIScreen.main.bounds.height - cellHeight
            break
        case .unknown:
            break
        }
        return constant
    }
    
    private func deviceType()  -> UIUserInterfaceIdiom {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return UIUserInterfaceIdiom.phone
        case .pad:
            return UIUserInterfaceIdiom.pad
        case .unspecified:
            break
        case .tv:
            break
        case .carPlay:
            break
        }
        return UIUserInterfaceIdiom.unspecified
    }
    
    func updateListViewToTop() {
        self.topConstraint.constant = 0
    }
    
    func updateListViewToTopWithAnimation(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.5, animations: {
            self.topConstraint.constant = 0
            self.parent.view.layoutIfNeeded()
        }) { _ in
            self.isCollapsed = false
            completion()
        }
    }
    
    func updateListViewToBot() {
        topConstraint.constant = getCurrentPosition()
        isCollapsed = true
    }
    
    func updateListViewToBottomWithAnimation(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.5, animations: {
            if self.deviceType() == UIUserInterfaceIdiom.phone {
                self.topConstraint.constant = self.getCurrentPosition()
            } else {
                self.topConstraint.constant = UIScreen.main.bounds.height - self.cellHeight - 20
            }
//            self.topConstraint.constant = self.parent.view.frame.height - self.cellHeight - 20
//                self.topConstraint.constant = self.parent.view.frame.height - self.cellHeight - 20
//            } else {
//                self.topConstraint.constant = self.getCurrentPosition()
//            }
            self.parent.view.layoutIfNeeded()
        }) { _ in
            self.isCollapsed = true
            completion()
        }
    }
    
}
