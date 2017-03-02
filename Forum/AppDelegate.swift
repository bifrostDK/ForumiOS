//
//  AppDelegate.swift
//  Forum
//
//  Created by Joachim Dittman on 03/08/2016.
//  Copyright © 2016 Joachim Dittman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = MainView()
        window!.makeKeyAndVisible()
        preferredStatusBarStyle()
 

        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        return true
    }
  
    func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func registerForPushNotifications(_ application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
        let json  = JSON(userInfo)
        
        SweetAlert().showAlert("Besked", subTitle: "\(json["aps"]["alert"].stringValue)", style: AlertStyle.success)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        //Tricky line
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.unknown)
        print("Device Token:", tokenString)
    }


}

