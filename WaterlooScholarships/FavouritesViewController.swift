//
//  FavouritesViewController.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2018-08-06.
//  Copyright © 2018 Aqeel Kamadia. All rights reserved.
//

import UIKit

class FavouritesViewController: BaseTableViewController {

    // MARK: - Properties

    var scholarships: [Scholarship]

    var filteredScholarships: [Scholarship]

    var cellType: CellType

    let defaults = UserDefaults.standard

    var searchController = UISearchController(searchResultsController: nil)

    // MARK: - Initializers

    init() {
        self.scholarships = []
        self.filteredScholarships = []
        self.cellType = .scholarshipCell
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.title = "Favourites"

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Favourites"
        searchController.searchBar.searchBarStyle = .prominent
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController.searchBar
        }
        definesPresentationContext = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Get scholarships from UserDefaults
        if let favouritesData = defaults.object(forKey: "Favourites") as? Data {
            scholarships = NSKeyedUnarchiver.unarchiveObject(with: favouritesData) as! [Scholarship]
            tableView.reloadData()
        }

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    // MARK: - Overridden Methods

    override func configureTableView() {
        tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: DefaultTableViewCell.reusableIdentifier)
        tableView.register(ErrorTableViewCell.self, forCellReuseIdentifier: "ErrorTableViewCell")
        tableView.estimatedRowHeight = 75.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

}

// MARK: - UITableViewDataSource Conformance

extension FavouritesViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            if filteredScholarships.count == 0 {
                cellType = .errorCell
                return 1
            } else {
                cellType = .scholarshipCell
                return filteredScholarships.count
            }
        }
        cellType = .scholarshipCell
        return scholarships.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellType {
        case .errorCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ErrorTableViewCell", for: indexPath) as? ErrorTableViewCell else { return UITableViewCell() }

            cell.configure(with: "No scholarships available")
            return cell
        case .scholarshipCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCell.reusableIdentifier, for: indexPath) as? DefaultTableViewCell else { return UITableViewCell() }

            let scholarship: Scholarship
            if isFiltering() {
                scholarship = filteredScholarships[indexPath.row]
            } else {
                scholarship = scholarships[indexPath.row]
            }
            cell.configure(with: scholarship.title, subtitle: scholarship.value)

            return cell
        }
    }

}

// MARK: - UITableViewDelegate Conformance

extension FavouritesViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        var scholarship: Scholarship
        if isFiltering() {
            scholarship = filteredScholarships[indexPath.row]
        } else {
            scholarship = scholarships[indexPath.row]
        }

        let viewController = DetailsViewController(with: scholarship)
        navigationController?.pushViewController(viewController, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            scholarships.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: scholarships), forKey: "Favourites")
            defaults.synchronize()
        }
    }

}

// MARK: - UISearchResultsUpdating Conformance

extension FavouritesViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }

        filterContentForSearchText(searchText: text)
    }

}

// MARK: - UISearchBarDelegate Conformance

extension FavouritesViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        tableView.reloadData()
    }

}

// MARK: - Private Methods

private extension FavouritesViewController {

    func filterContentForSearchText(searchText: String) {
        guard scholarships.count != 0 else { return }

        filteredScholarships = scholarships.filter({(scholarship: Scholarship) -> Bool in
            let programs = scholarship.programs.filter({(program: String) -> Bool in
                return program.lowercased().contains(searchText.lowercased())
            })
            return scholarship.title.lowercased().contains(searchText.lowercased()) || programs.count > 0
        })
        tableView.reloadData()
    }

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func isFiltering() -> Bool {
        return !searchBarIsEmpty()
    }

}
