//
//  AppCoordinator.swift
//  Bankieren
//
//  Created by Ian Dundas on 06/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import UIKit
import ReactiveKit
import RealmSwift
import Model

class AppCoordinator: NSObject, Coordinator{
    
    // MARK: Coordinator
    var identifier = "Application"
    let presenter = UINavigationController()
    var childCoordinators: [String: Coordinator] = [:]
    
    let window: UIWindow
    init(window: UIWindow){
        self.window = window
    }
    
    /// Tells the coordinator to create its initial view controller and take over the user flow.
    func start(withCallback completion: CoordinatorCallback?) {
        window.rootViewController = presenter
        window.makeKeyAndVisible()
        
        Style.applyGlobal()
        
        preloadData()
        
        DispatchQueue.main.async {
            let mainFlow = AccountsCoordinator(presenter: self.presenter)
            _ = self.startChild(coordinator: mainFlow) { (mainFlow) in
                //
            }
        }
    }
    
    /// Tells the coordinator that it is done and that it should rewind the view controller state to where it was before `start` was called.
    func stop(withCallback completion: CoordinatorCallback?){
        fatalError("This should never happen to App Coordinator")
    }
    
    func preloadData(){
        
        let realm = try! Realm()
        
        if realm.objects(PaymentAccount.self).count == 0 {
        
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
            
            try! realm.write {
                realm.add([accountA, accountB], update: false)
            }
        }
        
        if realm.objects(SavingsAccount.self).count == 0 {
            
            let accountC = SavingsAccount()
            accountC.balanceInCents = 15000;
            accountC.currency = Currency.eur
            accountC.id = "700000027559"
            accountC.name = ","
            accountC.number = "H 177-27066"
            accountC.alias = "SAVINGS"
            accountC.visible = true
            accountC.iban = ""
            
            try! realm.write {
                realm.add([accountC], update: false)
            }
        }
    }
}
