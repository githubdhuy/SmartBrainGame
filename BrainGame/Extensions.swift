//
//  Extensions.swift
//  BrainGame
//
//  Created by Nguyễn Đức Huy on 8/13/18.
//  Copyright © 2018 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
extension UIButton {
    func roundedButton() {
        self.layer.cornerRadius = self.frame.height / 2
    }
}

extension UIView {
    func addConstraints(withFormat format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            viewsDictionary["v\(index)"] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    func appearAndFadeAway() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
            })
        }
    }
    func fallDownAndFadeAway() {
        UIView.animate(withDuration: 0.6, animations: {
            self.transform = self.transform.translatedBy(x: 0, y: 30)
        }) { (_) in
            UIView.animate(withDuration: 0.6, animations: {
                self.alpha = 0
            })
        }
    }
}
extension UInt32 {
    static func random(from: UInt32, to: UInt32) -> UInt32 {
        return arc4random_uniform(to - from + 1) + from
    }
}

extension Bool {
    static func random() -> Bool {
        if arc4random_uniform(2) == 0 { return true }
        return false
    }
}

extension Array {
    func randomElement() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}

