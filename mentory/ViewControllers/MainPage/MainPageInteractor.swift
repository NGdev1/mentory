//
//  MainPageInteractor.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

protocol MainPageBusinessLogic: AnyObject {
    func loadData()
}

class MainPageInteractor: MainPageBusinessLogic {
    weak var presenter: MainPagePresentationLogic?
    let service: MainPageServiceProtocol = MentoryServiceFactory.mainPageService

    func loadData() {
        service.get { [weak self] lessons, error in
            guard let self = self else { return }
            if let error = error {
                self.presenter?.presentError(message: error.localizedDescription)
            }
            if let lessons = lessons {
                self.presenter?.presentLessons(lessons)
            } else {
                self.presenter?.presentError(message: Text.Errors.requestError)
            }
        }
    }
}
