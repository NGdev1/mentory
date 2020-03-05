//
//  ExtensionFloat.swift
//  mentory
//
//  Created by Михаил Андреичев on 05.03.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import Foundation

extension Float {
    var currencyValue: String {
        return self == floor(self) ? String(format: "%.0f", self) : String(format: "%.2f", self)
    }
}
