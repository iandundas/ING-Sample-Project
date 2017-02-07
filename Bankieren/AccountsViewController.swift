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

public protocol AccountsViewModelType{
    var title: String {get}
}

public class AccountsViewModel: AccountsViewModelType {
    public let title = "Accounts"
    
    public init(actions: AccountsViewController.Actions){}
}

public class AccountsViewController: BaseBoundViewController<AccountsViewModelType>  {
    
    // MARK: Outlets:
    @IBOutlet var headerContainer: UIView!
    @IBOutlet var filterOnlyVisibleAccountsSwitch: UISwitch!
    
    public var listViewController: ListViewController?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        
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


// Default usage of AccountList VC:
public extension AccountsViewController {
    public static func create(viewModelFactory: @escaping (AccountsViewController) -> AccountsViewModelType) -> AccountsViewController{
        return create(storyboard: UIStoryboard(name: "Accounts", bundle: Bundle.ui), viewModelFactory: downcast(closure: viewModelFactory)) as! AccountsViewController
    }
}


public extension AccountsViewController{
    
    public struct Actions {
        public let filterOnlyVisibleAccounts: SafeSignal<Bool>
    }
    
    public var actions: Actions {
        return Actions(
            filterOnlyVisibleAccounts: self.filterOnlyVisibleAccountsSwitch.reactive.isOn.toSignal()
        )
    }
}
