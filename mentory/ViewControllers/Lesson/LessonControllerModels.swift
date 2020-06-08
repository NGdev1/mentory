//
//  LessonControllerModels.swift
//  mentory
//
//  Created by Михаил Андреичев on 08.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation

struct LessonViewModel {
    init(
        lesson: Lesson,
        nextLesson: Lesson?,
        nextLessonLocked: Bool?
    ) {
        self.lesson = lesson
        self.nextLesson = nextLesson
        self.nextLessonLocked = nextLessonLocked
    }

    var lesson: Lesson
    var nextLesson: Lesson?
    var nextLessonLocked: Bool?
}
