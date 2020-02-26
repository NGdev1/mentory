//
//  BuyInteractor.swift
//  mentory
//
//  Created by Михаил Андреичев on 26.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

protocol BuyBusinessLogic: AnyObject {}

class BuyInteractor: BuyBusinessLogic {
    weak var controller: BuyControllerLogic?
}
