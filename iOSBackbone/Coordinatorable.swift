//
//  Coordinatorable.swift
//  iOSBackbone
//
//  Created by Giorgy Gunawan on 8/10/20.
//  Copyright © 2020 joji. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinatorable: class {
    associatedtype ControllerType
    var mainNavigationController: ControllerType { get }
    func dismiss(handler: (() -> Void)?)
    func pop()
    func popToRoot()
}

protocol CoordinatorSource {
    var coordinatorDelegate: CoordinatorDelegate? { get set }
}

extension Coordinatorable where ControllerType: UIViewController {
    func dismiss(handler: (() -> Void)?) {
        mainNavigationController.dismiss(animated: true, completion: handler)
    }
    
    func pop() {
        mainNavigationController.navigationController?.popViewController(animated: true)
    }
    
    func popToRoot() {
        mainNavigationController.navigationController?.popToRootViewController(animated: true)
    }
}

extension Coordinatorable where ControllerType: UINavigationController {
    func dismiss(handler: (() -> Void)?) {
        mainNavigationController.dismiss(animated: true, completion: handler)
    }
    
    func pop() {
        mainNavigationController.popViewController(animated: true)
    }
    
    func popToRoot() {
        mainNavigationController.popToRootViewController(animated: true)
    }
}

// MARK: - Base Coordinator

protocol CoordinatorDelegate: class {
    func dismissController(handler: (() -> Void)?)
    func popController()
    func popToRootController()
}

extension CoordinatorDelegate where Self: Coordinatorable {
    func dismissController(handler: (() -> Void)?) {
        self.dismiss(handler: handler)
    }
    
    func popController() {
        self.pop()
    }
    
    func popToRootController() {
        self.popToRoot()
    }
}
