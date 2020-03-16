//
//  MainPageServiceMock.swift
//  mentory
//
//  Created by Михаил Андреичев on 07.02.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation

class MainPageServiceMock: MainPageServiceProtocol {
    func get(completion: @escaping ([MainPageCellViewModel]?, Error?) -> Void) {
        // let fileName = Locale.current.identifier.contains("ru") ? "mentory_ru.json" : "mentory_en.json"
        let fileName = "mentory_ru.json"
        guard let data = DataManager.getDataFromResource(fileName: fileName) else {
            completion(nil, nil)
            return
        }

        do {
            let response = try JSONDecoder().decode([MainPageCellViewModel].self, from: data)
            completion(response, nil)
        } catch {
            completion(nil, error)
            print(error.localizedDescription)
        }
    }
}
