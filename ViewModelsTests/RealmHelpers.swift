//
//  RealmHelpers.swift
//  Tacks
//
//  Created by Ian Dundas on 28/01/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import Foundation
import XCTest
import RealmSwift

class RealmTestCase: XCTestCase{

    var realm: Realm!
    
    override func setUp() {
        super.setUp()
        
        let config = Realm.Configuration (inMemoryIdentifier: UUID().uuidString)
        Realm.Configuration.defaultConfiguration = config
        
        realm = try! Realm()
    }
    
    override func tearDown() {
        realm = nil
        super.tearDown()
    }
}
