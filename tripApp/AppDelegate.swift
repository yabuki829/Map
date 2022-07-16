//
//  AppDelegate.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/08.
//

import UIKit
import FirebaseCore
import Firebase
import FirebaseMessaging

import Purchases

@main
class AppDelegate: UIResponder, UIApplicationDelegate ,MessagingDelegate, UNUserNotificationCenterDelegate{



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //firebse
        var restrictRotation:UIInterfaceOrientationMask = .portrait
        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
//        //通知
//        UNUserNotificationCenter.current().delegate = self
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (success, error) in
//            guard success else{
//                return
//            }
//            print("成功")
//        }
//
//        application.registerForRemoteNotifications()
        
        //navigationbarの設定
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
        
        print("---------------------------------------------")
        Purchases.configure(withAPIKey: "appl_XDqedcWoiVhnjjJhDbVcRJoeVPX")
        SubscribeManager.shared.setup { result in
            DataManager.shere.saveSubScriptionState(isSubscribe: result)
        }
        
        return true
    }
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        messaging.token { (token, _) in
//            guard let token = token else{
//                return
//            }
////            print("トークン:",token)
//        }
//    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
   
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    
    }

}

