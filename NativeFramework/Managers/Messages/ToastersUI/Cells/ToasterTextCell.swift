//
//  ToasterTextCell.swift
//  SourceProject
//
//  Created by Artem Syrytsia on 21.07.2023.
//

import UIKit

class ToasterTextCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var conetentBGView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    private var toaster: ToasterModel?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupAppearances()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        icon.image = nil
        title.text = nil
        setupAppearances()
    }
    
    private func setupAppearances() {
        backgroundColor = .clear
        backgroundView?.backgroundColor = .clear
        
        selectionStyle = .none
        
        conetentBGView.backgroundColor = .white
        conetentBGView.roundCorners(radius: 10.0)
        
        icon.isHidden = false
        icon.tintColor = .black
        icon.backgroundColor = .clear
        
        title.textColor = .black
        title.font = .customFont(.interRegular, 14.0)
        title.numberOfLines = 0
    }
    
    // MARK: - Public
    
    func setup(with toaster: ToasterModel) {
        self.toaster = toaster
        
        switch toaster.type {
        case .text(let text):
            title.text = text
            
        case .attributed(let attributedText):
            title.attributedText = attributedText
            
        default:
            assertionFailure("🌁 The rest types has own cells. This one was created for text only.")
            return
        }
        
        if let img = toaster.icon {
            icon.image = img.withRenderingMode(.alwaysTemplate)
            icon.isHidden = false
        } else {
            icon.isHidden = true
        }
    }
    
}
