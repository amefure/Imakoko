//
//  ImakokoApp.swift
//  Imakoko
//
//  Created by t&a on 2022/09/07.
//

import SwiftUI
import GoogleMobileAds

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                        GADMobileAds.sharedInstance().start(completionHandler: nil)
                        return true
                    }
}

@main
struct ImakokoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
       var body: some Scene {
           WindowGroup {
               ContentView()
           }
       }
   }
