//
//  DefaultTableViewCell.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2018-07-28.
//  Copyright © 2018 Aqeel Kamadia. All rights reserved.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {

    // MARK: - Constants

    static let reusableIdentifier = "DefaultTableViewCell"

    // MARK: - Properties

    var titleLabel: UILabel!

    var subtitleLabel: UILabel!

    var stackView: UIStackView!

    // MARK: - Initializers

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Public Methods

    func configure(with title: String?, subtitle: String?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

}

// MARK: - Private Methods

private extension DefaultTableViewCell {

    /// Sets up the subviews for cell.
    func setupSubviews() {
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17.0)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 15.0)
        subtitleLabel.textColor = .darkGray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
    }

    /// Sets up the constraints for the views in this cell.
    func setupConstraints() {
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0).isActive = true
    }

}
