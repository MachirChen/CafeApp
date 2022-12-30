//
//  AppDelegate.swift
//  CafeApp
//
//  Created by Machir on 2022/8/9.
//

import UIKit
import CoreLocation
import FacebookCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var myLocationManager = CLLocationManager()
    var myUserDefaults : UserDefaults!
    let userLocationAuth : String = "locationAuth"
    
    func setupManager() {
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        myLocationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.activityType = .automotiveNavigation
        myLocationManager.startUpdatingHeading()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.myUserDefaults = UserDefaults.standard
        setupManager()
        
        switch myLocationManager.authorizationStatus {
        case .notDetermined:
            myLocationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.myUserDefaults.set(false, forKey: userLocationAuth)
            self.myUserDefaults.synchronize()
        case .denied:
            self.myUserDefaults.set(false, forKey: userLocationAuth)
            self.myUserDefaults.synchronize()
        case .authorizedWhenInUse:
            self.myUserDefaults.set(false, forKey: userLocationAuth)
            self.myUserDefaults.synchronize()
        default:
            break
        }
        
        //FB相關設定
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //myLocationManager.requestWhenInUseAuthorization()
        return true
    }
    
    //切換到FB App後，再從FB App切換回我們的App時呼叫此func
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //ApplicationDelegate.shared.application(app, open: url, options: options)
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: [UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
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

