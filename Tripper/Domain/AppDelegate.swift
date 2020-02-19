//
//  AppDelegate.swift
//  Tripper
//
//  Created by Denis Cherniy on 30.01.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var dataModel = RouteDataModel()
    
    private struct APIKeys {
        static let GMaps = "AIzaSyA53BgLa8gZcYkfXYaZvt4qBPU5wnZPY0Y"
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(APIKeys.GMaps)
        GMSPlacesClient.provideAPIKey(APIKeys.GMaps)
        let navigationController = window!.rootViewController as! UINavigationController
        let controller = navigationController.viewControllers[0] as! GMapViewController
        controller.route = dataModel
        
        return true
    }
    
    // MARK: Application Methods
    
//    func applicationWillTerminate(_ application: UIApplication) {
//        dataModel.save()
//    }
//    
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        dataModel.save()
//    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

