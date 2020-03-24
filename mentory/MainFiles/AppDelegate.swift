//
//  AppDelegate.swift
//  mentory
//
//  Created by Михаил Андреичев on 05.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Storable
import UIKit
import YandexMobileMetrica

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if let configuration = YMMYandexMetricaConfiguration(
            apiKey: "cae75d90-5010-4d97-aa07-58cdfac34708"
        ) { YMMYandexMetrica.activate(with: configuration) }

        if AppService.shared.app.appState == .free {
            IAPService.shared.loadProducts()
        }

        AppService.shared.app.appOpenedCount += 1
        print("App opened count: \(AppService.shared.app.appOpenedCount)")

        if AppService.shared.app.appOpenedCount == 1 {
            let nextController = OnboardingController()
            window?.rootViewController = nextController

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(onboardingFinished),
                name: .onboardingFinished,
                object: nil
            )
        } else {
            let nextController = MainPageController()
            window?.rootViewController = nextController
        }
        window?.makeKeyAndVisible()

        return true
    }

    @objc func onboardingFinished() {
        let nextController = MainPageController()
        window?.rootViewController = nextController
    }
}
