//
//  Title.swift
//  Recommendations
//
//  Created by Oleg GORBATCHEV on 4/22/20.
//  Copyright © 2020 Serial Box. All rights reserved.
//

import Foundation

struct Recommendation: Codable {
    var imageURL: String
    var title: String
    var tagline: String
    var rating: Float?
    var isReleased: Bool

    private enum CodingKeys : String, CodingKey {
        case title
        case rating
        case tagline
        case isReleased = "is_released"
        case imageURL = "image"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let decodedTitle = try container.decode(String.self, forKey: .title)
        self.title = decodedTitle

        let decodedTagline = try container.decode(String.self, forKey: .tagline)
        self.tagline = decodedTagline

        let decodedIsReleased = try container.decode(Bool.self, forKey: .isReleased)
        self.isReleased = decodedIsReleased

        let decodedImageURL = try container.decode(String.self, forKey: .imageURL)
        self.imageURL = decodedImageURL

        self.rating = try? container.decode(Float.self, forKey: .rating)
    }
}
