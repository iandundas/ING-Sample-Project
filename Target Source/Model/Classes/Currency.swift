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
    formatter.numberStyle = .decimal // .currency
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.locale = Locale(identifier: "nl")
    return formatter
}()

extension Currency {

    public func formatted(amount: NSDecimalNumber) -> String? {
        switch self {
        case .eur:
            guard let formatted = euroCurrencyFormatter.string(from: amount) else {return nil}
            return "€\(formatted)"
        case .unknown: return nil
        }
    }
}
