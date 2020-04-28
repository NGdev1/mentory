//
//  PersonalCategoriesInteractor.swift
//  mentory
//
//  Created by Михаил Андреичев on 28.04.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation

protocol PersonalCategoriesBusinessLogic: AnyObject {
    func loadCategories()
}

class PersonalCategoriesInteractor: PersonalCategoriesBusinessLogic {
    weak var controller: PersonalCategoriesControllerLogic?
    func loadCategories() {
        var categories: [PersonalCategory] = []
        categories.append(PersonalCategory(id: "1", name: "Достижение\nцелей"))
        categories.append(PersonalCategory(id: "2", name: "Мотивация\nи энергия"))
        categories.append(PersonalCategory(id: "3", name: "Управление\nвременем"))
        categories.append(PersonalCategory(id: "3", name: "Ментальные\nустановки"))
        categories.append(PersonalCategory(id: "3", name: "Самоанализ\nи самопознание"))
        categories.append(PersonalCategory(id: "3", name: "Эффективность\nдействий"))
        categories.append(PersonalCategory(id: "3", name: "Прокачка\nмышления"))
        categories.append(PersonalCategory(id: "3", name: "Отношения\nс людьми"))
        controller?.didFinishRequest(categories)
    }
}
