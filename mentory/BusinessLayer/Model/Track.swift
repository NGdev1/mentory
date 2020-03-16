//
//  Track.swift
//  mentory
//
//  Created by Михаил Андреичев on 17.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation
import UIKit

public struct Track: Decodable {
    init(
        id: Int,
        title: String,
        subtitle: String,
        url: String,
        isLocked: Bool
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.url = url
        self.isLocked = isLocked
    }

    let id: Int
    let title: String
    let subtitle: String
    let url: String
    let isLocked: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case url
        case isLocked
    }

    public init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try map.decode(Int.self, forKey: .id)
        self.title = try map.decode(String.self, forKey: .title)
        self.subtitle = try map.decode(String.self, forKey: .subtitle)
        let rawUrl = try map.decode(String.self, forKey: .url)
        self.url = rawUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? .empty
        self.isLocked = try map.decode(Bool.self, forKey: .isLocked)
    }
}
