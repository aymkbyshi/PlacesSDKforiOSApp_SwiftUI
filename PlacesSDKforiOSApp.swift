//
//  PlacesSDKforiOSApp.swift
//  PlacesSDKforiOS
//
//  Created by Kobayashi, Ayumu on 12/24/23.
//

import SwiftUI
import GooglePlaces

@main
struct PlacesSDKforiOSApp: App {
    // SwiftUIのライフサイクルでAppDelegateを使用する
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Google PlacesのAPIキーを設定
        GMSPlacesClient.provideAPIKey("")
        return true
    }
}
