//
//  AccountListCells.swift
//  Bankieren
//
//  Created by Ian Dundas on 07/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import UIKit

// MARK: Payment Cell:

struct PaymentCellViewModel {
    let name: String
    let accountNumber: String
    let amount: String // storing pre-formatted data, so String.
}

class PaymentCell: UITableViewCell {
    static let defaultID = "PaymentAccountCell"
    
    @IBOutlet var accountName: UILabel!
    @IBOutlet var amount: UILabel!
    @IBOutlet var accountNumber: UILabel!
    
    var viewModel: PaymentCellViewModel? {
        didSet{
            guard let viewModel = viewModel else {return}
            accountName.text = viewModel.name
            accountNumber.text = viewModel.accountNumber
            amount.text = viewModel.amount
        }
    }
}



// MARK: Savings Cell:

struct SavingCellViewModel {
    let name: String
    let accountNumber: String
    let balanceAmount: String
    let targetAmount: String
}

class SavingCell: UITableViewCell {
    static let defaultID = "SavingAccountCell"
    
    @IBOutlet var accountName: UILabel!
    @IBOutlet var accountNumber: UILabel!
    @IBOutlet var balanceAmount: UILabel!
    @IBOutlet var targetAmount: UILabel!
    
    var viewModel: SavingCellViewModel? {
        didSet{
            guard let viewModel = viewModel else {return}
            accountName.text = viewModel.name
            accountNumber.text = viewModel.accountNumber
            balanceAmount.text = viewModel.balanceAmount
            targetAmount.text = viewModel.targetAmount
        }
    }
}
