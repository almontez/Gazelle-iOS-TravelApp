//
//  Keyboard.swift
//  Gazelle
//
//  Created by Angela Li Montez on 5/15/23.
//
//  Citation: https://www.cometchat.com/tutorials/how-to-dismiss-ios-keyboard-swift

import Foundation
import UIKit

extension UIViewController {
    func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}

