//
//  AccountListViewController.swift
//  Bankieren
//
//  Created by Ian Dundas on 06/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import UIKit

protocol AccountListViewModelType{
    
}

class AccountListViewController: BaseBoundViewController<AccountListViewModelType>  {

    static func create(viewModelFactory: @escaping (AccountListViewController) -> AccountListViewModelType) -> AccountListViewController{
        return create(storyboard: UIStoryboard(name: "AccountList", bundle: Bundle.main), viewModelFactory: downcast(closure: viewModelFactory)) as! AccountListViewController
    }
   
}
