//
//  Station.swift
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
