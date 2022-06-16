import Foundation
import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.barTintColor = .white
        setupTab()
    }

    func setupTab() {
 
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
        
        let firstViewController = UINavigationController(rootViewController: MapViewController())
        firstViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))

        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .zero
        let secondViewController = UINavigationController(rootViewController: profileViewController(collectionViewLayout: layout))
        secondViewController.tabBarItem = UITabBarItem(title:"Profile" , image: UIImage(systemName: "person.circle"), selectedImage: UIImage(systemName: "person.circle.fill"))
        
        
        let thirdViewController = UINavigationController(rootViewController: ChatListViewController())
        thirdViewController.tabBarItem = UITabBarItem(title:"Chat" , image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
        viewControllers = [firstViewController, secondViewController]
    }

}
