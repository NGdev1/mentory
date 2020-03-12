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
        description: String,
        backgroundImageUrl: String,
        tracks: [Track],
        tag: String?,
        isLocked: Bool
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.backgroundImageUrl = backgroundImageUrl
        self.tracks = tracks
        self.tag = tag
        self.isLocked = isLocked
    }

    let id: String
    let title: String
    let subtitle: String
    let description: String
    let backgroundImageUrl: String
    let tracks: [Track]
    let tag: String?
    let isLocked: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case description
        case backgroundImageUrl
        case tracks
        case tag
        case isLocked
    }
}
