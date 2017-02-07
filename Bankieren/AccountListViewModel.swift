//
//  AccountListViewModel.swift
//  Bankieren
//
//  Created by Ian Dundas on 06/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond
import RealmSwift
import Model

enum AccountListSection{
    case paymentAccounts
    case savingAccounts
    
    var title: String {
        switch self {
        case .paymentAccounts: return "Payments"
        case .savingAccounts: return "Savings"
        }
    }
}

protocol AccountListCoordinatorHandle{
    func section(index:Int) -> AccountListSection
    
    func paymentCellData(index: Int) -> PaymentCellViewModel
    func savingCellData(index: Int) -> SavingCellViewModel
}

class AccountListViewModel: ListViewModelType, AccountListCoordinatorHandle{
    
    var listDidUpdate: Signal<Void, NoError>{
        return accountsUpdated.map {_ in }
    }
    
    let accountsUpdated = SafePublishSubject<AccountListSection>()
    
    var paymentAccounts: Results<PaymentAccount> {
        didSet{
            // TODO with more time it would be good to use the diff available in RealmCollectionChange<Results<PaymentAccount>>
            // in order to provide CRUD notifications to the TableView:
            paymentUpdatesToken = paymentAccounts.addNotificationBlock { [weak self] (_) in
                self?.accountsUpdated.next(.paymentAccounts)
            }
        }
    }
    private var paymentUpdatesToken: NotificationToken? = nil
    
    
    
    var savingAccounts: Results<SavingAccount> {
        didSet{
            // TODO with more time it would be good to use the diff available in RealmCollectionChange<Results<PaymentAccount>>
            // in order to provide CRUD notifications to the TableView:
            savingUpdatesToken = savingAccounts.addNotificationBlock { [weak self] (_) in
                self?.accountsUpdated.next(.savingAccounts)
            }
        }
    }
    private var savingUpdatesToken: NotificationToken? = nil
    
    private let bag = DisposeBag()
    init(actions: AccountsViewController.Actions){
        
        let realm = try! Realm()
        
        // default values:
        paymentAccounts = realm.objects(PaymentAccount.self)
        savingAccounts = realm.objects(SavingAccount.self)
        
        // When actions.filterOnlyVisibleAccounts changes, update the Realm Result query for payment and savings:
        actions.filterOnlyVisibleAccounts
            .map { filterOnlyVisibleAccounts -> Results<PaymentAccount> in
                let objects = realm.objects(PaymentAccount.self)
                if filterOnlyVisibleAccounts {
                    return objects.filter("visible == %@", filterOnlyVisibleAccounts)
                }
                return objects
            }.observeNext { [weak self] (results: Results<PaymentAccount>) in
                self?.paymentAccounts = results
            }.dispose(in: bag)
        
        actions.filterOnlyVisibleAccounts
            .map { filterOnlyVisibleAccounts -> Results<SavingAccount> in
                let objects = realm.objects(SavingAccount.self)
                if filterOnlyVisibleAccounts {
                    return objects.filter("visible == %@", filterOnlyVisibleAccounts)
                }
                return objects
            }.observeNext { [weak self] (results: Results<SavingAccount>) in
                self?.savingAccounts = results
            }.dispose(in: bag)
    }
    
    func sectionCount() -> Int {
        return 2
    }
    
    func itemCount(section index: Int) -> Int {
        switch section(index: index){
        case .paymentAccounts: return paymentAccounts.count
        case .savingAccounts: return savingAccounts.count
        }
    }
    
    func title(section index: Int) -> String?{
        return section(index: index).title
    }
    
    
    // MARK: AccountListCoordinatorHandle
    
    func section(index:Int) -> AccountListSection{
        switch index{
        case 0: return .paymentAccounts
        case 1: return .savingAccounts
        default: fatalError("Section not found for index: \(index)")
        }
    }
    
    func paymentCellData(index: Int) -> PaymentCellViewModel{
        return paymentAccounts[index].cellViewModel()
    }
    
    func savingCellData(index: Int) -> SavingCellViewModel{
        return savingAccounts[index].cellViewModel()
    }
}


extension PaymentAccount{
    func cellViewModel() -> PaymentCellViewModel{
        
        let formattedBalance = currency.formatted(amount: balance) ?? ""
        let viewModel = PaymentCellViewModel(name: name, accountNumber: preferredAccountNumber, amount: formattedBalance)
        return viewModel
    }
}

extension SavingAccount {
    func cellViewModel() -> SavingCellViewModel{
        
        let formattedBalance = currency.formatted(amount: balance) ?? ""
        let formattedTargetBalance = currency.formatted(amount: targetBalance) ?? ""
        let viewModel = SavingCellViewModel(name: productName, accountNumber: preferredAccountNumber, balanceAmount: formattedBalance, targetAmount: formattedTargetBalance)
        return viewModel
    }
}
