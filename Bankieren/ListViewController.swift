//
//  ListViewController.swift
//  Bankieren
//
//  Created by Ian Dundas on 07/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import UIKit
import ReactiveKit

protocol ListViewModelType{
    var listDidUpdate: SafeSignal<Void> {get}
    
    func sectionCount() -> Int
    func itemCount(section index: Int) -> Int
    func title(section index: Int) -> String?
}

class ListViewController: BaseBoundViewController<ListViewModelType>, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    // MARK: Configuration points:
    var createCell: ((ListViewModelType, IndexPath, UITableView) -> UITableViewCell)?
    
    
    // MARK: View Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    override func bindTo(viewModel: ListViewModelType) {
     
        // bind(to: Deallocatable) removes need to [weak self] to access tableview
        viewModel.listDidUpdate.bind(to: self.tableView) { (tableView: UITableView, _) in
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
