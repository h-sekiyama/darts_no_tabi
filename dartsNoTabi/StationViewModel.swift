//
//  StationViewModel.swift
//  dartsNoTabi
//
//  Created by 関山　秀光 on 2020/02/27.
//  Copyright © 2020 関山　秀光. All rights reserved.
//

import Foundation

struct Station: Codable {
    var response: Response
    struct Response: Codable {
        var name: String
        var prefecture: String
        var line: String
        var x: Double
        var y: Double
        var postal: String
        var prev: String?
        var next: String?
    }
}

class StationViewModel {
    static func fetchArticle(completion: @escaping ([Station]) -> Swift.Void) {

        let url = "http://express.heartrails.com/api/json?method=getStations"

        guard var urlComponents = URLComponents(string: url) else {
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "line", value: "JR山手線"),
        ]

        let task = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in

            guard let jsonData = data else {
                return
            }

            do {
                let articles = try JSONDecoder().decode([Station].self, from: jsonData)
                completion(articles)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
