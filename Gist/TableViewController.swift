//
//  TableViewController.swift
//  Gist
//
//  Created by William Oliveira de Lagos on 18/04/2021.
//

import Foundation
import UIKit

public struct GistComment: Codable {
    public var body: String
}

class TableViewController : UITableViewController {
    var comments = [GistComment]()
    var qrData: QRData?
    var gistID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveGistComments(gistURL: (qrData?.codeString)!)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        self.tableView.delegate = self
        self.tableView.dataSource = self        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.retrieveGistComments(gistURL: (qrData?.codeString)!)
    }
        
    func retrieveGistComments(gistURL: String) {
        // This function requests a given list of comments by Gist ID
        let decoupledURL = gistURL.components(separatedBy: "/")
        self.gistID = decoupledURL.last
        let url = URL(string: "https://api.github.com/gists/\(self.gistID ?? "15370631fbb749e6db776f013a1ef8ad")/comments")!
       
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
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
                let data = data,
                let string = String(data: data, encoding: .utf8) {
                do {
                    let decoder = JSONDecoder()
                    self.comments = try decoder.decode([GistComment].self, from: string.data(using: .utf8)!)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch let error{
                    print(error)
                }
            }
        }
        task.resume()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Returns the default number of sections, in this case, just one.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Override function for returning the number of rows.
        return comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetches the appropriate meal for the data source layout.
        let comment = comments[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.textLabel?.text = comment.body
        return cell
    }
    
    func handleClientError(error: Error) {
        // Simple client error handling, for debugging purposes.
        print(error)
    }
    
    func handleServerError(response: URLResponse) {
        // Simple server error handling, for debugging purposes.
        print(response)
    }
    
}


extension TableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Function for sending the gistID data to another viewController.
        if segue.identifier == "submitSegue", let viewController = segue.destination as? EditViewController {
            viewController.gistID = self.gistID
        }
    }
    
}
