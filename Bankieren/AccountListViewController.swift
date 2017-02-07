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

protocol AccountListViewModelType{
    var accountsUpdated: SafePublishSubject<AccountListSection> {get}
    
    func sectionCount() -> Int
    func itemCount(section index: Int) -> Int
    func title(section index: Int) -> String
}

class AccountListViewController: BaseBoundViewController<AccountListViewModelType>, UITableViewDelegate, UITableViewDataSource  {
    
    // MARK: Outlets:
    @IBOutlet var filterOnlyVisibleAccountsSwitch: UISwitch!
    @IBOutlet var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    // MARK: Configuration points:
    var createCell: ((AccountListViewModelType, IndexPath, UITableView) -> UITableViewCell)?
    
    
    // MARK: View Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    override func bindTo(viewModel: AccountListViewModelType) {
        
        viewModel.accountsUpdated.bind(to: self.tableView) { (tableView: UITableView, section: AccountListSection) in
            // TODO implement a more sophisticated change diff for updating the tableview
            tableView.reloadData()
        }
    }
    
    
    // MARK: UITableViewDelegate: 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let createCell = createCell else { fatalError("Please provide a createCell configuration closure.") }
        let cell = createCell(viewModel, indexPath, tableView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(section: section)
    }
}


extension AccountListViewController{
    
    struct Actions {
        public let filterOnlyVisibleAccounts: SafeSignal<Bool>
    }
    
    var actions: Actions {
        return Actions(
            filterOnlyVisibleAccounts: self.filterOnlyVisibleAccountsSwitch.reactive.isOn.toSignal()
        )
    }
}
