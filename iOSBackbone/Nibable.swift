//
//  Nibable.swift
//  iOSBackbone
//
//  Created by Giorgy Gunawan on 8/10/20.
//  Copyright © 2020 joji. All rights reserved.
//

import Foundation
import UIKit
extension UIView: Nibable {}

extension UIViewController: Nibable {}

protocol Nibable: class {
    static func nibName() -> String
    static func nib() -> UINib
    static func identifier() -> String
    static func bundle() -> Bundle
}

extension Nibable {
    static func nibName() -> String {
        return identifier().components(separatedBy: ".").last!.components(separatedBy: "<").first!
    }
    
    static func nib() -> UINib {
        let nib = UINib(nibName: nibName(), bundle: Bundle.main)
        return nib
    }
    
    static func identifier() -> String {
        return "\(self)"
    }
    
    static func bundle() -> Bundle {
        return Bundle.main
    }
}
