//
//  ItunesModels.swift
//  mentory
//
//  Created by Михаил Андреичев on 08.04.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

struct VerifyReceiptRequest: Encodable {
    var recieptData: String
    var password: String

    enum CodingKeys: String, CodingKey {
        case recieptData = "receipt-data"
        case password
    }
}
