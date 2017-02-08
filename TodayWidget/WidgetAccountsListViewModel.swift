//
//  WidgetAccountsViewModel.swift
//  Bankieren
//
//  Created by Ian Dundas on 08/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import Foundation
import UserInterface
import ReactiveKit
import RealmSwift
import Model
import ViewModels

class WidgetAccountsListViewModel: ListViewModelType, AccountListCoordinatorHandle{
    
    // we don't use realm auto-updating here, so "just" fire a Void event to update the screen once, then finish
    public var listDidUpdate = SafeSignal<Void>.just()
    
    fileprivate var paymentAccounts: Results<PaymentAccount>
    fileprivate var savingAccounts: Results<SavingAccount>
    
    public init(){
        let realm = try! Realm()
        
        paymentAccounts = realm.objects(PaymentAccount.self)
        savingAccounts = realm.objects(SavingAccount.self)
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
