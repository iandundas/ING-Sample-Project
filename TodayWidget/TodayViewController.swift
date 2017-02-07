//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by Ian Dundas on 07/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import UIKit
import NotificationCenter
import UserInterface
import ReactiveKit
import RealmSwift
import Model

class WidgetAccountsListViewModel: ListViewModelType, AccountListCoordinatorHandle{
    
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
    
    public func paymentCellData(index: Int) -> PaymentCellViewModel{
        return paymentAccounts[index].cellViewModel()
    }
    
    public func savingCellData(index: Int) -> SavingCellViewModel{
        return savingAccounts[index].cellViewModel()
    }
}

class TodayViewController: UIViewController, NCWidgetProviding {

    let listViewController = ListViewController.create(viewModelFactory: { (listViewController) -> ListViewModelType in
        return WidgetAccountsListViewModel()
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Realm.configureING()
        
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
        
        addChildViewController(listViewController)
        view.addSubview(listViewController.view)
        listViewController.didMove(toParentViewController: self)
        
        listViewController.view.translatesAutoresizingMaskIntoConstraints = false
        listViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        listViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        listViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        listViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .expanded: preferredContentSize = CGSize(width: maxSize.width, height: listViewController.idealHeight)
        case .compact: preferredContentSize = maxSize
        }
    }

    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}

extension ListViewController{
    var idealHeight: CGFloat{
        
        var height: CGFloat = 0
        
        for i in 0..<viewModel.sectionCount(){
            height += sectionHeight
            height += rowHeight * CGFloat(viewModel.itemCount(section: i))
        }
        
        return height
    }
}
