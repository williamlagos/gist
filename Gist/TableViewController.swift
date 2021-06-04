//
//  TableViewController.swift
//  Gist
//
//  Created by William Oliveira de Lagos on 18/04/2021.
//

import Foundation
import UIKit

public struct GistComment: Codable {

    public var id: Int
    public var nodeId: String
    public var url: String
    /** The comment text. */
    public var body: String
    public var createdAt: Date
    public var updatedAt: Date

    public init(id: Int, nodeId: String, url: String, body: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.nodeId = nodeId
        self.url = url
        self.body = body
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case nodeId = "node_id"
        case url
        case body
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

}

class TableViewController : UITableViewController {
    var comments = ["ABC", "DEF"]
    var qrData: QRData?
    var gistID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.retrieveGistComments(gistURL: (qrData?.codeString)!)
        self.tableView.reloadData()
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
                self.comments = try JSONDecoder.decode([GistComment].self, from: string)
                return
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
        // Fetches the appropriate meal for the data source layout.
        let comment = comments[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.textLabel?.text = comment
        return cell
    }
    
    func handleClientError(error: Error) {
        print(error)
    }
    
    func handleServerError(response: URLResponse) {
        print(response)
    }
    
}


extension TableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "submitSegue", let viewController = segue.destination as? DetailViewController {
            viewController.gistID = self.gistID
        }
    }
    
}
