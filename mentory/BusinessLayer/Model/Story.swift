//
//  Story.swift
//  mentory
//
//  Created by Михаил Андреичев on 10.05.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

struct Story: Decodable {
    let id: Int
    let imageUrl: String
    let text: String
    let actionUrl: String?
}
