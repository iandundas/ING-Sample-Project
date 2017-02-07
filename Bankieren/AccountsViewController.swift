//
//  AccountListViewController.swift
//  Bankieren
//
//  Created by Ian Dundas on 06/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond

protocol AccountsViewModelType{}
class AccountsViewModel: AccountsViewModelType {
    init(actions: AccountsViewController.Actions){
    }
}

class AccountsViewController: BaseBoundViewController<AccountsViewModelType>  {
    
    // MARK: Outlets:
    @IBOutlet var headerContainer: UIView!
    @IBOutlet var filterOnlyVisibleAccountsSwitch: UISwitch!
    
    var listViewController: ListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let listViewController = listViewController{
            addChildViewController(listViewController)
            view.addSubview(listViewController.view)
            listViewController.didMove(toParentViewController: self)
            
            listViewController.view.translatesAutoresizingMaskIntoConstraints = false
            listViewController.view.topAnchor.constraint(equalTo: headerContainer.bottomAnchor).isActive = true
            listViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            listViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            listViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            view.setNeedsLayout()
        }
    }
}


extension AccountsViewController{
    
    struct Actions {
        public let filterOnlyVisibleAccounts: SafeSignal<Bool>
    }
    
    var actions: Actions {
        return Actions(
            filterOnlyVisibleAccounts: self.filterOnlyVisibleAccountsSwitch.reactive.isOn.toSignal()
        )
    }
}
