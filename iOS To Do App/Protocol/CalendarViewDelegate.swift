//
//  CalendarViewDelegate.swift
//  iOS To Do App
//
//  Created by Mert Şafaktepe on 10.05.2022.
//

import Foundation


protocol CalanderViewDelegate: class {
    func calendarViewDidSelecDate(date: Date)
    func calendarViewDidTapRemoveButton()
}
