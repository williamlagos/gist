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
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var accessToken: UITextField!
    var gistID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        comment.layer.cornerRadius = 5
        comment.layer.borderColor = UIColor.cyan.cgColor
        comment.layer.borderWidth = 1
    }
    
    @IBAction func sendComment(_ sender: Any) {
        self.postGistComments()
        self.dismiss(animated: true, completion: nil)
    }
    
    func postGistComments() {
        let url = URL(string: "https://api.github.com/gists/\(self.gistID ?? "15370631fbb749e6db776f013a1ef8ad")/comments")!
        var request = URLRequest(url: url)
        let parameters = ["body": comment.text ]
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        let token = accessToken.text!.isEmpty ? ProcessInfo.processInfo.environment["accessToken"] : accessToken.text
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
