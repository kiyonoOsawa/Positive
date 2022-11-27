//
//  LineChartView.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/11/13.
//

import SwiftUI
import Charts
import Combine

@available(iOS 16.0, *)
struct LineChartView: View {
    @ObservedObject var graphViewModel: GraphViewModel
    
    var body: some View {
        Chart(graphViewModel.chartDataEntries){item in
            //折れ線グラフの形成
            LineMark(x: .value("count", item.number), y: .value("positiveness", item.value))
                .foregroundStyle(.secondary)

            //ポイントをつける
            PointMark(x: .value("count", item.number), y: .value("positiveness", item.value))
                .foregroundStyle(.secondary)
        }
        .frame(width: 240,height: 140)
        .foregroundColor(.pink)
        .padding()
    }
}

@available(iOS 16.0, *)
struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(graphViewModel: GraphViewModel())
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
    }
}
