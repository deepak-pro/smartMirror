//
//  UIView+Extension.swift
//  Sphere
//
//  Created by Deepak on 12/5/18.
//  Copyright © 2018 D Developer. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func dismissKey(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
