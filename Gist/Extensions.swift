//
//  AlertsController.swift
//  Gist
//
//  Created by William Oliveira de Lagos on 18/04/2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            print("You've pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showToast(message: String, seconds: Double = 2.0) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
       let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
    }
   
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
}
