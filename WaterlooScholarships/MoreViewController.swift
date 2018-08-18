//
//  MoreViewController.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2018-08-06.
//  Copyright © 2018 Aqeel Kamadia. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    // MARK: - Properties

    var label: UILabel!

    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupConstraints()

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.title = "More"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.title = "More"
    }

}

// MARK: - Private Methods

private extension MoreViewController {

    func setupSubviews() {
        view.backgroundColor = .white

        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        label.text = "Tab bar icons supplied\nwww.iconbeast.com"
        label.textColor = .darkText
        label.textAlignment = .center
        label.numberOfLines = 2
//        label.attributedText = NSAttributedString(string: "Tab bar icons supplied\nwww.iconbeast.com")
        view.addSubview(label)
    }

    func setupConstraints() {
        label.center = view.center
    }

}
