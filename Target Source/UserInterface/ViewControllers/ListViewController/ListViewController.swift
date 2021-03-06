//
//  ListViewController.swift
//  Bankieren
//
//  Created by Ian Dundas on 07/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import UIKit
import ReactiveKit

public enum ListUpdate{
    case initial
    case sectionChange(sectionIndex: Int, deletions: [Int], insertions: [Int], modifications: [Int])
}

public protocol ListViewModelType{
    var listDidUpdate: SafeSignal<ListUpdate> {get}
    
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
        viewModel.listDidUpdate.bind(to: self.tableView) { (tableView: UITableView, changes: ListUpdate) in
            
            switch changes {
            case .initial:
                tableView.reloadData()
                
            case let .sectionChange(sectionIndex: sectionIndex, deletions: deletedIndexes, insertions: insertedIndexes, modifications: modifiedIndexes):
                let deletedIndexPaths = deletedIndexes.map {IndexPath(row: $0, section: sectionIndex)}
                let insertedIndexPaths = insertedIndexes.map {IndexPath(row: $0, section: sectionIndex)}
                let modifiedIndexPaths = modifiedIndexes.map {IndexPath(row: $0, section: sectionIndex)}

                tableView.beginUpdates()
                tableView.deleteRows(at: deletedIndexPaths, with: .automatic)
                tableView.insertRows(at: insertedIndexPaths, with: .automatic)
                tableView.reloadRows(at: modifiedIndexPaths, with: .automatic)
                tableView.endUpdates()
            }
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
