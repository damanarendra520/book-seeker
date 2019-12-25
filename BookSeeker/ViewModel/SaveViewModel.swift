//
//  SaveViewModel.swift
//  BookSeeker
//
//  Created by Narendra Dama on 12/24/19.
//  Copyright © 2019 CIT. All rights reserved.
//

import UIKit

class SaveListViewModel: NSObject {
    @objc dynamic var savesViewModels: [SaveViewModel] = [SaveViewModel]()
    private var webservice: WebServices
    private var token: NSKeyValueObservation?
    var bindToSavesViewModels :(() -> Void) = { }
    init(webservice: WebServices) {
        self.webservice = webservice
        super.init()
        token = self.observe(\.savesViewModels) {_, _ in
            self.bindToSavesViewModels()
        }
        // call populate Books
        populateSaves()
    }
    func populateSaves() {
        self.webservice.loadSaves { [unowned self] saves, _ in
            self.savesViewModels = saves.compactMap(SaveViewModel.init)
        }
    }
}
class SaveViewModel: NSObject {
    var name: String
    init(save: Save) {
        self.name   =   save.name
    }
}
