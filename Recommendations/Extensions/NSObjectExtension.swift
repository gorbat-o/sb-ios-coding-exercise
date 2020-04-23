//
//  NSObjectExtension.swift
//  Recommendations
//
//  Created by Oleg GORBATCHEV on 4/22/20.
//  Copyright © 2020 Serial Box. All rights reserved.
//

import Foundation

extension NSObject {
    var nameOfClass: String {
        return NSStringFromClass(type(of: self))
    }

    class var className: String {
        return NSStringFromClass(self)
    }

    class var bundle: Bundle {
        return Bundle(for: self)
    }
}
