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
    weak var controller: MainPageControllerLogic?
    let service: MainPageServiceProtocol = MentoryServiceFactory.mainPageService

    func loadData() {
        service.get { [weak self] viewModels, error in
            guard let self = self else { return }
            if let error = error {
                self.controller?.presentError(message: error.localizedDescription)
            }
            if let viewModels = viewModels {
                self.controller?.presentData(viewModels)
            } else {
                self.controller?.presentError(message: Text.Errors.requestError)
            }
        }
    }
}
