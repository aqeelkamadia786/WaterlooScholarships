//
//  DetailTableViewCell.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2018-03-14.
//  Copyright © 2018 Aqeel Kamadia. All rights reserved.
//

import Foundation
import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }

}
