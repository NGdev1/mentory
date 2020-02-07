//
//  SomethingServiceMock.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation

class SomethingServiceMock: SomethingServiceProtocol {
    func get(completion: @escaping (Something?, Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            var result = Something(id: "0")
            completion(result, nil)
        }
    }
}
