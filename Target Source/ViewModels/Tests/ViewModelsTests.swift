//
//  ViewModelsTests.swift
//  ViewModelsTests
//
//  Created by Ian Dundas on 08/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import XCTest
@testable import ViewModels
@testable import UserInterface
@testable import Model
import RealmSwift
import ReactiveKit
import Nimble

/*  Note: These tests are not intented to be exhaustive, only to demonstrate
    how we can test the Reactive Signals that the ViewModel emits */

class AccountListViewModelTests: RealmTestCase {
    
    var viewModel: AccountListViewModel!
    var tableViewActions: AccountsViewController.Actions!
    var onlyVisibleAccountsSwitch: ReactiveKit.Property<Bool>!
    
    override func setUp() {
        super.setUp()
        
        onlyVisibleAccountsSwitch = Property(false) // switch off by default
        tableViewActions = AccountsViewController.Actions(filterOnlyVisibleAccounts: onlyVisibleAccountsSwitch.toSignal())
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testEmptyDatabase() {
        
        viewModel = AccountListViewModel(actions: tableViewActions)
        expect(self.viewModel.itemCount(section: 0)) == 0
        expect(self.viewModel.itemCount(section: 1)) == 0
    }
    
    func testInsertEvent() {
        
        viewModel = AccountListViewModel(actions: tableViewActions, realm: realm)
        
        let changes = viewModel.listDidUpdate.store() // record signal changes
        
        try! realm.write {
            realm.add(PaymentAccount(value: ["id": NSUUID().uuidString]))
        }
        
        expect(changes.count).toEventually(equal(1))
        expect(changes[0]).toEventually(equal(ListUpdate.sectionChange(sectionIndex: 0, deletions: [], insertions: [0], modifications: [])))
    }
    
    func testDeleteEvent() {
        
        viewModel = AccountListViewModel(actions: tableViewActions, realm: realm)
        
        let account = PaymentAccount(value: ["id": NSUUID().uuidString])
        try! realm.write {
            realm.add(account)
        }
        
        let changes = viewModel.listDidUpdate.store() // record signal changes
        
        try! realm.write{
            realm.delete(account)
        }
        
        expect(changes.count).toEventually(equal(2))
        expect(changes[0]).toEventually(equal(ListUpdate.sectionChange(sectionIndex: 0, deletions: [], insertions: [0], modifications: [])))
        expect(changes[1]).toEventually(equal(ListUpdate.sectionChange(sectionIndex: 0, deletions: [0], insertions: [], modifications: [])))
    }
    
    
    
    func testVisibilityChangeEvent() {
        
        // Turn on the visibility switch:
        onlyVisibleAccountsSwitch.value = true

        viewModel = AccountListViewModel(actions: tableViewActions, realm: realm)
        
        
        // Add account:
        let account = PaymentAccount(value: ["id": NSUUID().uuidString, "visible": false])
        
        try! realm.write {
            realm.add(account)
        }
        
        let changes = viewModel.listDidUpdate.store() // record signal changes
        
        // Should be no Accounts because the only one we've added is not visible, and the Visibility filter is on.
        expect(changes.count).toEventually(equal(0))

        // Okay, now make that account visible
        try! realm.write{
            account.visible = true
        }
        
        // Check that we have an insert event for that account!
        expect(changes[0]).toEventually(equal(ListUpdate.sectionChange(sectionIndex: 0, deletions: [], insertions: [0], modifications: [])))
    }
    
    
}

extension ListUpdate: Equatable{}
public func ==(a:ListUpdate, b: ListUpdate) -> Bool {
    
    switch(a,b){
    case (.initial, .initial): return true
        case let (.sectionChange(sectionIndex: indexA, deletions: deletedA, insertions: insertedA, modifications: modsA),
                  .sectionChange(sectionIndex: indexB, deletions: deletedB, insertions: insertedB, modifications: modsB)):
            return indexA == indexB && deletedA == deletedB && insertedA == insertedB && modsA == modsB
    default:
        return false
    }
}
