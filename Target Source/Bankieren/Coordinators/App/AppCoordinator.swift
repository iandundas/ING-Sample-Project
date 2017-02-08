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
import UserInterface

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
        
        // For the time being we're using Sample data:
        let realm = try! Realm()
        if realm.isEmpty{
            realm.loadSampleData()
        }
        
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

}
