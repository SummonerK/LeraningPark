//
//  CalendarViewCell.swift
//  RxText01
//
//  Created by Luofei on 2018/8/20.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewCell: JTAppleCell {

    var isEvent: Bool = false
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var eventView: UIView!
    
    @IBOutlet weak var widthSelectedCellConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.selectedView.backgroundColor = UIColor.randomColor
        
        let widthCell: CGFloat = UIScreen.main.bounds.width / 7.0
        let heightCell: CGFloat = (UIScreen.main.bounds.height - 169.0) / 6.0
        self.widthSelectedCellConstraint.constant = widthCell > heightCell ? heightCell - 5.0 : widthCell - 5.0
        self.selectedView.layer.cornerRadius = self.widthSelectedCellConstraint.constant / 2
    }
    
    func updateContentCalendarCell(cell: JTAppleCell, cellState: CellState, isEvent: Bool) {
        
        self.isEvent = isEvent
        self.eventView.isHidden = !self.isEvent
//        self.eventView.isHidden = false
        self.dateLabel.text = cellState.text
        
        if self.isEvent {
            self.selectedView.backgroundColor = UIColor.randomColor
        }else{
            self.selectedView.backgroundColor = UIColor.clear
        }
    }
    
}
