//
//  TableViewController.swift
//  Gist
//
//  Created by William Oliveira de Lagos on 18/04/2021.
//

import Foundation
import UIKit

class TableViewCell : UITableViewCell {
    
}

class TableViewController : UITableViewController {
    
    var comments = []()
    var qrData: QRData?
    var gistID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveGistComments(gistURL: qrData?.codeString)
    }
    
    func retrieveGistComments(gistURL: String) {
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
                comments.append(string)
            }
        }
        task.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? TableViewCell else {
                                                        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }

        // Fetches the appropriate meal for the data source layout.
        let comment = comments[indexPath.row]
        
        cell.textLabel?.text = comment.body

        return cell
    }
    
    extension TableViewController {
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "submitSegue", let viewController = segue.destination as? DetailViewController {
                viewController.gistID = self.gistID
            }
        }
        
    }
}
