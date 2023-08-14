//
//  ToastersQueue.swift
//  SourceProject
//
//  Created by Artem Syrytsia on 20.07.2023.
//

import Foundation

/// Object that is responsible of storing toasters and their sequence in a queue.
struct ToastersQueue {
    
    // MARK: - Properties
    
    /// All toasters list.
    private var list = Array<ToasterModel>()
    
    /// Queue to present toasters.
    private let queue = DispatchQueue(label: "global.toasters.serial.queue")
    
    // MARK: - Public
    
    /// Add new toaster to the end of queue.
    public mutating func enqueue(_ toaster: ToasterModel) {
        queue.sync {
            list.append(toaster)
        }
    }
    
    /// Remove toaster from queue.
    public mutating func dequeue(_ toaster: ToasterModel) {
        queue.sync {
            guard !list.isEmpty,
                  let index = list.firstIndex(of: toaster) else { return }
            list.remove(at: index)
        }
    }
    
    /// Return next toaster by priority.
    public mutating func getNext() -> ToasterModel? {
        guard !list.isEmpty else { return nil }
        
        if let item = list.first(where: { $0.priority == .emergency }) {
            return item
        } else {
            return list.first
        }
    }
    
    /// Remove all toasters from a queue.
    public mutating func clearQueue() {
        queue.sync {
            list.removeAll()
        }
    }
    
}
