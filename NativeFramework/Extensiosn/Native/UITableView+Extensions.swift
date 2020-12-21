//
//  UITableView+Extensions.swift
//  NativeFramework
//
//  Created by Artem Syritsa on 04.02.2020.
//  Copyright © 2020 Artem Syritsa. All rights reserved.
//

import UIKit

extension UITableView {
    
    // MARK: - Registe Cells
    
    func registerCellFromNib(_ nameCell: String) -> Void{
        let nib = UINib(nibName: nameCell, bundle: nil)
        self.register(nib, forCellReuseIdentifier: nameCell)
    }
    
}

// Pull to refresh.
extension UITableView {
    
    public typealias PullToRefreshCompletion = ()->()
    
    // MARK: - Associated Keys
    private struct AssociatedKeys {
        static var kPullToRefreshControl = "key_pullToRefreshControl"
        static var kPullToRefreshCompletion = "key_pullToRefreshCompletion"
    }
    
    // MARK: - Associated Properties
    private var pullToRefreshControl: UIRefreshControl {
        get {
            guard let view = objc_getAssociatedObject(self, &AssociatedKeys.kPullToRefreshControl) as? UIRefreshControl else {
                return initRefreshControl()
            }
            
            return view
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.kPullToRefreshControl, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private var pullToRefreshCompletion: PullToRefreshCompletion? {
        get {
            guard let completion = objc_getAssociatedObject(self, &AssociatedKeys.kPullToRefreshCompletion) as? PullToRefreshCompletion else {
                return nil
            }
            
            return completion
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.kPullToRefreshCompletion, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: - Init's
    
    private func initRefreshControl() -> UIRefreshControl {
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized())
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        self.addSubview(refreshControl) // not required when using UITableViewController
        
        self.pullToRefreshControl = refreshControl
        
        return refreshControl
    }
    
    // MARK: - Actions
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        guard let completion = self.pullToRefreshCompletion else { return }
        completion()
    }
    
    // MARK: - Public functions
    
    public func setupPullToRefresh(completion: PullToRefreshCompletion?) {
        _ = pullToRefreshControl
        self.pullToRefreshCompletion = completion
    }
    
    public func endPullToRefresh() {
        DispatchQueue.main.async { [weak self] in
            self?.pullToRefreshControl.endRefreshing()
        }
    }
    
    public func setupTableHeaderView(_ headerView: UIView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.tableHeaderView = headerView
        
        headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        self.layoutIfNeeded()
    }
}
