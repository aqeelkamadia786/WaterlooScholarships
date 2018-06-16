//
//  DetailsViewController.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2017-10-15.
//  Copyright © 2017 Aqeel Kamadia. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Enums

enum DetailSection {
    case title
    case value
    case description
    case programs
}

// MARK: - Class

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    var tableView: UITableView!
    var detailSection = DetailSection.title
    let titles = ["Title", "Value", "Description", "Programs"]
    var scholarship: Scholarship?
    var details: [[String]] = []
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupConstraints()
        setupDetails()
    }
    
    @IBAction func favouriteButtonPressed(_ sender: Any) {
        if let scholarship = scholarship {
            scholarship.favourited = !scholarship.favourited
            var array: [Scholarship] = []
            if let favouritesData = defaults.object(forKey: "Favourites") as? Data {
                array = NSKeyedUnarchiver.unarchiveObject(with: favouritesData) as! [Scholarship]
                array.append(scholarship)
            }   else {
                array.append(scholarship)
            }
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: array), forKey: "Favourites")
            defaults.synchronize()
            if scholarship.favourited {
                favouriteButton.isEnabled = false
            }   else {
                favouriteButton.isEnabled = true
            }
        }
        presentModal()
    }
    
    func presentModal() {
        let popup = UIAlertController(title: "Favourited", message: "This scholarship has been added to your favourites", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        popup.addAction(action)
        present(popup, animated: true, completion: nil)
    }

}

// MARK: - UITableViewDataSource Methods

extension DetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell else { fatalError("This should be a valid cell!") }
        cell.label.text = details[indexPath.section][indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section]
    }

}

// MARK: - UITableViewDelegate Methods

extension DetailsViewController: UITableViewDelegate {

}

// MARK: - Private Methods

private extension DetailsViewController {

    func setupSubviews() {
        tableView = UITableView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: view.frame.width, height: view.frame.height - 30.0), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "DetailTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DetailTableViewCell")
        view.addSubview(tableView)
    }

    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor)
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
    }

    func setupDetails() {
        if let scholarship = scholarship {
            title = scholarship.title
            details = [[scholarship.title], [scholarship.value], [scholarship.details], scholarship.programs]
            if let favouritesData = defaults.object(forKey: "Favourites") as? Data {
                let array = NSKeyedUnarchiver.unarchiveObject(with: favouritesData) as! [Scholarship]
                for item in array {
                    if item.title == scholarship.title {
                        scholarship.favourited = true
                        favouriteButton.isEnabled = false
                        return
                    }
                }
                scholarship.favourited = false
                favouriteButton.isEnabled = true
            }
        }
    }

}
