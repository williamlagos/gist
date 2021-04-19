//
//  DetailViewController.swift
//  Gist
//
//  Created by William Oliveira de Lagos on 18/04/2021.
//
import UIKit
import Foundation

class DetailViewController : UIViewController {
    
    @IBOutlet weak var detailLabel: UILabel!
    var qrData: QRData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailLabel.text = qrData?.codeString
        UIPasteboard.general.string = detailLabel.text
        showToast(message : "Text copied to clipboard")
    }
    
}
