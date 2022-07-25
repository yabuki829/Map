//
//  SubscribeManager.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/07/06.
//

import Foundation
//import Purchases
//
//class SubscribeManager{
//    static var shared = SubscribeManager()
//
//
//    func fetchOfferings(){
//        Purchases.shared.offerings { offertings, error in
//            guard let offertings = offertings, error == nil else {
//                print("エラー1",error)
//                return
//
//            }
//            guard let package = offertings.all.first?.value.package(identifier: "defalut") else { return }
//        }
//
//
//    }
//    func fetchPackage(completion:@escaping(Purchases.Package) -> Void){
//        Purchases.shared.offerings { offertings, error in
//            guard let offertings = offertings, error == nil else {
//                print("エラー2",error)
//                return
//
//            }
//            guard let package = offertings.all.first?.value.availablePackages.first else { return }
//            completion(package)
//        }
//
//    }
//    func setup(completion:@escaping (Bool) -> Void){
//        Purchases.shared.purchaserInfo { info, error in
//            guard let info = info, error == nil else { return }
//            print("---------------------------")
//            if info.entitlements.all["Premium"]?.isActive == true  {
//                //サブスクリプション
//                print("サブスクリプションに登録済み")
//                //userdefaultに保存する
//                DataManager.shere.saveSubScriptionState(isSubscribe: true)
//                completion(true)
//            }
//            else{
//                //no subsc
//                print("サブスクリプションに登録していません")
//                //userdefaultに保存する　isSubsc = true
//                DataManager.shere.saveSubScriptionState(isSubscribe: false)
//                completion(false)
//            }
//            print("---------------------------")
//        }
//
//    }
//    func purchase(package: Purchases.Package){
//
//        Purchases.shared.purchasePackage(package) { transaction, info, error, userCahancelled in
//            guard let transaction = transaction ,let info = info ,error == nil, !userCahancelled else { return }
//            print("transaction",transaction.transactionState)
//            print("info",info.entitlements)
//        }
//
//    }
//    func restorePurchase(){
//        Purchases.shared.restoreTransactions { info, error in
//            guard let info = info, error == nil else { return }
//
//        }
//    }
//}
