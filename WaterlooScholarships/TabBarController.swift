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
        let undergraduateViewController = UINavigationController(rootViewController: UndergraduateViewController())
        let graduateViewController = UINavigationController(rootViewController: GraduateViewController())
        let favouritesViewController = UINavigationController(rootViewController: FavouritesViewController())
        let moreViewController = UINavigationController(rootViewController: MoreViewController())

        undergraduateViewController.tabBarItem = UITabBarItem(title: "Undergrad", image: UIImage(named: "dollar-sign.png"), tag: 0)
        graduateViewController.tabBarItem = UITabBarItem(title: "Graduate", image: UIImage(named: "graduation-cap.png"), tag: 1)
        favouritesViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        moreViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 3)

        viewControllers = [undergraduateViewController, graduateViewController, favouritesViewController, moreViewController]
    }

}
