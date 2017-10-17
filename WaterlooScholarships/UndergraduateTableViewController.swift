//
//  UndergraduateTableViewController.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2017-10-12.
//  Copyright © 2017 Aqeel Kamadia. All rights reserved.
//

import Foundation
import UIKit

class UndergraduateTableViewController: UITableViewController {
    
    let networkManager = NetworkManager()
    var scholarships: [Scholarship] = []
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.getUndergraduate(completion: { object in
            let undergrads = object["data"] as! [[String: AnyObject]]
            for undergrad in undergrads {
                self.scholarships.append(Scholarship(with: undergrad))
            }
            print(self.scholarships.count)
            // Can't save [Scholarship] to UserDefaults
            let defaults = UserDefaults.standard
            let item = [self.scholarships[0]] as [Scholarship]
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: item), forKey: "Favourites")
            for i in 1..<10 {
                var array = NSKeyedUnarchiver.unarchiveObject(with: defaults.object(forKey: "Favourites") as! Data) as! [Scholarship]
                array.append(self.scholarships[i])
                defaults.set(NSKeyedArchiver.archivedData(withRootObject: array), forKey: "Favourites")
                defaults.synchronize()
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "UndergraduateTableViewCell", for: indexPath) as! UndergraduateTableViewCell
        cell.title.text = scholarships[indexPath.row].title
        return cell
    }

}
