//
//  ToastersRouter.swift
//  SourceProject
//
//  Created by Artem Syrytsia on 20.07.2023.
//

import Foundation

final class ToastersRouter {
    
    // MARK: - Properties
    
    /// Should stop display time if alert is shown and re-calculate when alert was dismissed
    var toastersBusyState: Bool = false {
        didSet{
            guard oldValue != toastersBusyState else { return }
            toastersBusyState ? cancelToastersLifetime() : resetToastersLifetime()
        }
    }
    
    /// Max toaster at the same time.
    private let toastersToShowCount: Int = 3
    
    /// TableViewController - container for all alert presentations
    lazy var toastersViewController: ToastersViewController =  { return .instantiate(self) }()
    
    /// Current presented queue
    private var showingQueue = Array<ToasterModel>()
    
    /// Notify every second and remove toaster with displayed time more than 30 seconds
    private var timer: Timer?
    
    /// Save expiration display date for each presented toaster
    private var timetable: NSMapTable<ToasterModel, NSDate> = NSMapTable(keyOptions: .weakMemory, valueOptions: .strongMemory)
    
    /// Global toasters queue to storing all toasters
    private var queue = ToastersQueue()
    
    private let syncQueue = DispatchQueue(label: "ui.toasters_router.serial.queue")
    
    // MARK: - Lifecycle
    
    init() {
        // Setup timer for tracking tosters life time
        showingQueue.reserveCapacity(toastersToShowCount)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.checkEachToasterLifeTime()
        }
    }
    
    /// Show toaster if conditions are 'OK'
    private func showIfNeeded() {
        
        if let toasterToShow = queue.getNext(), toasterToShow.priority == .emergency {
            showToaster(toasterToShow)
            return
        }
        
        guard toastersBusyState == false,
            showingQueue.count < toastersToShowCount,
            let toasterToShow = queue.getNext() else { return }

        showToaster(toasterToShow)
    }
}

// MARK: - Timetable

extension ToastersRouter {
    
    private func cancelToastersLifetime() {
        timetable.removeAllObjects()
    }
    
    private func resetToastersLifetime() {
        showingQueue.forEach { setupLifetime(for: $0) }
    }
    
    private func setupLifetime(for toaster: ToasterModel) {
        var displayToasterTime: Double
        switch toaster.type {
        case .countDown(_, let time, _):
            displayToasterTime = time
            
        case .text, .attributed(_):
            displayToasterTime = 3.0
        }
        
        let expirationDate = NSDate(timeIntervalSinceNow: displayToasterTime)
        timetable.setObject(expirationDate, forKey: toaster)
        debugPrint("⏰ time to show toaster \(displayToasterTime) sec.")
    }
    
    /// Hide toaster if presentation date is expired
    private func checkEachToasterLifeTime() {
        let currentMoment = NSDate()
        
        timetable.keyEnumerator().allObjects.compactMap({ $0 as? ToasterModel }).filter({ toasterModel in
            let toasterDate = timetable.object(forKey: toasterModel) ?? currentMoment
            return toasterDate < currentMoment
        }).forEach { hideToaster($0) }

        syncQueue.sync {
            showIfNeeded()
        }
    }

    /// Add into showing queue and display UI
    private func showToaster(_ toaster: ToasterModel) {
        queue.dequeue(toaster)
        showingQueue.append(toaster)
        
        setupLifetime(for: toaster)
        
        DispatchQueue.main.async { [weak self] in
            self?.toastersViewController.showToaster(toaster)
        }
    }
    
    /// Remove from showing queue and dimiss from UI
    private func hideToaster(_ toaster: ToasterModel) {
//        showingQueue = showingQueue.filter { $0 != toaster }
        showingQueue.removeAll(where: { $0 == toaster })
        
        DispatchQueue.main.async { [weak self] in
            self?.toastersViewController.hideToaster(toaster)
        }
        showIfNeeded()
    }

    /// Invalidate timer before toaster router will be destroyed
    func finish() {
        showingQueue.removeAll()
        timetable.removeAllObjects()
        queue.clearQueue()
        timer?.invalidate()
    }
}

// MARK: - ToastersPresenterActions

extension ToastersRouter: ToastersPresenterActions {
    func presentToaster(_ toaster: ToasterModel) {
        queue.enqueue(toaster)
    }
    
    func dismissToaster(_ toaster: ToasterModel) {
        hideToaster(toaster)
    }
}
