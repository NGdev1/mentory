//
//  SomethingServiceProtocol.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

protocol SomethingServiceProtocol {
    func get(completion: @escaping (Something?, Error?) -> Void)
}
