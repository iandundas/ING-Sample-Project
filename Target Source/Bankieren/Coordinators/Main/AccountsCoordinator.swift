//
//  AccountLsCoordinator.swift
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
import ViewModels

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
        
        let accountsScreen = AccountsViewController.create { (accountsViewController) -> AccountsViewModelType in
            
            // Instantiate the ListViewController, passing it's viewmodel the
            // actions (i.e. UI slider events) from the accountsViewController:
            let listViewController = ListViewController.create { (listViewController) -> ListViewModelType in
                return AccountListViewModel(actions: accountsViewController.actions)
            }
            
            listViewController.createCell = { (viewModel, indexPath, tableView) -> UITableViewCell in
                guard let handle = viewModel as? AccountListCoordinatorHandle else {fatalError("ViewModel should implement AccountListCoordinatorHandle")}
    
                let section = handle.section(index: indexPath.section)
                switch section {
                case .paymentAccounts:
                    let cell = tableView.dequeueReusableCell(withIdentifier: PaymentCell.defaultID) as! PaymentCell
                    cell.viewModel = handle.paymentCellData(index: indexPath.row)
                    return cell
                case .savingAccounts:
                    let cell = tableView.dequeueReusableCell(withIdentifier: SavingCell.defaultID) as! SavingCell
                    cell.viewModel = handle.savingCellData(index: indexPath.row)
                    return cell
                }
            }
            
            // We add a ListViewController to accountsScreen as a child view controller:
            accountsViewController.listViewController = listViewController
            
            let accountsViewModel = AccountsViewModel(actions: accountsViewController.actions)
            return accountsViewModel
        }
        
        presenter.viewControllers = [accountsScreen]
    }
    
    
    /// Tells the coordinator that it is done and that it should rewind the view controller state to where it was before `start` was called.
    func stop(withCallback completion: CoordinatorCallback?) {
        presenter.dismiss(animated: true){
            completion?(self)
        }
    }
}

