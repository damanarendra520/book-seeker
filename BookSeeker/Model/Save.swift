//
//  Save.swift
//  BookSeeker
//
//  Created by Narendra Dama on 12/24/19.
//  Copyright © 2019 CIT. All rights reserved.
//

import Foundation

struct Save: Codable {
    var name: String
    init?(name: String) {
        self.name = name
    }
    init(save: SaveViewModel) {
        self.name = save.name
    }
}
