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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .zero
        
        let firstViewController = UINavigationController(rootViewController: MapViewController())
        firstViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))

        
        
        let secondViewController = UINavigationController(rootViewController: profileViewController(collectionViewLayout: layout))
        secondViewController.tabBarItem = UITabBarItem(title:"Profile" , image: UIImage(systemName: "person.circle"), selectedImage: UIImage(systemName: "person.circle.fill"))
        
        
      
        viewControllers = [firstViewController, secondViewController]
    }

}
