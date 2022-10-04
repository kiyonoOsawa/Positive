//
//  SimpleEntry.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/10/04.
//

import WidgetKit
struct SimpleEntry: TimelineEntry {
    let date: Date
    let goals: [GoalForWidget]
    let configuration: ConfigurationIntent
}
