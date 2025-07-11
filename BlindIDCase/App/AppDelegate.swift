//
//  AppDelegate.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast

@main
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    var eczaneWindow: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // MARK: Setup UIWindow

        setupWindow()
        return true
    }

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RouterManager.shared.navigationController
        window?.makeKeyAndVisible()
        RouterManager.shared.start()
    }
}
