//
//  MainPageServiceMock.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation

class MainPageServiceMock: MainPageServiceProtocol {
    func get(completion: @escaping (MainPageResponse?, Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            let lesson1 = Lesson(
                id: "0",
                title: "Знакомство",
                subtitle: "ВВОДНЫЙ УРОК",
                duration: 8,
                backgroundImage: Assets.temp1.image,
                backgroundImageUrl: nil
            )

            let lesson2 = Lesson(
                id: "1",
                title: "Креативность",
                subtitle: "УРОК 1",
                duration: 8,
                backgroundImage: Assets.temp2.image,
                backgroundImageUrl: nil
            )

            let lesson3 = Lesson(
                id: "2",
                title: "Настойчивость",
                subtitle: "УРОК 2",
                duration: 8,
                backgroundImage: Assets.temp1.image,
                backgroundImageUrl: nil
            )

            let lesson4 = Lesson(
                id: "3",
                title: "Премиум урок",
                subtitle: "УРОК 3",
                duration: 10,
                backgroundImage: Assets.temp1.image,
                backgroundImageUrl: nil
            )

            let lesson5 = Lesson(
                id: "4",
                title: "Премиум крутой урок",
                subtitle: "УРОК 4",
                duration: 12,
                backgroundImage: Assets.temp1.image,
                backgroundImageUrl: nil
            )

            let lesson6 = Lesson(
                id: "5",
                title: "Еще уроки",
                subtitle: "УРОК 5",
                duration: 20,
                backgroundImage: Assets.temp1.image,
                backgroundImageUrl: nil
            )

            let response = MainPageResponse(
                introductoryLessons: [lesson1],
                lessons: [lesson2, lesson3],
                premiumLessons: [lesson4, lesson5, lesson6]
            )
            completion(response, nil)
        }
    }
}
