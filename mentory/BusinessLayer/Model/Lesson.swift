//
//  Lesson.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation
import UIKit

public struct Lesson: Decodable {
    init(
        id: String,
        title: String,
        subtitle: String,
        duration: Int,
        backgroundImage: UIImage?,
        backgroundImageUrl: String?
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.duration = duration
        self.backgroundImage = backgroundImage
        self.backgroundImageUrl = backgroundImageUrl
    }

    var id: String
    let title: String
    let subtitle: String
    let duration: Int
    var backgroundImage: UIImage?
    var backgroundImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case duration
        case backgroundImageUrl = "image"
    }
}
