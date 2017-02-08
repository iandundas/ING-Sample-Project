//
//  AccountListCells.swift
//  Bankieren
//
//  Created by Ian Dundas on 07/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import UIKit

// MARK: Payment Cell:

public struct PaymentCellData {
    let name: String
    let accountNumber: String
    let amount: String // storing pre-formatted data, so String.
    
    // public memberwise initializer not available to other frameworks, so have to define one:
    public init(name: String, accountNumber: String, amount: String){
        self.name = name
        self.accountNumber = accountNumber
        self.amount = amount
    }
}

public class PaymentCell: UITableViewCell {
    static public let defaultID = "PaymentAccountCell"
    
    @IBOutlet private var accountName: UILabel!{
        didSet{
            accountName.font = Style.Fonts.cellTitleFont
        }
    }
    @IBOutlet private var accountNumber: UILabel!{
        didSet{
            accountNumber.font = Style.Fonts.cellSubtitleFont
        }
    }
    @IBOutlet private var amount: UILabel!{
        didSet{
            amount.font = Style.Fonts.cellValueFont
        }
    }
    
    public var viewModel: PaymentCellData? {
        didSet{
            guard let viewModel = viewModel else {return}
            accountName.text = viewModel.name
            accountNumber.text = viewModel.accountNumber
            amount.text = viewModel.amount
        }
    }
}



// MARK: Savings Cell:

public struct SavingCellData {
    public let name: String
    public let accountNumber: String
    public let balanceAmount: String
    public let targetAmount: String
    
    // public memberwise initializer not available to other frameworks, so have to define one:
    public init(name: String, accountNumber: String, balanceAmount: String, targetAmount: String){
        self.name = name
        self.accountNumber = accountNumber
        self.balanceAmount = balanceAmount
        self.targetAmount = targetAmount
    }
}

public class SavingCell: UITableViewCell {
    static public let defaultID = "SavingAccountCell"
    
    @IBOutlet private var accountName: UILabel!{
        didSet{
            accountName.font = Style.Fonts.cellTitleFont
        }
    }
    @IBOutlet private var accountNumber: UILabel!{
        didSet{
            accountNumber.font = Style.Fonts.cellSubtitleFont
        }
    }
    @IBOutlet private var balanceAmount: UILabel!{
        didSet{
            balanceAmount.font = Style.Fonts.cellValueFont
        }
    }
    @IBOutlet private var targetAmount: UILabel!{
        didSet{
            targetAmount.font = Style.Fonts.cellSubvalueFont
        }
    }
    
    public var viewModel: SavingCellData? {
        didSet{
            guard let viewModel = viewModel else {return}
            accountName.text = viewModel.name
            accountNumber.text = viewModel.accountNumber
            balanceAmount.text = viewModel.balanceAmount
            targetAmount.text = viewModel.targetAmount
        }
    }
}
