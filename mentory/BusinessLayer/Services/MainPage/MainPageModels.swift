//
//  MainPageModels.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation

struct MainPageResponse: Decodable {
    var introLessons: [Lesson]?
    var lessons: [Lesson]?
    var premiumLessons: [Lesson]?

    enum CodingKeys: String, CodingKey {
        case introLessons
        case lessons
        case premiumLessons
    }
}
