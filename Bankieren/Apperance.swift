//
//  Style.swift
//  Bankieren
//
//  Created by Ian Dundas on 06/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import UIKit

enum Style {} // used for namespacing http://khanlou.com/2016/06/easy-namespacing-in-swift/

extension Style{
    static func applyGlobal(){
        
        let navbarFont = UIFont(name: "AvenirNextCondensed-Medium", size: 26.0)!
        let navbuttonFont = UIFont(name: "Avenir-Roman", size: 17.0)!
        
        let blue = UIColor(red: 21.0 / 255.0, green: 126.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0)
        
        // MARK: NavigationBar:
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = UIColor(red: 21.0 / 255.0, green: 126.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0)
        
        let attrs: [String:AnyObject] = [
            NSForegroundColorAttributeName : blue,
            NSFontAttributeName : navbarFont
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([
            NSFontAttributeName: navbuttonFont,
            NSForegroundColorAttributeName: blue
            ], for: .normal)
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([
            NSFontAttributeName: navbuttonFont,
            NSForegroundColorAttributeName: UIColor(white: 215.0 / 255.0, alpha: 1.0)
            ], for: .disabled)
    }
}