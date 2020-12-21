//
//  BaseCell.swift
//  NativeFramework
//
//  Created by Artem Syritsa on 01.07.2020.
//  Copyright © 2020 Artem Syritsa. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {
    
    typealias CellSelectClosure = ((_ cellIndex: IndexPath, _ isSelect: Bool)->(Void))
    
    // MARK: - Properties
    
    var cellIndex: IndexPath?
    var selectCompletion: CellSelectClosure?
    
    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        prepareForReuse()
        prepareViews()
        setupAppearances()
        localize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //setupAppearances()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// This method will call when System Color Scheme did changed.
    /// It will call by system **automatically**.
    /// - Parameter previousTraitCollection: System UITraitCollection
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        //        guard UIApplication.shared.applicationState == .inactive else {
        //            return
        //        }
        
        // For get current call "slef.traitCollection.userInterfaceStyle"
        setupAppearances()
    }
    
     // MARK: - Overrides
    
    @objc func localize() -> Void // override for localize
    {}
    
    @objc func setupAppearances() -> Void { // override for configurate collor scheme
        self.backgroundColor = .clear
        self.backgroundView?.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
    @objc func prepareViews() -> Void // override for configurate view schemes at start (show or hide | delegates and datasources)
    {
        self.selectionStyle = .none
    }

}
