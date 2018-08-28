//
//  JatCalendarVC.swift
//  RxText01
//
//  Created by Luofei on 2018/8/20.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import JTAppleCalendar

class JatCalendarVC: UIViewController {

    let cellIdentifier = "CalendarViewCell"
    let formatter = DateFormatter()
    
    var isCalendarOneRow: Bool = false
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendarView.register(UINib(nibName: "CalendarViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.setupCalendarView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCalendarView() {
        self.calendarView.minimumLineSpacing = 0.0
        self.calendarView.minimumInteritemSpacing = 0.0
        
        self.calendarView.scrollDirection = .horizontal
        
        self.calendarView.calendarDelegate = self
        self.calendarView.calendarDataSource = self
        
        self.calendarView.visibleDates { visibleDates in
            self.setupViewOfCalendar(from: visibleDates)
        }
    }
    
    func setupViewOfCalendar(from visibleDates: DateSegmentInfo ) {
        if let day = visibleDates.monthDates.first {
            let date = day.date
            formatter.dateFormat = "MMM YYYY"
            self.monthLabel.text = formatter.string(from: date)
        }
    }
    
    func handleCellSelected(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarViewCell else { return }
        validCell.selectedView.isHidden = !validCell.isSelected
        
//        if validCell.isSelected {
//            validCell.selectedView.backgroundColor = UIColor.blue
//        }else{
//            validCell.selectedView.backgroundColor = UIColor.clear
//        }
        
    }
    
    func handleCellTextColor(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarViewCell else { return }
    }
    
    // MARK: - Action
    
    @IBAction func previousMonthButtonAction(_ sender: Any) {
        self.calendarView.scrollToSegment(.previous)
    }
    
    @IBAction func nextMonthButtonAction(_ sender: Any) {
        self.calendarView.scrollToSegment(.next)
    }
    
}

extension JatCalendarVC: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    
    // MARK: - Calendar datasource
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CalendarViewCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: CalendarDate.startDate)
        let endDate = formatter.date(from: CalendarDate.endDate)
        // One row or 6 rows
        if self.isCalendarOneRow {
            let parameters = ConfigurationParameters(startDate: startDate!,
                                                     endDate: endDate!,
                                                     numberOfRows: 1,
                                                     generateInDates: .forFirstMonthOnly,
                                                     generateOutDates: .off,
                                                     hasStrictBoundaries: false)
            return parameters
        } else {
            let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
            return parameters
        }
    }
    
    // MARK: - Calendar delegate
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
//        (cell as! CalendarViewCell).updateContentCalendarCell(cell: cell, cellState: cellState, isEvent: false)
//        print("date = \(date)===selectedDate = \(calendarView.selectedDate)")
        let isSelected = (date == calendarView.selectedDate)
        
        if isSelected {
            print("calendarView.selectedDate \(calendarView.selectedDate?.string_from(formatter: "yyyy MM dd"))")
        }
        
        (cell as! CalendarViewCell).updateContentCalendarCell(cell: cell, cellState: cellState, isEvent: isSelected)
        
        self.handleCellSelected(cell: cell, cellState: cellState)
        self.handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        self.handleCellSelected(cell: cell, cellState: cellState)
        self.handleCellTextColor(cell: cell, cellState: cellState)       
        
        calendarView.selectedDate = date
        
        self.calendarView.reloadData()
//        self.heightEventViewConstraint.constant = (cell as! CalendarViewCell).isEvent ? 100.0 : 0.0
//        UIView.animate(withDuration: 0.25) {
//            self.view.layoutIfNeeded()
//        }
        
//        (cell as! CalendarViewCell).updateContentCalendarCell(cell: cell!, cellState: cellState, isEvent: cellState.isSelected)
        
        
        print("didDeselectDate = \(date)")
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewOfCalendar(from: visibleDates)
    }
    
}
