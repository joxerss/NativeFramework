//
//  BaseTableViewController.swift
//  NativeFramework
//
//  Created by Artem Syritsa on 29.06.2020.
//  Copyright © 2020 Artem Syritsa. All rights reserved.
//

import UIKit

open class BaseTableViewController: UITableViewController {
    
    // MARK: - Life cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        prepareNavigationBar()
        prepareViews()
        setupAppearances()
        localize()
        NotificationCenter.default.addObserver(self, selector: #selector(self.localize), name: .kLanguageChanged, object: nil)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupObservers()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.removeObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// This method will call when System Color Scheme did changed.
    /// It will call by system **automatically**.
    /// - Parameter previousTraitCollection: System UITraitCollection
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        //guard UIApplication.shared.applicationState == .inactive else {
        //    return
        //}
        
        // For get current call "slef.traitCollection.userInterfaceStyle"
        setupAppearances()
        self.tableView.reloadData()
    }
    
    // MARK: - Overrides
    
    @objc open func localize() -> Void // override for localize
    {}
    
    @objc open func setupAppearances() -> Void // override for configurate collor scheme
    {}
    
    @objc open func prepareViews() -> Void // override for configurate view schemes at start (show or hide | delegates and datasources)
    {}
    
    @objc open func prepareNavigationBar() -> Void // override for configurate navigation bar schemes at start
    {}
    
    /// This method will call always in **viewWillAppear(_ animated: Bool)**.
    /// - Returns: Void function.
    @objc open func setupObservers() -> Void // override for configurate observers, use it only together with removeObservers()
    {}
    
    /// This method will call always in **viewDidDisappear(_ animated: Bool)**.
    /// - Returns: Void function.
    @objc open func removeObservers() -> Void // override,  use it only  it together with setupObservers()
    {}
    
    // MARK: - Table view data source
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
}
