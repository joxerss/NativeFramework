//
//  UIView+Extensions.swift
//  NativeFramework
//
//  Created by Artem on 8/19/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - Generate Identifier
    
    class var identifier: String {
        return String(describing: self)
    }
    
    // MARK: - Generate views block
    
    /// Generate small view which will contans image view.
    /// - Parameters:
    ///   - image: image will be displaying.
    ///   - imgTinColor: render image with mode template with tintColor.
    /// - Returns: UIImageView inside UIView. UIImageView size 20x20 px. UIView size 30x30.
    public func textFieldLeftView(_ image: UIImage, imgTinColor: UIColor) -> UIView {
        let leftContainer : UIView = .init(frame: .init(x: 0, y: 0, width: 30, height: 30))
        leftContainer.backgroundColor = .clear
        
        let imgView : UIImageView = .init(frame: .init(x: 5, y: 5, width: 20, height: 20))
        imgView.backgroundColor = .clear
        imgView.tintColor = imgTinColor
        
        imgView.contentMode = .scaleAspectFit
        imgView.image = image.withRenderingMode(.alwaysTemplate)
        
        leftContainer.addSubview(imgView)
        
        leftContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true
        leftContainer.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        return leftContainer
    }
    
    // MARK: - Appearances
    
    public func makeRoundButton(_ cornerRadius: CGFloat) -> Void {
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius
    }
    
    public func makeShadowButton(_ shadowRadius: CGFloat) -> Void {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = shadowRadius
    }
    
}
