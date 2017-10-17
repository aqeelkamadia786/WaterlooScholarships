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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    var scholarship: Scholarship?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = scholarship?.title
        titleLabel.text = scholarship?.title
        valueLabel.text = scholarship?.value
        descriptionLabel.text = scholarship?.details
    }
}
