//
//  AccountListViewModel.swift
//  Bankieren
//
//  Created by Ian Dundas on 06/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift
import Model
import UserInterface
import Diff


// The interface that the Coordinator sees is different to the interface the ViewController sees:
public protocol AccountListCoordinatorHandle{
    func section(index:Int) -> AccountListSection
    
    func paymentCellData(index: Int) -> PaymentCellData
    func savingCellData(index: Int) -> SavingCellData
}

public enum AccountListSection{
    case paymentAccounts
    case savingAccounts
    
    public var title: String {
        switch self {
        case .paymentAccounts: return "Payments"
        case .savingAccounts: return "Savings"
        }
    }
}

// We consume [ListUpdate] events, map to these from the Diff from old->new Realm Results:
extension Diff {
    func toListUpdate() -> [ListUpdate] {
        return elements.map { (diffElement) -> ListUpdate in
            switch diffElement{
                
            case let .insert(at: index):
                return .sectionChange(
                    sectionIndex: 0,
                    deletions: [],
                    insertions: [index],
                    modifications: [])
                
            case let .delete(at: index):
                return .sectionChange(
                    sectionIndex: 0,
                    deletions: [index],
                    insertions: [],
                    modifications: [])
            }
        }
    }
}

public class AccountListViewModel: ListViewModelType, AccountListCoordinatorHandle{
    
    // Public (immutable) signal indicating List updated
    public var listDidUpdate: Signal<ListUpdate, NoError>{
        return accountsUpdated.toSignal()
    }
    
    // Private (mutable) PublishSubject allows events to be sent on itself - indicating Accounts Updated in this case
    fileprivate let accountsUpdated = SafePublishSubject<ListUpdate>()
    
    fileprivate var paymentAccounts: Results<PaymentAccount> {
        didSet{

            // We've set a new Result, create a diff with the old set and map it to ListUpdates
            let diff: [ListUpdate] = oldValue.diff(paymentAccounts).toListUpdate()
            
            // pass those updates to accountsUpdated:
            diff.forEach(self.accountsUpdated.next)

            paymentUpdatesToken = paymentAccounts.addNotificationBlock { [weak self] (changes: RealmCollectionChange<Results<PaymentAccount>>) in
                guard let strongSelf = self else {return}
                
                switch changes {
                case .initial(_): break // not actually necessary
                    
                case let .update(_, deletions: deletedIndexes, insertions: insertedIndexes, modifications: updatedIndexes):
                    strongSelf.accountsUpdated.next(.sectionChange(
                        sectionIndex: 0,
                        deletions: deletedIndexes,
                        insertions: insertedIndexes,
                        modifications: updatedIndexes))
                    
                case .error(let error):
                    // just log it for now
                    print("Error: \(error)")
                }
            }
        }
    }
    
    
    // TODO reduce code duplication below:
    fileprivate var savingAccounts: Results<SavingAccount> {
        didSet{
            
            // We've set a new Result, create a diff with the old set and map it to ListUpdates
            let diff: [ListUpdate] = oldValue.diff(savingAccounts).toListUpdate()
            
            // pass those updates to accountsUpdated:
            diff.forEach(self.accountsUpdated.next)
            
            savingUpdatesToken = savingAccounts.addNotificationBlock { [weak self] (changes: RealmCollectionChange<Results<SavingAccount>>) in
                guard let strongSelf = self else {return}
                
                switch changes {
                case .initial(_): break // not actually necessary
                    
                case let .update(_, deletions: deletedIndexes, insertions: insertedIndexes, modifications: updatedIndexes):
                    strongSelf.accountsUpdated.next(.sectionChange(
                        sectionIndex: 1,
                        deletions: deletedIndexes,
                        insertions: insertedIndexes,
                        modifications: updatedIndexes))
                    
                case .error(let error):
                    // just log it for now
                    print("Error: \(error)")
                }
            }
        }
    }
    
    // retain Realm notification tokens:
    private var paymentUpdatesToken: NotificationToken? = nil
    private var savingUpdatesToken: NotificationToken? = nil
    
    private let bag = DisposeBag()
    public init(actions: AccountsViewController.Actions){
        
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
    
    public func sectionCount() -> Int {
        return 2
    }
    
    public func itemCount(section index: Int) -> Int {
        switch section(index: index){
        case .paymentAccounts: return paymentAccounts.count
        case .savingAccounts: return savingAccounts.count
        }
    }
    
    public func title(section index: Int) -> String?{
        return section(index: index).title
    }
    
    
    // MARK: AccountListCoordinatorHandle
    
    public func section(index:Int) -> AccountListSection{
        switch index{
        case 0: return .paymentAccounts
        case 1: return .savingAccounts
        default: fatalError("Section not found for index: \(index)")
        }
    }
    
    public func paymentCellData(index: Int) -> PaymentCellData{
        return paymentAccounts[index].cellViewModel()
    }
    
    public func savingCellData(index: Int) -> SavingCellData{
        return savingAccounts[index].cellViewModel()
    }
}


public extension PaymentAccount{
    public func cellViewModel() -> PaymentCellData{
        
        let formattedBalance = currency.formatted(amount: balance) ?? ""
        let viewModel = PaymentCellData(name: name, accountNumber: preferredAccountNumber, amount: formattedBalance)
        return viewModel
    }
}

public extension SavingAccount {
    public func cellViewModel() -> SavingCellData{
        
        let formattedBalance = currency.formatted(amount: balance) ?? ""
        let formattedTargetBalance = currency.formatted(amount: targetBalance) ?? ""
        let viewModel = SavingCellData(name: productName, accountNumber: preferredAccountNumber, balanceAmount: formattedBalance, targetAmount: formattedTargetBalance)
        return viewModel
    }
}
