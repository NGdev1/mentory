//
//  MainPageViewModels.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation
import UIKit

struct NextLessonRetrievingResult {
    let lesson: Lesson?
    let isLocked: Bool?
    let cellView: LessonCell?
}

struct StoryRetrievingResult {
    let story: Story?
    let cellView: StoryCell?
}
