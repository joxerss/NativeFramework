//
//  UITextView+Extensions.swift
//  NativeFramework
//
//  Created by Artem on 8/19/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

// MARK: - Range

public extension NSRange {
    init(string: String, lowerBound: String.Index, upperBound: String.Index) {
        let utf16 = string.utf16
        
        let lowerBound = lowerBound.samePosition(in: utf16)
        let location = utf16.distance(from: utf16.startIndex, to: lowerBound!)
        let length = utf16.distance(from: lowerBound!, to: upperBound.samePosition(in: utf16)!)
        
        self.init(location: location, length: length)
    }
    
    init(range: Range<String.Index>, in string: String) {
        self.init(string: string, lowerBound: range.lowerBound, upperBound: range.upperBound)
    }
    
    init(range: ClosedRange<String.Index>, in string: String) {
        self.init(string: string, lowerBound: range.lowerBound, upperBound: range.upperBound)
    }
}

// MARK: - TapGestureRecognizer

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInTextView(textView: UITextView, inRange targetRange: NSRange) -> Bool {
        // Find the character that's been tapped on
        // location of tap in myTextView coordinates and taking the inset into account
        var location = self.location(in: textView)
        location.x -= textView.textContainerInset.left;
        location.y -= textView.textContainerInset.top;
        
        // character index at tap location
        let layoutManager = textView.layoutManager
        let characterIndex = layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(characterIndex, targetRange)
    }
    
}

// MARK: - TextView

extension UITextView {
    
    // MARK: - Typealias UITextView
    
    typealias DidTapTextCompletion = (() -> Void)
    typealias DidTapWordCompletion = ((_ tappedWord:String) -> Void)
    
    // MARK: - Associated Keys
    private struct AssociatedKeys {
        static var kTapOnText = "key_tapOnText"
        static var ktapOnArrayWords = "key_tapOnArrayWords"
        static var kTappedCompletion = "key_tappedCompletion"
        static var kTappedWordCompletion = "key_tappedWordCompletion"
    }
    
    // MARK: - Associated Properties
    var tapOnText:String {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kTapOnText) as? String ?? ""
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.kTapOnText, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var tapOnArrayWords:[String] {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ktapOnArrayWords) as? [String] ?? []
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.ktapOnArrayWords, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private var tappedCompletion: DidTapTextCompletion? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kTappedCompletion) as? DidTapTextCompletion
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.kTappedCompletion, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var tappedWordCompletion: DidTapWordCompletion? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.kTappedWordCompletion) as? DidTapWordCompletion
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.kTappedWordCompletion, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: - Single makeTextTapped
    
    func makeTextTapped(_ fullString: String, tapOnText: String, foregroundColor: UIColor = .darkText, selectionColor: UIColor = .link, foregroundFont: UIFont = UIFont.systemFont(ofSize: 15), selectionFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .bold), success: @escaping DidTapTextCompletion) {
        self.tapOnText = tapOnText
        let string = fullString// tapOnText
        let range = (string as NSString).range(of: "\(tapOnText)")
        
        let attributedText = NSMutableAttributedString(string: string, attributes: [.font: foregroundFont, .foregroundColor: foregroundColor])
        attributedText.addAttribute(.foregroundColor, value: selectionColor, range: range)
        attributedText.addAttribute(.font, value: selectionFont, range: range)
        self.attributedText = attributedText
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOnText(_:)))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
        self.tappedCompletion = {
            success()
        }
        
    }
    
    @objc func tappedOnText(_ sender: UITapGestureRecognizer) {
        guard let range = self.text?.range(of: self.tapOnText) else {
            return
        }
        
        let nsRange = NSRange(range, in: self.tapOnText)
        if sender.didTapAttributedTextInTextView(textView: self, inRange: nsRange) {
            if let tappedCompletion = self.tappedCompletion {
                tappedCompletion()
            }
        }
    }
    
    // MARK: - Multiple makeTextTapped
    
    func makeWordsTapped(_ fullString: String, tapOnWords: [String], foregroundColor: UIColor = .darkText, selectionColor: UIColor = .link, foregroundFont: UIFont = UIFont.systemFont(ofSize: 15), selectionFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .bold), success: @escaping DidTapWordCompletion) {
        self.tapOnArrayWords = tapOnWords
        
        let string = fullString
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let attributedText = NSMutableAttributedString(string: string, attributes: [.paragraphStyle: style, .font: foregroundFont, .foregroundColor: foregroundColor])
        tapOnWords.forEach { (word) in
            let ranges = string.ranges(of: word)
            ranges.forEach({ (range) in
                attributedText.addAttribute(.foregroundColor, value: selectionColor , range: NSRange.init(string: string, lowerBound: range.lowerBound, upperBound: range.upperBound) )
                attributedText.addAttribute(.font, value: selectionFont, range: NSRange.init(string: string, lowerBound: range.lowerBound, upperBound: range.upperBound) )
            })
        }
        self.attributedText = attributedText
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOnWord(_:)))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
        self.tappedWordCompletion = { tappedString in
            success(tappedString)
        }
    }
    
    @objc func tappedOnWord(_ sender: UITapGestureRecognizer) {
        self.tapOnArrayWords.forEach { (word) in
            if let ranges = self.text?.ranges(of: word) {
                ranges.forEach({ (range) in
                    let nsRange = NSRange(range, in: word)
                    if sender.didTapAttributedTextInTextView(textView: self, inRange: nsRange) {
                        if let tappedWordCompletion = self.tappedWordCompletion {
                            tappedWordCompletion(word)
                        }
                    }
                }) // foreach
            }
        } // foreach
    }
}
