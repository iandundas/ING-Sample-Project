//
//  ReactiveKitHelpers.swift
//  Bankieren
//
//  Created by Ian Dundas on 08/02/2017.
//  Copyright © 2017 Ian Dundas. All rights reserved.
//

import Foundation
import ReactiveKit


// Stores Signal events over time, so that we can analyse the order in which they occured:

class EventStore<Item> {
    
    private let signal: SafeSignal<Item>
    private let bag = DisposeBag()
    private var values: [Item] = []
    
    init(signal: SafeSignal<Item>){
        self.signal = signal
        
        signal.observeNext { (next) in
            self.values.append(next)
            }.dispose(in: bag)
    }
    
    subscript(index: Int) -> Item? {
        get {
            guard values.count > index else {return nil}
            return values[index]
        }
    }
    
    var count: Int{
        return values.count
    }
}

extension SignalProtocol{
    func store() -> EventStore<Element>{
        return EventStore(signal: self.suppressError(logging: false))
    }
}
