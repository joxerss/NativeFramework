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
    
    
    /*class func fromNib<T: UIView>(owner: Any? = nil) -> T {
     let nib = UINib(nibName: String(describing: self), bundle: nil)
     return nib.instantiate(withOwner: owner, options: nil).first as! T
     }*/
    
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
    
    /// Call this function to set default background from image.`
    public func setDefaultBackground(_ image: UIImage = #imageLiteral(resourceName: "app_background")) {
        // view.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "app_background").resizeImage(targetSize: UIScreen.main.bounds.size) ?? #imageLiteral(resourceName: "app_background"))
        self.backgroundColor = UIColor.init(patternImage: image.resizeImage(targetSize: UIScreen.main.bounds.size) ?? image)
    }
    
    /// This function will round part of view corners all tougether.
    /// - Parameters:
    ///   - corners: that must be rounded.
    public func roundCorners(radius: CGFloat = 8.0) {
        self.layer.cornerRadius = radius
        //self.layer.masksToBounds = true
    }
    
    /// This function will round part of view corners.
    /// - Parameters:
    ///   - corners: that must be rounded.
    ///   - radius: rounding value.
    ///
    /// ```
    /// view.roundCorners(corners: [.topLeft,
    ///                             .topRight,
    ///                             .bottomLeft,
    ///                             .bottomRight],
    ///                    radius: 8.0)
    /// ```
    /// - Note: If you want add shadow and corners radius, you should use **drop(shadowColor:shadowOffset:shadowOpacity:shadowRadius:cornerRadius:)** first.
    /// - Warning: This function doesn't work with **drop(shadowColor:shadowOffset:shadowOpacity:shadowRadius:cornerRadius:)**
    ///            You should always are call this function to update layer after screen rotation.
    public func roundCorners(corners: UIRectCorner, radius: CGFloat = 8.0) {
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    /// This functions will add shadow add corners radius.
    /// - Note: If you want add shadow and corners radius, you should use **drop(shadowColor:shadowOffset:shadowOpacity:shadowRadius:cornerRadius:)** first.
    /// - Warning: This function doesn't work with **roundCorners(corners:radius:)**
    /// - Parameter shadowRadius: value in CGFloat
    public func drop(shadowColor: UIColor = UIColor.black,
                     shadowOffset: CGSize = .zero,
                     shadowOpacity: Float = 0.25,
                     shadowRadius: CGFloat = 1.0,
                     cornerRadius: CGFloat = 8.0) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius
        
        self.layer.shadowColor = shadowColor.cgColor
        //self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
    }
    
    /// Call this function if you want to attach container to view.
    ///
    /// - Note: Call example.
    /// ```
    /// contentViewHandler.attach(content)
    /// ```
    public func attach(_ subView: UIView) -> Void {
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subView.frame = self.bounds
        
        if subView.superview != self {
            subView.removeFromSuperview()
            self.addSubview(subView)
        }
        
        subView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        subView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        subView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        subView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    }
    
    /// Call this function if you want to attach view to  container's center with size.
    ///
    /// - Note: Call example.
    /// ```
    /// imageView.attachToCenter(view: self, with: nil)
    /// ```
    public func attachToCenter(view handler: UIView, with size: CGSize? = nil) {
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if self.superview != handler {
            self.removeFromSuperview()
            handler.addSubview(self)
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        self.centerYAnchor.constraint(equalTo: handler.centerYAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: handler.centerXAnchor).isActive = true
        
        if let `size` = size {
            self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        handler.layoutIfNeeded()
    }
    
}
