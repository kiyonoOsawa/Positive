//
//  Provider.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/10/04.
//

import WidgetKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), goals: [], configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), goals: [], configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        
        let date = Date()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: date)!
        fetchData { goal in
            let entry = SimpleEntry(date: date, goals: goal, configuration: configuration)
            print("entry: \(entry)")
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
    
    func fetchData(completion: @escaping([GoalForWidget]) -> Void){
        var goals = [GoalForWidget]()
        var filterData = [GoalForWidget]()
        guard let user = Auth.auth().currentUser else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users")
            .document(user.uid)
            .collection("goals")
            .getDocuments { QuerySnapshot, Error in
                guard let querySnapshot = QuerySnapshot else {
                    return
                }
                goals.removeAll()
                filterData.removeAll()
                for doc in querySnapshot.documents{
                    let date = doc.data()["date"] as! Timestamp
                    let goal = GoalForWidget(id: doc.documentID, date: date.dateValue(), goal: doc.data()["goal"] as! String, miniGoal: doc.data()["nowTodo"] as? String)
                    goals.append(goal)
                }
                print("goals:\(goals)")
                filterData = goals.filter { goal in
                    let deadlineDate = DateFormat.shared.dateFormat(date: goal.date)
                    let today = DateFormat.shared.dateFormat(date: Date())
                    return deadlineDate.compare(today) == .orderedSame || deadlineDate.compare(today) == .orderedDescending
                }
                filterData.shuffle()
                print("filterData: \(filterData)")
                if filterData.count > 3{
                    let upToTwo = Array(filterData.prefix(upTo: 3))
                    print("uptotwo: \(upToTwo)")
                    completion(upToTwo)
                }else{
                    completion(filterData)
                    print("filterdata: \(filterData)")
                }
            }
    }
}
