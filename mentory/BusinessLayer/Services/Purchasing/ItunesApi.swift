//
//  ItunesApi.swift
//  mentory
//
//  Created by Михаил Андреичев on 08.04.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Moya
import Storable

enum ItunesApi {
    case verifyReceipt(VerifyReceiptRequest)
}

extension ItunesApi: TargetType {
    var baseURL: URL {
        return AppService.shared.app.itunesURL
    }

    var path: String {
        switch self {
        case .verifyReceipt:
            return "/verifyReceipt"
        }
    }

    var method: Moya.Method {
        switch self {
        case .verifyReceipt:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .verifyReceipt(body):
            return .requestJSONEncodable(body)
        }
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
        ]
    }
}
