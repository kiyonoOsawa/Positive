//
//  TaffiWidget.swift
//  TaffiWidget
//
//  Created by 大澤清乃 on 2022/10/04.
//

import WidgetKit
import SwiftUI
import Intents
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct GoalForWidget: Identifiable{
    let id: String
    let date: Date
    let goal: String
    let miniGoal: String?
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let id: String
    let goal: String
    let miniGoal: String?
}

struct TaffiWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        Text(entry.date, style: .time)
        VStack(alignment: .leading, spacing:10) {
            HStack{
                Image("step_fire")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30, alignment: .leading)
                    .padding()
                
                Text("今の目標")
                    .padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
            }
            ForEach(entry.goals){goal in
                HStack {
                    Circle()
                        .stroke(lineWidth: 2)
                        .frame(width: 10, height: 10)
                    Text(goal.goal)
                }
                .padding(.horizontal)
                Divider()
            }
            Spacer()
        }
    }
}

@main
struct TaffiWidget: Widget {
    
    init(){
        FirebaseApp.configure()
        //ここだけ書き換える。
        try? Auth.auth().useUserAccessGroup("7Y5RBD24LU.com.kiyono.Positive")
    }
    
    let kind: String = "TaffiWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TaffiWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("今日の目標")
        .description("今日の目標を確認できます")
        .supportedFamilies(([.systemMedium]))
    }
}

struct TaffiWidget_Previews: PreviewProvider {
    static var previews: some View {
        TaffiWidgetEntryView(entry: SimpleEntry(date: Date(), goals:[
            GoalForWidget(id: "1", date: Date(), goal: "sampleA", miniGoal: "miniSample"),
            GoalForWidget(id: "2", date: Date(), goal: "sampleB", miniGoal: "miniSample")
        ] , configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
//        TaffiWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
