//
//  ListViewController.swift
//  Bankieren
//
//  Created by Ian Dundas on 07/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import UIKit
import ReactiveKit

public protocol ListViewModelType{
    var listDidUpdate: SafeSignal<Void> {get}
    
    func sectionCount() -> Int
    func itemCount(section index: Int) -> Int
    
    func title(section index: Int) -> String?
}

public class ListViewController: BaseBoundViewController<ListViewModelType>, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    // MARK: Configuration points:
    public var createCell: ((ListViewModelType, IndexPath, UITableView) -> UITableViewCell)?
    public var rowHeight: CGFloat = 50
    public var sectionHeight: CGFloat = 30
    
    // MARK: Binding
    override internal func bindTo(viewModel: ListViewModelType) {
     
        // bind(to: Deallocatable) removes need to [weak self] to access tableview
        viewModel.listDidUpdate.bind(to: self.tableView) { (tableView: UITableView, _) in
            // TODO: refactor to provide a Changeset diff from viewModel 
            // in order to make fine-grained updates to the TableView.
            
            // For now, just reload data:
            tableView.reloadData()
        }
    }
    
    
    // MARK: UITableViewDelegate
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = viewModel.itemCount(section: section)
        return rows
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let createCell = createCell else { fatalError("Please provide a createCell configuration closure.") }
        let cell = createCell(viewModel, indexPath, tableView)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(section: section)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
}



// Default usage of List VC:
public extension ListViewController {
    public static func create(viewModelFactory: @escaping (ListViewController) -> ListViewModelType) -> ListViewController{
        return create(storyboard: UIStoryboard(name: "List", bundle: Bundle.ui), viewModelFactory: downcast(closure: viewModelFactory)) as! ListViewController
    }
}
