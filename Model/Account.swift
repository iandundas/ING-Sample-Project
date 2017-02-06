//
//  Account.swift
//  Bankieren
//
//  Created by Ian Dundas on 06/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import Foundation
import RealmSwift

public protocol AccountType{
    var id: String {get}
    var name: String {get}
    var number: String  {get}
    var currency: Currency {get}
    var balanceInCents: Int {get}
    var alias: String  {get}
    var visible: Bool {get}
    var iban: String {get}
}

public class SavingsAccount: Object, AccountType {
    
    public dynamic var id: String = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    public dynamic var currencyRaw: String = Currency.unknown.rawValue
    
    public var currency: Currency {
        get {
            guard let currency = Currency(rawValue: currencyRaw) else {
                return Currency.unknown
            }
            return currency
        }
        set{
            currencyRaw = newValue.rawValue
        }
    }
    
    public dynamic var name: String = ""
    public dynamic var number: String = ""
    public dynamic var balanceInCents: Int = 0
    public dynamic var alias: String = ""
    public dynamic var visible: Bool = false
    public dynamic var iban: String = ""
    
    // Savings specific:
    public dynamic var linkedAccountId: String = ""
    public dynamic var productName: String = ""
    public dynamic var productType: String = ""
    public dynamic var savingsTargetReached: String = ""
    public dynamic var targetAmountInCents: String = ""
}

public class PaymentAccount: Object, AccountType {
    
    public dynamic var id: String = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    public dynamic var currencyRaw: String = Currency.unknown.rawValue
    
    public var currency: Currency {
        get {
            guard let currency = Currency(rawValue: currencyRaw) else {
                return Currency.unknown
            }
            return currency
        }
        set{
            currencyRaw = newValue.rawValue
        }
    }
    
    public dynamic var name: String = ""
    public dynamic var number: String = ""
    public dynamic var balanceInCents: Int = 0
    public dynamic var alias: String = ""
    public dynamic var visible: Bool = false
    public dynamic var iban: String = ""
}
