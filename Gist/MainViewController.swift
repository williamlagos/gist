//
//  ViewController.swift
//  Gist
//
//  Created by William Oliveira de Lagos on 17/04/2021.
//

import UIKit
import Foundation

struct QRData {
    var codeString: String?
}

class MainViewController: UIViewController {

    @IBOutlet weak var scannerView: ScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    
    var qrData: QRData? = nil {
        didSet {
            if qrData != nil {
                self.performSegue(withIdentifier: "detailSegue", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }
    
}

extension MainViewController : ScannerViewDelegate {
    
    func scanningDidStop() {
        // Stub for the stopped scanning.
    }
    
    func scanningDidFail() {
        // Stub for the failed scanning.
    }
    
    func scanningSucceededWithCode(_ str: String?) {
        // When scanning successful, pass the QRData codeString.
        self.qrData = QRData(codeString: str)
        performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
}

extension MainViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Function for sending the qrData to the next ViewController.
        if segue.identifier == "detailSegue", let viewController = segue.destination as? TableViewController {
            viewController.qrData = self.qrData
        }
    }
    
}
