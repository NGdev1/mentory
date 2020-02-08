//
//  AppDelegate.swift
//  mentory
//
//  Created by Михаил Андреичев on 05.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let nextController = MainPageController()
        let navigationController = UINavigationController(rootViewController: nextController)
        navigationController.view.backgroundColor = Assets.black.color
        navigationController.navigationBar.setBaseAppearance()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}
