import Foundation
import FirebaseAuth
import FirebaseFirestore


class HomeViewModel: ObservableObject {
    @Published var tasks: [TaskModel] = []
    @Published var isLoading = false
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    var uncompletedTasksCount: Int {
        tasks.filter({ !$0.isCompleted }).count
    }
    
    
    init() {
        getTasks()
    }
    

   nonisolated private func getTasks() {
        isLoading = true
        
        guard let currentUserID = auth.currentUser?.uid else { return }
        
        firestore.collection("tasks")
            .whereField("uid", isEqualTo: currentUserID)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    self.isLoading = false
                    print("Error fetching documents: \(error ?? NSError())")
                    return
                }
                
                self.tasks = documents.compactMap { snapshot in
                    do {
                        let task = try snapshot.data(as: TaskModel.self)
                        
                        self.isLoading = false
                        
                        return task
                    } catch {
                        self.isLoading = false
                        print("Error decoding task: \(error)")
                        return nil
                    }
                }
                self.isLoading = false
            }
    }
    
    
    @MainActor
    func addTask(taskText: String) async throws {
        isLoading = true
        
        let taskId = UUID().uuidString
        
        let task = TaskModel(
            uid: auth.currentUser?.uid ?? "",
            taskId: taskId,
            taskText: taskText,
            createdAt: .now,
            isCompleted: false
        )
        
        try firestore.collection("tasks").document(taskId).setData(from: task)
        
        isLoading = false
    }
    
    func deleteTask(taskId: String) async throws {
        try await firestore.collection("tasks").document(taskId).delete()
    }
    
    func markAsCompleted(taskId: String, isCompleted: Bool) async throws {
        try await firestore.collection("tasks").document(taskId).updateData([
            "isCompleted": isCompleted,
        ])
    }
    
    @MainActor
    func editTask(taskId: String, taskText: String) async throws {
        isLoading = true
        
        try await firestore.collection("tasks").document(taskId).updateData([
            "taskText": taskText
        ])
        
        isLoading = false
    }
}
