//
//  ErrorTableViewCell.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2018-03-13.
//  Copyright © 2018 Aqeel Kamadia. All rights reserved.
//

import Foundation
import UIKit

class ErrorTableViewCell: UITableViewCell {

    // MARK: - Public Methods

    func configure(with title: String?) {
        textLabel?.text = title
    }

}
