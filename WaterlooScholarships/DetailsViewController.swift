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
    @IBOutlet weak var programLabel: UILabel!
    var scholarship: Scholarship?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetails()
    }
    
    func setupDetails() {
        if let scholarship = scholarship {
            title = scholarship.title
            titleLabel.text = scholarship.title
            valueLabel.text = scholarship.value
            descriptionLabel.text = scholarship.details
            programLabel.text = "Program(s):"
            for program in scholarship.programs {
                programLabel.text?.append("\n" + program)
            }
            if scholarship.favourited {
                favouriteButton.isEnabled = false
                favouriteButton.alpha = 0.3
            }
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
                favouriteButton.alpha = 0.3
            }   else {
                favouriteButton.isEnabled = true
                favouriteButton.alpha = 1.0
            }
        }
    }
}
