//
//  ScholarshipTableViewCell.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2018-03-13.
//  Copyright © 2018 Aqeel Kamadia. All rights reserved.
//

import Foundation
import UIKit

class ScholarshipTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var value: UILabel!

    // MARK: - Initializers

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
