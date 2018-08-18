//
//  DetailsViewController.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2017-10-15.
//  Copyright © 2017 Aqeel Kamadia. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {

    // MARK: - Table Sections/Rows

    struct Section {

        static let title = 0

        static let value = 1

        static let description = 2

        static let programs = 3

        static let count = 4

    }

    // MARK: - Properties
    
    var favouriteButton: UIBarButtonItem!

    var tableView: UITableView!

    var scholarship: Scholarship?

    var details: [[String]] = []

    let defaults = UserDefaults.standard

    // MARK: - Initializers

    init(with scholarship: Scholarship) {
        self.scholarship = scholarship

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupConstraints()
        setupDetails()

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }

}

// MARK: - UITableViewDataSource Methods

extension DetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCell.reusableIdentifier, for: indexPath) as? DefaultTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = details[indexPath.section][indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.title:
            return "Title"
        case Section.value:
            return "Value"
        case Section.description:
            return "Description"
        case Section.programs:
            return "Programs"
        default:
            fatalError("We don't know this section!")
        }
    }

}

// MARK: - UITableViewDelegate Methods

extension DetailsViewController: UITableViewDelegate {

}

// MARK: - Private Methods

private extension DetailsViewController {

    func setupSubviews() {
        tableView = UITableView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: view.frame.width, height: view.frame.height - 30.0), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: DefaultTableViewCell.reusableIdentifier)
        view.addSubview(tableView)

        favouriteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(favouriteButtonPressed(_:)))
        navigationItem.rightBarButtonItem = favouriteButton
    }

    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor)
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
    }

    func setupDetails() {
        if let scholarship = scholarship {
//            title = scholarship.title
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

    @objc func favouriteButtonPressed(_ sender: Any) {
        guard let scholarship = scholarship else { return }

        scholarship.favourited = !scholarship.favourited
        var array: [Scholarship] = []
        if let favouritesData = defaults.object(forKey: "Favourites") as? Data {
            array = NSKeyedUnarchiver.unarchiveObject(with: favouritesData) as! [Scholarship]
            array.append(scholarship)
        } else {
            array.append(scholarship)
        }
        defaults.set(NSKeyedArchiver.archivedData(withRootObject: array), forKey: "Favourites")
        defaults.synchronize()
        if scholarship.favourited {
            favouriteButton.isEnabled = false
        } else {
            favouriteButton.isEnabled = true
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
