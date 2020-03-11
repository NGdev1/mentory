//
//  NotificationNames.swift
//  mentory
//
//  Created by Михаил Андреичев on 02.03.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let appStateChanged
        = NSNotification.Name("AppStateChanged")
    static let onboardingFinished = NSNotification.Name("OnboardingFinished")
}
