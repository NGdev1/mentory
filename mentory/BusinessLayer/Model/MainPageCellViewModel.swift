//
//  MainPageCellViewModel.swift
//  mentory
//
//  Created by Михаил Андреичев on 16.03.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation
import Storable

struct MainPageCellViewModel: Decodable {
    init(
        type: MainPageCellViewModel.CellType,
        isLocked: Bool = false,
        data: Any
    ) {
        self.type = type
        self.isLocked = isLocked
        self.data = data
    }

    enum CellType: String, Decodable {
        case personalized
        case stories
        case today
        case lesson
        case quotes
        case sectionHeader
    }

    let type: CellType
    let isLocked: Bool
    let data: Any

    enum CodingKeys: String, CodingKey {
        case type
        case data
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try map.decode(CellType.self, forKey: .type)
        switch type {
        case .sectionHeader:
            self.isLocked = false
            self.data = try MainPageSectionHeader(from: decoder)
        case .lesson:
            let lesson = try Lesson(from: decoder)
            let isPremiumAccount = AppService.shared.app.appState == .premium
            self.isLocked = lesson.isLocked && isPremiumAccount == false
            self.data = lesson
        case .stories:
            self.isLocked = false
            self.data = try map.decode([Story].self, forKey: .data)
        case .quotes:
            self.isLocked = false
            self.data = try map.decode([Quote].self, forKey: .data)
        case .personalized, .today:
            self.isLocked = false
            self.data = Data()
        }
    }
}
