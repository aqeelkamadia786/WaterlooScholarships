//
//  TabBarController.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2018-07-29.
//  Copyright © 2018 Aqeel Kamadia. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        let undergraduateViewController = UndergraduateViewController()
        let graduateViewController = GraduateTableViewController()

        undergraduateViewController.tabBarItem = UITabBarItem(title: "Undergrad", image: UIImage(named: "dollar-sign.png"), tag: 0)
        graduateViewController.tabBarItem = UITabBarItem(title: "Graduate", image: UIImage(named: "graduation-cap.png"), tag: 1)

        viewControllers = [undergraduateViewController, graduateViewController]
    }

}
