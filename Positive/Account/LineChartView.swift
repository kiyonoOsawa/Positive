////
////  LineChartView.swift
////  Positive
////
////  Created by 大澤清乃 on 2022/11/13.
////
//
//import SwiftUI
//import Combine
//
//@available(iOS 16.0, *)
//struct LineChartView: View {
//    @ObservedObject var graphViewModel: GraphViewModel
//
//    var body: some View {
//        Chart(graphViewModel.chartDataEntries){item in
//            //折れ線グラフの形成
//            LineMark(x: .value("count", item.number), y: .value("positiveness", item.value))
//            //ポイントをつける
//            PointMark(x: .value("count", item.number), y: .value("positiveness", item.value))
//        }
//        .frame(width: 200,height: 120)
//        .padding()
//    }
//}
//
//@available(iOS 16.0, *)
//struct LineChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        LineChartView(graphViewModel: GraphViewModel())
//            .previewLayout(PreviewLayout.sizeThatFits)
//            .padding()
//    }
//}
