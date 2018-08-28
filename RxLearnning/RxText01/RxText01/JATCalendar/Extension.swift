//
//  Extension.swift
//  CalendarDemo
//
//  Created by Anh Mai on 10/23/17.
//  Copyright © 2017 Anh Mai. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func underlineButton(text: String) {
        let titleString = NSMutableAttributedString(string: text)
        let firstAttributes = [NSForegroundColorAttributeName:UIColor.blue,NSStrikethroughColorAttributeName: UIColor.blue, NSStrikethroughStyleAttributeName:1,NSStrokeColorAttributeName:UIColor.blue] as [String : Any]
        titleString.addAttributes(firstAttributes, range: NSMakeRange(0, text.characters.count))
        self.setAttributedTitle(titleString, for: .normal)
    }
    
    func removeUnderlineButton(text: String) {
        let titleString = NSMutableAttributedString(string: text)
        let firstAttributes = [NSForegroundColorAttributeName:UIColor.blue,NSStrikethroughColorAttributeName: UIColor.blue, NSStrikethroughStyleAttributeName:0,NSStrokeColorAttributeName:UIColor.blue] as [String : Any]
        titleString.addAttributes(firstAttributes, range: NSMakeRange(0, text.characters.count))
        self.setAttributedTitle(titleString, for: .normal)
    }
}
