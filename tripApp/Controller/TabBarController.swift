//
//  TabBarController.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//

import Foundation
import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.barTintColor = .systemGray3
        setupTab()
    }

    func setupTab() {
        let firstViewController = UINavigationController(rootViewController: MapViewController())
        firstViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))

        let secondViewController = UINavigationController(rootViewController: ProfileViewController())
        secondViewController.tabBarItem = UITabBarItem(title:"Profile" , image: UIImage(systemName: "person.circle"), selectedImage: UIImage(systemName: "person.circle.fill"))
        
        viewControllers = [firstViewController, secondViewController]
    }

}
