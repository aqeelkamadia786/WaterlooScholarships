//
//  BaseTableViewController.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2018-07-28.
//  Copyright © 2018 Aqeel Kamadia. All rights reserved.
//

import UIKit

class BaseTableViewController: UIViewController {

    // MARK: - Properties

    var tableView: UITableView!

    var activityIndicatory: UIActivityIndicatorView!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupConstraints()
    }

    // MARK: - Public Methods

    func configureTableView() {
        assertionFailure("This must be overridden by a subclass.")
    }

}

// MARK: - UITableViewDataSource Conformance

extension BaseTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assertionFailure("This must be overridden by a subclass")
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assertionFailure("This must be overridden by a subclass")
        return UITableViewCell()
    }

}

// MARK: - UITableViewDelegate Conformance

extension BaseTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// Does nothing here. Must be overridden if needed.
    }

}

// MARK: - Private Methods

private extension BaseTableViewController {

    /// Sets up the subviews for this view controller.
    func setupSubviews() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        configureTableView()
        view.addSubview(tableView)

        activityIndicatory = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatory.hidesWhenStopped = true
        tableView.addSubview(activityIndicatory)
    }

    /// Sets up the constraints for the views in this view controller.
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}
