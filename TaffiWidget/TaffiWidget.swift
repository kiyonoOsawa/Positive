import WidgetKit
import SwiftUI
import Intents
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

struct GoalForWidget: Identifiable{
    let id: String
    let date: Date
    let goal: String
    let miniGoal: String?
}

struct TuffyWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
            VStack(alignment: .leading, spacing:8) {
                HStack{
                Image("step_fire")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 35, height: 35, alignment: .leading)
                        .edgesIgnoringSafeArea(.all)
                        .padding(.init(top: 15, leading: 10, bottom: 5, trailing: 10))
                        
                Text("今の目標")
                        .padding(.init(top: 15, leading: 0, bottom: 5, trailing: 0))
                        .font(.custom("Hiragino Sans", size: 16))
                }
                
                ForEach(entry.goals){goal in
                    HStack {
                        Circle()
                            .stroke(lineWidth: 1)
                            .frame(width: 5, height: 5)
                        Text(goal.goal)
                    }
                    .padding(.horizontal)
                    .font(.custom("Hiragino Sans", size: 13))
                    Divider()
                }
                Spacer()
            }
    }
}

@main
struct TuffyWidget: Widget {
    init(){
        FirebaseApp.configure()
        try? Auth.auth().useUserAccessGroup("7Y5RBD24LU.com.kiyono.Positive")
    }
    let kind: String = "TuffyWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TuffyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("今日の目標")
        .description("今日の目標を確認できます")
        .supportedFamilies([.systemMedium])
    }
}

struct TuffyWidget_Previews: PreviewProvider {
    static var previews: some View {
        TuffyWidgetEntryView(entry: SimpleEntry(date: Date(), goals:[
            GoalForWidget(id: "1", date: Date(), goal: "sampleA", miniGoal: "miniSample"),
            GoalForWidget(id: "2", date: Date(), goal: "sampleB", miniGoal: "miniSample"),
            GoalForWidget(id: "3", date: Date(), goal: "sampleB", miniGoal: "miniSample")
        ] , configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
