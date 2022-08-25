//
//  AccountViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/06/15.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
//import Charts

class AccountViewController: UIViewController {
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var chartBack1: UIView!
    @IBOutlet weak var chartBack2: UIView!
    @IBOutlet weak var friendsBack: UIView!
    @IBOutlet weak var friendsCollection: UICollectionView!
//    @IBOutlet weak var lineChartView: LineChartView!
    
    let storageRef = Storage.storage().reference(forURL: "gs://positive-898d1.appspot.com")
    let user = Auth.auth().currentUser
//    let rawDataGraph: [Int] = [130, 240, 500, 550, 670, 800, 950, 1300, 1400, 1500, 1700, 2100, 2500, 3600, 4200, 4300, 4700, 4800, 5400, 5800, 5900, 6700]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsCollection.dataSource = self
        friendsCollection.delegate = self
        design()
//        chart()
    }
    
    func design() {
        backView.layer.cornerRadius = 20
        backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        chartBack1.layer.cornerRadius = 20
        chartBack1.layer.shadowColor = UIColor.black.cgColor
        chartBack1.layer.shadowOpacity = 0.25
        chartBack1.layer.shadowOffset = CGSize(width: 0, height: 0)
        chartBack1.layer.masksToBounds = false
        chartBack2.layer.cornerRadius = 20
        chartBack2.layer.shadowColor = UIColor.black.cgColor
        chartBack2.layer.shadowOpacity = 0.25
        chartBack2.layer.shadowOffset = CGSize(width: 0, height: 0)
        chartBack2.layer.masksToBounds = false
        friendsBack.layer.cornerRadius = 20
        friendsBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        friendsCollection.register(UINib(nibName: "FriendAccCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "accCell")
    }
//
//    func chart() {
//        let entries = rawDataGraph.enumerated().map { ChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
//        let dataSet = LineChartDataSet(entries: entries)
//        dataSet.lineWidth = 5
//        dataSet.drawValuesEnabled = false
//        dataSet.drawCirclesEnabled = false   //プロットの丸表示
//        dataSet.circleRadius = 2
//        dataSet.circleColors = [UIColor.gray]
//        lineChartView.data = LineChartData(dataSet: dataSet)
//        lineChartView.xAxis.labelPosition = .bottom
//        lineChartView.xAxis.labelTextColor = .systemGray
//        lineChartView.xAxis.drawGridLinesEnabled = false
//        lineChartView.xAxis.drawAxisLineEnabled = false
//        lineChartView.rightAxis.enabled = false
//        lineChartView.leftAxis.axisMinimum = 0.0
//        lineChartView.leftAxis.axisMaximum = 100.0
//        lineChartView.leftAxis.drawZeroLineEnabled = true
//        lineChartView.leftAxis.zeroLineColor = .systemGray
//        let limitLine = ChartLimitLine(limit: 7200, label: "AAAAAA")
//        limitLine.lineColor = .darkGray
//        limitLine.valueTextColor = .darkGray
//        lineChartView.leftAxis.addLimitLine(limitLine)
//        let limitLineX = ChartLimitLine(limit: 3, label: "BBBBB")
//        limitLineX.lineColor = .darkGray
//        limitLineX.valueTextColor = .darkGray
//        lineChartView.xAxis.addLimitLine(limitLineX)
//        lineChartView.leftAxis.labelCount = 5
//        lineChartView.leftAxis.labelTextColor = .systemGray
//        lineChartView.leftAxis.gridColor = .systemGray
//        lineChartView.leftAxis.drawAxisLineEnabled = false
//        lineChartView.legend.enabled = false
//        lineChartView.highlightPerTapEnabled = false
//        lineChartView.pinchZoomEnabled = false
//        lineChartView.doubleTapToZoomEnabled = false
//        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.3, easingOption: .easeInCubic)
//
//    }
}

extension AccountViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
//    func collection
}
