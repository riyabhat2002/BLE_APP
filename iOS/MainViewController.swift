//
//  MainViewController.swift
//  BLEAPP
//
//  Created by Patron on 4/24/24.
//

//import UIKit
//
//class MainViewController: UITabBarController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let dashboardVC = DashboardViewController()
//        dashboardVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
//
//        let controlVC = ControlViewController()
//        controlVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)
//
//        viewControllers = [UINavigationController(rootViewController: dashboardVC),
//                           UINavigationController(rootViewController: controlVC)]
//    }
//}

// MainViewController.swift

//import UIKit
//
//class MainViewController: UITabBarController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let dashboardVC = DashboardViewController()
//        dashboardVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
//
//        let controlVC = ControlViewController()
//        controlVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)
//
//        viewControllers = [dashboardVC, controlVC]
//    }
//}
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let dashboardVC = DashboardViewController()
        dashboardVC.tabBarItem = UITabBarItem(title: "Display Values", image: UIImage(systemName: "thermometer"), tag: 0)

        let controlVC = ControlViewController()
        controlVC.tabBarItem = UITabBarItem(title: "Change Values", image: UIImage(systemName: "slider.horizontal.3"), tag: 1)

        viewControllers = [UINavigationController(rootViewController: dashboardVC),
                           UINavigationController(rootViewController: controlVC)]
    }
}
