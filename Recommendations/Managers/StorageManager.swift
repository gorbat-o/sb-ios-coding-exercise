//
//  StorageManager.swift
//  Recommendations
//
//  Created by Oleg GORBATCHEV on 4/22/20.
//  Copyright © 2020 Serial Box. All rights reserved.
//

import Foundation

final class StorageManager {
    private let fileName: String = "titles"

    func store(titles: Titles) {
        guard let path = getDirectoryPath() else {
            return
        }
        let filePath = path.appendingPathComponent(fileName)
        do {
            let dataEncoded = try PropertyListEncoder().encode(titles)
            try dataEncoded.write(to: filePath)
        } catch {
            print("error is: \(error.localizedDescription)")
        }
    }

    func retrieveTitles() -> Titles? {
        guard let path = getDirectoryPath() else {
            return nil
        }
        let filePath = path.appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: filePath)
            let titles = try PropertyListDecoder().decode(Titles.self, from: data)
            return titles
        } catch {
            print("error is: \(error.localizedDescription)")//9
        }
        return nil
    }

    func getDirectoryPath() -> URL? {
        let arrayPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return arrayPaths.first
    }
}
