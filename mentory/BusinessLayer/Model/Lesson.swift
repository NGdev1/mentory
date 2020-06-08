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
        id: Int,
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
        self.backgroundImageUrl = backgroundImageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? .empty
        self.tracks = tracks
        self.tag = tag
        self.isLocked = isLocked
    }

    let id: Int
    let title: String
    let subtitle: String
    let description: String
    let backgroundImageUrl: String
    let tracks: [Track]
    var tag: String?
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

    public init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try map.decode(Int.self, forKey: .id)
        self.title = try map.decode(String.self, forKey: .title)
        self.subtitle = try map.decode(String.self, forKey: .subtitle)
        self.description = try map.decode(String.self, forKey: .description)
        let backgroundImageRawUrl = try map.decode(String.self, forKey: .backgroundImageUrl)
        self.backgroundImageUrl = backgroundImageRawUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? .empty
        self.tracks = try map.decode([Track].self, forKey: .tracks)
        self.tag = try? map.decode(String.self, forKey: .tag)
        if tag == .empty { self.tag = nil }
        self.isLocked = try map.decode(Bool.self, forKey: .isLocked)
    }
}
