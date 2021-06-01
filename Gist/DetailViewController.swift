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
        retrieveGistComments(gistURL: detailLabel.text!)
        showToast(message : "Text copied to clipboard")
    }
    
    func retrieveGistComments(gistURL: String) {
        print(gistURL.components(separatedBy: "/"))
        let decoupledURL = gistURL.components(separatedBy: "/")
        let gistID = decoupledURL.last
        let url = URL(string: "https://api.github.com/gists/\(gistID ?? "15370631fbb749e6db776f013a1ef8ad")/comments")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.handleClientError(error: error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                self.handleServerError(response: response!)
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "text/html",
                let data = data,
                let string = String(data: data, encoding: .utf8) {
                print(string)
                /*DispatchQueue.main.async {
                    self.webView.loadHTMLString(string, baseURL: url)
                }*/
            }
        }
        task.resume()
    }
    
    func handleClientError(error: Error) {
        print(error)
    }
    
    func handleServerError(response: URLResponse) {
        print(response)
    }
    
}
