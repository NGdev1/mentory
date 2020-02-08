//
//  MainPageViewModels.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation
import UIKit

struct MainPageTitleCellViewModel {
    let title: String
    let subtitle: String
}

struct MainPageBuyPremiumCellViewModel {
    let title: String
    let subtitle: String
}

struct MainPageCellViewModel {
    init(
        type: MainPageCellViewModel.CellType,
        isLocked: Bool,
        data: Any
    ) {
        self.type = type
        self.isLocked = isLocked
        self.data = data
    }

    enum CellType {
        case lesson
        case title
        case buyFull
    }

    let type: CellType
    let isLocked: Bool
    let data: Any
}

struct NextLessonRetrievingResult {
    let lesson: Lesson?
    let isLocked: Bool?
    let cellView: LessonCell?
}
