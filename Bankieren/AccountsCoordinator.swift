//
//  AccountLsCoordinator.swift
//  Bankieren
//
//  Created by Ian Dundas on 06/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import UIKit
import ReactiveKit

class AccountsCoordinator: NSObject, Coordinator{
    
    // MARK: Coordinator:
    let identifier = "Accounts"
    let presenter: UINavigationController
    var childCoordinators: [String : Coordinator] = [:]
    
    init(presenter: UINavigationController){
        self.presenter = presenter
        super.init()
        
        presenter.setNavigationBarHidden(false, animated: false)
        
    }

    /// Tells the coordinator to create its initial view controller and take over the user flow.
    func start(withCallback completion: CoordinatorCallback?) {
        
        let selectPlayer = SelectPlayerViewController.create { (viewController) -> SelectPlayerViewModel<RealPlayer> in
            viewController.actions.tappedScores.bind(to: self.requestedToViewHighScores)
            
            let viewModel = SelectPlayerViewModel(actions: viewController.actions, players: self.demoPlayers)
            viewModel.didChoosePlayers.bind(to: self.playersWishingToPlayGame)
            return viewModel
        }
        
        presenter.viewControllers = [selectPlayer]
    }
    
    
    /// Tells the coordinator that it is done and that it should rewind the view controller state to where it was before `start` was called.
    func stop(withCallback completion: CoordinatorCallback?) {
        presenter.dismiss(animated: true){
            completion?(self)
        }
    }

}

