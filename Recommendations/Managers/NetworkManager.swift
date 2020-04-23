//
//  NetworkManager.swift
//  Recommendations
//
//  Created by Oleg GORBATCHEV on 4/22/20.
//  Copyright © 2020 Serial Box. All rights reserved.
//

import Foundation

final class NetworkManager {
    func getTitles(with stub: Stub, callback: @escaping (Titles?, String?) -> Void) {
        guard let url = URL(string: Stub.stubbedURL_doNotChange) else {
            callback(nil, "An error happened while trying to access to the URL?")
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let receivedData = data else {
                callback(nil, "An error happened while trying to load the data.")
                return
            }
            let decoder = JSONDecoder()
            if let titles = try? decoder.decode(Titles.self, from: receivedData) {
                callback(titles, nil)
            } else {
                callback(nil, error?.localizedDescription)
            }
        })
        task.resume()
    }
}
