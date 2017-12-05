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
    @IBOutlet weak var favouriteButton: UIButton!
    var scholarship: Scholarship?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = scholarship?.title
        titleLabel.text = scholarship?.title
        valueLabel.text = scholarship?.value
        descriptionLabel.text = scholarship?.details
        if (scholarship?.favourited)! {
            favouriteButton.isEnabled = false
            favouriteButton.alpha = 0.5
        }
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
                favouriteButton.alpha = 0.5
            }   else {
                favouriteButton.isEnabled = true
                favouriteButton.alpha = 1.0
            }
        }
    }
}
