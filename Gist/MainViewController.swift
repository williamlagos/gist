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
        // Do any additional setup after loading the view.
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
    
    @IBAction func scanButtonAction(_ sender: UIButton) {
        scannerView.isRunning ? scannerView.stopScanning() : scannerView.startScanning()
        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
        sender.setTitle(buttonTitle, for: .normal)
    }
    
}

extension MainViewController : ScannerViewDelegate {
    
    func scanningDidStop() {
//        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
//        scanButton.setTitle(buttonTitle, for: .normal)
    }
    
    func scanningDidFail() {
        
    }
    
    func scanningSucceededWithCode(_ str: String?) {
        self.qrData = QRData(codeString: str)
        performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
}

extension MainViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue", let viewController = segue.destination as? TableViewController {
            viewController.qrData = self.qrData
        }
    }
    
}
