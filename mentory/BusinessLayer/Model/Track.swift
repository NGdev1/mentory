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
        id: String,
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

    let id: String
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
}
