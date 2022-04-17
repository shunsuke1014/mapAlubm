//
//  AppDelegate.swift
//  map2022
//
//  Created by 佐川駿介 on 2022/01/15.
//

import UIKit
import NCMB
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NCMB.setApplicationKey("030621123e4610d4360ad41d5dc5eba5d5dd09c50ef8712334d0d2db638c1f93", clientKey: "fa6b4d28a5766065c78b446fbeffc803e492d10ec6ae69261d22c62c129a544c")
//        データはUserDefaults.standard.object(forKey: "userName")に紐づけて保存
//        匿名会員の利用NCMB側で設定から許可
        
        UserDefaults.standard.removeObject(forKey: "userName")
        let ud = UserDefaults.standard
                if ud.object(forKey: "userName") == nil {
                    NCMBUser.enableAutomaticUser()
                    NCMBUser.automaticCurrentUser { (user, error) in
                        if error != nil {
                            print("error")
                        } else {
                            ud.set(user?.objectId, forKey: "userName")
                            print(ud.object(forKey: "userName"))
                            print("い")
                            let object = NCMBObject(className: "Message")
                            object?.setObject(ud.object(forKey:"userName"), forKey: "userName")
                            object?.setObject([], forKey: "todouhuken")
                            object?.saveInBackground({ (error) in
                                if error != nil{
                                    print("error")
                                }else{
                                    print("success")
                                }
                            })
                        }
                    }
                }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

