//
//  MainPagePresenter.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation
import Storable

protocol MainPagePresentationLogic: AnyObject {
    func presentLessons(_ response: MainPageResponse)
    func presentError(message: String)
}

class MainPagePresenter: MainPagePresentationLogic {
    weak var controller: MainPageControllerLogic?

    func presentLessons(_ response: MainPageResponse) {
        let isPremiumAccount = AppService.shared.app.appState == .premium

        var viewModels: [MainPageCellViewModel] = []
        for lesson in response.introLessons ?? [] {
            viewModels.append(
                MainPageCellViewModel(
                    type: .lesson,
                    isLocked: false,
                    data: lesson
                )
            )
        }

        let titleCell = MainPageTitleCellViewModel(
            title: Text.MainPage.programs,
            subtitle: Text.MainPage.programsDescription
        )
        viewModels.append(
            MainPageCellViewModel(
                type: .title,
                isLocked: false,
                data: titleCell
            )
        )

        for lesson in response.lessons ?? [] {
            viewModels.append(
                MainPageCellViewModel(
                    type: .lesson,
                    isLocked: lesson.isLocked && isPremiumAccount == false,
                    data: lesson
                )
            )
        }

        controller?.presenLessons(viewModels)
    }

    func presentError(message: String) {
        controller?.presentError(message: message)
    }
}
