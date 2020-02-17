//
//  MainPagePresenter.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation

protocol MainPagePresentationLogic: AnyObject {
    func presentLessons(_ response: MainPageResponse)
    func presentError(message: String)
}

class MainPagePresenter: MainPagePresentationLogic {
    var isPremiumAccount = false
    weak var controller: MainPageControllerLogic?

    func presentLessons(_ response: MainPageResponse) {
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
                    isLocked: false,
                    data: lesson
                )
            )
        }

        guard response.premiumLessons != nil, response.premiumLessons?.isEmpty == false
        else {
            controller?.presenLessons(viewModels)
            return
        }

        if isPremiumAccount == false {
            let buyFullViewModel = MainPageBuyPremiumCellViewModel(
                title: Text.MainPage.tryPremium,
                subtitle: Text.MainPage.pressForInfo
            )
            viewModels.append(
                MainPageCellViewModel(
                    type: .buyFull,
                    isLocked: false,
                    data: buyFullViewModel
                )
            )
        }

        for lesson in response.premiumLessons ?? [] {
            viewModels.append(
                MainPageCellViewModel(
                    type: .lesson,
                    isLocked: isPremiumAccount == false,
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
