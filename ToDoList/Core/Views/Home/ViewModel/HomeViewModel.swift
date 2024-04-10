import Foundation
import FirebaseAuth
import FirebaseFirestore


class HomeViewModel: ObservableObject {
    @Published var tasks: [TaskModel] = []
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    
    init() {
        getTasks()
    }
    
    
    private func getTasks() {
        let newTasks = [
            TaskModel(uid: "1", taskId: "1", taskText: "Task 1", createdAt: .now, isCompleted: false),
            TaskModel(uid: "2", taskId: "2", taskText: "Task 2", createdAt: .now, isCompleted: true),
            TaskModel(uid: "3", taskId: "3", taskText: "Task 3", createdAt: .now, isCompleted: false),
            TaskModel(uid: "4", taskId: "4", taskText: "Task 4", createdAt: .now, isCompleted: true),
            TaskModel(uid: "5", taskId: "5", taskText: "Task 5", createdAt: .now, isCompleted: false),
        ]
        
        tasks = newTasks
    }
}
