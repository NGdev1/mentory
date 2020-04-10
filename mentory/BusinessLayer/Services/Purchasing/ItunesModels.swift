//
//  ItunesModels.swift
//  mentory
//
//  Created by Михаил Андреичев on 08.04.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation

struct VerifyReceiptRequest: Encodable {
    var recieptData: String
    var password: String

    enum CodingKeys: String, CodingKey {
        case recieptData = "receipt-data"
        case password
    }
}

struct VerifyReceiptResponse: Decodable {
    let lastReciepts: [ReceiptInfo]

    enum CodingKeys: String, CodingKey {
        case lastReciepts = "latest_receipt_info"
    }
}

struct ReceiptInfo: Decodable {
    let expiresDate: Date?

    enum CodingKeys: String, CodingKey {
        case expiresDate = "expires_date"
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        let expiresDateString = try map.decode(String.self, forKey: .expiresDate)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        self.expiresDate = formatter.date(from: expiresDateString)
    }
}
