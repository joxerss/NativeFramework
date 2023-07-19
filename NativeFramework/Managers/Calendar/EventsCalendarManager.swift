//
//  CalendarManager.swift
//  NativeFramework
//
//  Created by Artem on 15.10.2019.
//  Copyright © 2019 Sannacode. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

public enum CustomeError {
    case failure(Error)
    case calendarAccessDenied
    case calendarAccessDeniedOrRestricted
    //case calendarModuleOpened
    case eventAddedToCalendar
    case eventNotAddedToCalendar
    case eventAlreadyExistsInCalendar
}

//typealias ResultCustomError = Dictionary<Bool, ??>
//typealias EventsCalendarManagerResponse = (_ result: ResultCustomError<Bool, CustomError>) -> Void

open class EventsCalendarManager: NSObject {
    
    // MARK: - Varibles
    private let kUserDefaultsCalendar = "Costless_calendarID"
    private let calendarTitle = "Costless Calendar"
    private var eventModalVC: EKEventEditViewController!
    private var eventStore: EKEventStore!
    
    // MARK: - Lifecycle
    
    public override init() {
        super.init()
        eventStore = EKEventStore()
    }
    
    // MARK: - Appearances
    
    open func setupAppearances() {
        eventModalVC.navigationBar.tintColor = .white
        eventModalVC.navigationBar.barTintColor = .orange
        eventModalVC.navigationBar.isTranslucent = false
        eventModalVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    // MARK: - Get access and status.
    
    // Request access to the Calendar
    
    private func requestAccess(completion: @escaping EKEventStoreRequestAccessCompletionHandler) {
        eventStore.requestAccess(to: EKEntityType.event) { (accessGranted, error) in
            completion(accessGranted, error)
        }
    }
    
    // Get Calendar auth status
    
    private func getAuthorizationStatus() -> EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: EKEntityType.event)
    }
    
    // MARK: - Event
    
    // Generate an event which will be then added to the calendar
    
    private func generateEvent(event: Event) -> EKEvent {
        let newEvent = EKEvent(eventStore: eventStore)
        
        newEvent.calendar = getCalendar()
        newEvent.title = event.name
        newEvent.startDate = event.dateStart
        newEvent.endDate = event.dateEnd
        newEvent.notes = event.notes
        newEvent.isAllDay = event.isFullDay
        
        // Set default alarm minutes before event
        let alarm = EKAlarm()//EKAlarm(absoluteDate: event.dateEnd)
        newEvent.addAlarm(alarm)
        
        if let oldEvent = existedEvent(event: newEvent ) {
            return oldEvent
        } else {
            return newEvent
        }
    }
    
    // Check if the event was already added to the calendar
    
    private func eventAlreadyExists(event eventToAdd: EKEvent) -> Bool {
        guard let calendar = getCalendar() else {
            return false
        }
        
        let predicate = eventStore.predicateForEvents(withStart: getCalendarCreationDate(), end: NSDate() as Date, calendars: [calendar])
        let existingEvents = eventStore.events(matching: predicate)
        
        let eventAlreadyExists = existingEvents.contains { (event) -> Bool in
            return eventToAdd.title == event.title /*&& event.startDate == eventToAdd.startDate && event.endDate == eventToAdd.endDate*/
        }
        return eventAlreadyExists
    }
    
    /// Check dose event exist in Costless calendar
    private func existedEvent(event eventToAdd: EKEvent) -> EKEvent? {
        guard let calendar = getCalendar() else {
            return nil
        }
        
        let predicate = eventStore.predicateForEvents(withStart: getCalendarCreationDate(), end: NSDate() as Date, calendars: [calendar])
        let existingEvents = eventStore.events(matching: predicate)
        
        let existedEvent = existingEvents.first(where: { (event) -> Bool in
            return eventToAdd.title == event.title /*&& event.startDate == eventToAdd.startDate && event.endDate == eventToAdd.endDate*/
        })
        return existedEvent
    }
    
    // MARK: - Calendar
    // Create or get costless calendar
    
    open func getCalendar() -> EKCalendar? {
        let defaults = UserDefaults.standard

        checkIsCalendarExist()
        if let id = defaults.string(forKey: kUserDefaultsCalendar) {
            return eventStore.calendar(withIdentifier: id)
        } else {
            let calendar = EKCalendar(for: .event, eventStore: eventStore)

            calendar.title = calendarTitle
            calendar.cgColor = UIColor.orange.cgColor
            calendar.source = eventStore.defaultCalendarForNewEvents?.source
            do {
                try eventStore.saveCalendar(calendar, commit: true)
                defaults.set(calendar.calendarIdentifier, forKey: kUserDefaultsCalendar)
                setCalendarCreationDate()
                defaults.synchronize()
            } catch {
                print("⚠️ Calendar dosen't create!")
            }
            
            return calendar
        }
    }
    
    /// Find calendar by name and remind his id.
    ///
    /// U must check is Costles calendar contains and his id was lost.
    private func checkIsCalendarExist() {
        let calendars = eventStore.calendars(for: .event)
        if let calendar = calendars.first(where: { $0.title == calendarTitle }) {
            let defaults = UserDefaults.standard
            defaults.set(calendar.calendarIdentifier, forKey: kUserDefaultsCalendar)
            setCalendarCreationDate()
            defaults.synchronize()
        }
    }
    
    private func getCalendarCreationDate() -> Date {
        let userDefaults = UserDefaults.standard
        // retrieve from user defaults
        let limitDate = userDefaults.object(forKey: "calendarCreationDate") as? NSDate
        
        if limitDate != nil {
            return limitDate! as Date
        } else {
            setCalendarCreationDate()
            return NSDate() as Date
        }
    }
    
    private func setCalendarCreationDate() -> Void {
        let userDefaults = UserDefaults.standard

        // save to user defaults
        userDefaults.set(NSDate(), forKey: "calendarCreationDate")
        userDefaults.synchronize()
    }
    
    
    // MARK: - Add manually.
    
    // Show event kit ui to add event to calendar
            
    open func presentCalendarModalToAddEvent(event: Event, completion : @escaping ((CustomeError) -> ()) ) {
        let authStatus = getAuthorizationStatus()
        switch authStatus {
        case .authorized:
            presentEventCalendarDetailModal(event: event, completion: completion)
        case .notDetermined:
            //Auth is not determined
            //We should request access to the calendar
            requestAccess { (accessGranted, error) in
                if accessGranted {
                    DispatchQueue.main.async { [weak self] in
                        self?.presentEventCalendarDetailModal(event: event, completion: completion)
                    }
                } else {
                    // Auth denied, we should display a popup
                    completion(.calendarAccessDenied)
                }
            }
        case .denied, .restricted:
            // Auth denied or restricted, we should display a popup
            completion(.calendarAccessDeniedOrRestricted)
            showSettingsAlert()
        }
    }
    
    // Present edit event calendar modal
        
    private func presentEventCalendarDetailModal(event: Event, completion: @escaping ((CustomeError) -> ()) ) {
        let event = generateEvent(event: event)
        eventModalVC = EKEventEditViewController()
        eventModalVC.event = event
        eventModalVC.eventStore = eventStore
        eventModalVC.editViewDelegate = self
        setupAppearances()
        
        assertionFailure("Presend view controller here.")
    }
    
    // MARK: - Add programmatically. (please check this logic befor using)
    
    // Programatical add
    // Check Calendar permissions auth status
    // Try to add an event to the calendar if authorized
    
    open func addEventToCalendar(event: Event, completion : @escaping ((CustomeError)->()) ) {
        let authStatus = getAuthorizationStatus()
        switch authStatus {
        case .authorized:
            addEvent(event: event, completion: { (result) in
                switch result {
                case .eventAddedToCalendar:
                    completion(.eventAddedToCalendar)
                case .failure(let error):
                    completion(.failure(error))
                default:
                    assertionFailure("⚠️ addEventToCalendar(event: Event, completion : @escaping ((CustomeError)->()))")
                }
            })
            break
        case .notDetermined:
            //Auth is not determined
            //We should request access to the calendar
            requestAccess { [weak self] (accessGranted, error) in
                if accessGranted {
                    self?.addEvent(event: event, completion: { (result) in
                        switch result {
                        case .eventAddedToCalendar:
                            completion(.eventAddedToCalendar)
                        case .failure(let error):
                            completion(.failure(error))
                        default:
                            assertionFailure("⚠️ addEventToCalendar(event: Event, completion : @escaping ((CustomeError)->()))")
                        }
                    })
                } else {
                    // Auth denied, we should display a popup
                    completion(.calendarAccessDenied)
                }
            }
        case .denied, .restricted:
            // Auth denied or restricted, we should display a popup
            completion(.calendarAccessDeniedOrRestricted)
            showSettingsAlert()
        }
    }

    private func addEvent(event: Event, completion : @escaping ((CustomeError) -> ()) ) {
        let eventToAdd = generateEvent(event: event)
        if !eventAlreadyExists(event: eventToAdd) {
            do {
                try eventStore.save(eventToAdd, span: .thisEvent)
            } catch {
                // Error while trying to create event in calendar
                completion(.eventNotAddedToCalendar)
            }
            completion(.eventAddedToCalendar)
        } else {
            completion(.eventAlreadyExistsInCalendar)
        }

    }

}

// MARK: - EKEventEditViewDelegate

extension EventsCalendarManager: EKEventEditViewDelegate {
    
    public func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Allerts.

extension EventsCalendarManager {
    
    open func showSettingsAlert() {
        let yes = UIAlertAction(title: "yes", style: .default, handler: { (alert) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                DispatchQueue.main.async {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        })
        
        let no = UIAlertAction(title: "cancel", style: .cancel, handler: { (alert) in })
        let alertController = UIAlertController(title: "needAccessCalendar",
                                                message: "goToCalendarQuestion",
                                                preferredStyle: .alert)
        alertController.addAction(yes)
        alertController.addAction(no)
        
        
        assertionFailure("Presend view controller here.")
    }
}
