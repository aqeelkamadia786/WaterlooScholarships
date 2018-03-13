//
//  FavouritesTableViewController.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2017-10-15.
//  Copyright © 2017 Aqeel Kamadia. All rights reserved.
//

import Foundation
import UIKit

class FavouritesTableViewController: UITableViewController, NSKeyedUnarchiverDelegate {
    
    var scholarships: [Scholarship] = []
    var cellType = CellType.scholarshipCell
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ErrorTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ErrorTableViewCell")
        if let favouritesData = defaults.object(forKey: "Favourites") as? Data {
            scholarships = NSKeyedUnarchiver.unarchiveObject(with: favouritesData) as! [Scholarship]
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Get scholarships from UserDefaults
        if let favouritesData = defaults.object(forKey: "Favourites") as? Data {
            scholarships = NSKeyedUnarchiver.unarchiveObject(with: favouritesData) as! [Scholarship]
            tableView.reloadData()
        }
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
        if scholarships.count == 0 {
            cellType = .errorCell
            return 1
        }
        cellType = .scholarshipCell
        return scholarships.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellType {
        case .errorCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ErrorTableViewCell", for: indexPath) as! ErrorTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesTableViewCell", for: indexPath) as! FavouritesTableViewCell
            cell.title.text = scholarships[indexPath.row].title
            cell.value.text = scholarships[indexPath.row].value
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            scholarships.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: scholarships), forKey: "Favourites")
            defaults.synchronize()
        }
    }
    
}
