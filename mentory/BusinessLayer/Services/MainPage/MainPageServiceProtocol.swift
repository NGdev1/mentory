//
//  MainPageServiceProtocol.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

protocol MainPageServiceProtocol {
    func get(completion: @escaping (MainPageResponse?, Error?) -> Void)
}
