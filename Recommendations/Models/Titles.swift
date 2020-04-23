//
//  Titles.swift
//  Recommendations
//
//  Created by Oleg GORBATCHEV on 4/22/20.
//  Copyright © 2020 Serial Box. All rights reserved.
//

import Foundation

struct Titles: Codable {
    var titles: [Recommendation]
    var skipped: [String]
    var titles_owned: [String]
}
