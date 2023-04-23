//
//  Provider.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/10/04.
//

import WidgetKit
import Firebase
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
            let db = Firestore.firestore()
            var goals = [GoalForWidget]()
            var filterData = [GoalForWidget]()
        let user = Auth.auth().currentUser
        guard let user = user else {
//            guard let user = Auth.auth().currentUser else {
//                Auth.auth().signIn(withEmail: "nonuser@gmail.com", password: "nonuser") { AuthDataResult, Error in
//                    guard let result = AuthDataResult else {return}
//                    db.collection("users")
//                        .document(result.user.uid)
//                        .collection("goals")
//                        .document("nonuser")
//                        .getDocument { DocumentSnapshot, Error in
//                            guard let document = DocumentSnapshot?.data() else {return}
                            let dummyData: GoalForWidget = GoalForWidget(id: "dummy", date: Date(), goal: "目標を追加していく", miniGoal: "")
                            goals.append(dummyData)
                            completion(goals)
//                        }
//                }
                return
            }
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
                    filterData = goals.filter { goal in
                        let deadlineDate = DateFormat.shared.dateFormat(date: goal.date)
                        let today = DateFormat.shared.dateFormat(date: Date())
                        return deadlineDate.compare(today) == .orderedSame || deadlineDate.compare(today) == .orderedDescending
                    }
                    filterData.shuffle()
                    if filterData.count > 3{
                        let upToTwo = Array(filterData.prefix(upTo: 3))
                        completion(upToTwo)
                    }else{
                        completion(filterData)
                    }
                }
        }
}
