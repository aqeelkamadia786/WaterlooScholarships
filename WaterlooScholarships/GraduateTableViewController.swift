//
//  GraduateTableViewController.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2017-10-15.
//  Copyright © 2017 Aqeel Kamadia. All rights reserved.
//

import Foundation
import UIKit

class GraduateTableViewController: UITableViewController {
    
    let networkManager = NetworkManager()
    var scholarships: [Scholarship] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.getGraduate(completion: { object in
            let grads = object["data"] as! [[String: AnyObject]]
            for grad in grads {
                self.scholarships.append(Scholarship(with: grad))
            }
            print(self.scholarships.count)
            self.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let viewController = segue.destination as! DetailsViewController
            viewController.scholarship = scholarships[indexPath.row]
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(scholarships.count)
        return scholarships.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GraduateTableViewCell", for: indexPath) as! GraduateTableViewCell
        cell.title.text = scholarships[indexPath.row].title
        return cell
    }
}
