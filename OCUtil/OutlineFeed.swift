//
//  OutlineFeed.swift
//  OCUtil
//
//  Created by M. De Vries on 11/09/2020.
//  Copyright © 2020 M. De Vries. All rights reserved.
//

import Cocoa

class OutlineFeed: NSObject {
    var name: String
    var adress: String
    var id: UUID
    var headline: String
    var body: String
    var fileAdress: String
    var runAdress: String
    
    init(name: String, adress: String, id: UUID, headline: String, body: String, fileAdress: String, runAdress: String) {
        self.name = name
        self.adress = adress
        
        self.id = id
        self.headline = headline
        self.body = body
        self.fileAdress = fileAdress
        self.runAdress = runAdress
    }
}
