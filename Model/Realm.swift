//
//  Realm.swift
//  Bankieren
//
//  Created by Ian Dundas on 07/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import Foundation
import RealmSwift

public extension Realm{
    
    public static func configureING(){
    
        let sharedGroupID = "group.iandundas.ingsample"
        
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: sharedGroupID)
        let realmURL = container!.appendingPathComponent("default.realm")
        
        var config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        config.fileURL = realmURL
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        print("Realm initialised: \(realmURL)")
    }
    
    public func loadSampleData(){
        
        if objects(PaymentAccount.self).count == 0 {
            
            let accountA = PaymentAccount()
            accountA.balanceInCents = 985000;
            accountA.currency = Currency.eur
            accountA.id = "748757694"
            accountA.name = "Hr P L G N StellingTD"
            accountA.number = "748757694"
            accountA.alias = ""
            accountA.visible = true
            accountA.iban = "NL23INGB0748757694"
            
            let accountB = PaymentAccount()
            accountB.balanceInCents = 1000000;
            accountB.currency = Currency.eur
            accountB.id = "700000027559"
            accountB.name = ","
            accountB.number = "748757732"
            accountB.alias = ""
            accountB.visible = false
            accountB.iban = "NL88INGB0748757732"
            
            try! write {
                add([accountA, accountB], update: false)
            }
        }
        
        if objects(SavingAccount.self).count == 0 {
            
            let accountC = SavingAccount()
            accountC.balanceInCents = 15000;
            accountC.currency = Currency.eur
            accountC.id = "700000027559"
            accountC.name = ","
            accountC.number = "H 177-27066"
            accountC.alias = "SAVINGS"
            accountC.visible = true
            accountC.iban = ""
            accountC.linkedAccountId = "748757694"
            accountC.productName = "Oranje Spaarrekening"
            accountC.productType = "1000"
            accountC.savingsTargetReached = true
            accountC.targetAmountInCents = 2000
            
            try! write {
                add([accountC], update: false)
            }
        }
    }
}
