//
//  GraphViewModel.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/11/13.
//

import Foundation
import Combine

class GraphViewModel: ObservableObject {
    @Published var chartDataEntries: [ChartDataEntry] = []
    
    func update(value: Double, number: Double) {
        let chartDataEntry = ChartDataEntry(value: value, number: number)
        chartDataEntries.append(chartDataEntry)
    }
}
