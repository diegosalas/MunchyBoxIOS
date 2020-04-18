//
//  AppDelegate.swift
//  FirebaseStarterApp
//
//  Created by Florian Marcu on 2/21/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import Firebase
import UIKit
import FacebookCore
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: LeerViewController(nibName: "LeerViewController", bundle: nil))
        self.window?.makeKeyAndVisible()
        
        
        return true
    }
  

    

//     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//         let rootVC = BrowseProductsViewController()
//         let navigationController = UINavigationController(rootViewController: rootVC)
//         let window = UIWindow(frame: UIScreen.main.bounds)
//         window.rootViewController = navigationController;
//         window.makeKeyAndVisible()
//         self.window = window
//         return true
//     }

     // This method is where you handle URL opens if you are using a native scheme URLs (eg "yourexampleapp://")
     func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
         let stripeHandled = Stripe.handleURLCallback(with: url)

         if (stripeHandled) {
             return true
         } else {
             // This was not a stripe url, do whatever url handling your app
             // normally does, if any.
         }

         return false
     }
    
    //  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    //      return ApplicationDelegate.shared.application(app, open: url, options: options)
    //  }

     // This method is where you handle URL opens if you are using univeral link URLs (eg "https://example.com/stripe_ios_callback")
     func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
         if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
             if let url = userActivity.webpageURL {
                 let stripeHandled = Stripe.handleURLCallback(with: url)

                 if (stripeHandled) {
                     return true
                 } else {
                     // This was not a stripe url, do whatever url handling your app
                     // normally does, if any.
                 }
             }
             
         }
         return false
     }
    
    
}

