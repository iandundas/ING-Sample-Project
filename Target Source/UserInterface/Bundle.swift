//
//  Bundle.swift
//  Bankieren
//
//  Created by Ian Dundas on 07/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import UIKit

private class PrivateUIClass{}

public extension Bundle {
    public static var ui: Bundle {
        return Bundle(for: PrivateUIClass.self)
    }
}
