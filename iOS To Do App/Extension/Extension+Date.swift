//
//  Extension+Date.swift
//  iOS To Do App
//
//  Created by Mert Şafaktepe on 13.05.2022.
//

import Foundation


extension Date {
    func toString() -> String {
        let formatter =  DateFormatter()
        formatter.dateFormat = "E, MMM d, yyyy"
        //NSDateFormatter.
        return formatter.string(from: self)
    }
    
    func toDeadlineVersionString() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let today = Date()
        return formatter.localizedString(for: self, relativeTo: today)
    }
    
    func isOverDue() -> Bool {
        let today = Date()
        return self  < today
    }
    
}
