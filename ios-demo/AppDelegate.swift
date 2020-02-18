//
//  AppDelegate.swift
//  ios-demo
//
//  Created by romain PETIT on 17/02/2020.
//  Copyright © 2020 romain PETIT. All rights reserved.
//

import UIKit
import sdkApiVideo
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let authClient = Client()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (created, reponse) in
            if(reponse != nil && reponse?.statusCode != "200"){
                print("error authentification => \((reponse?.statusCode)!): \((reponse?.message)!)")
            }else{
                if created{
                    print("authentified")
                }
            }
        }
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setPreferredSampleRate(44_100)
            if #available(iOS 10.0, *) {
                try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            } else {
                session.perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playAndRecord, with: [AVAudioSession.CategoryOptions.allowBluetooth])
                try? session.setMode(.default)
            }
            try session.setActive(true)
        } catch {
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

