//
//  Quote.swift
//  mentory
//
//  Created by Михаил Андреичев on 11.05.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

struct Quote: Decodable {
    let id: Int
    let imageUrl: String
    let text: String
    let authorName: String
}
