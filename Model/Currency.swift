//
//  Currency.swift
//  Bankieren
//
//  Created by Ian Dundas on 06/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import Foundation


public enum Currency: String {
    case eur = "EUR"
    case unknown = ""
}

fileprivate let euroCurrencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: "nl")
    return formatter
}()

extension Currency {

    public func formatted(amount: NSDecimalNumber) -> String? {
        switch self {
        case .eur: return euroCurrencyFormatter.string(from: amount)
        case .unknown: return nil
        }
    }
}
