import Foundation
import FirebaseAuth
import FirebaseFirestore


class HomeViewModel: ObservableObject {
    @Published var tasks: [TaskModel] = []
    @Published var isLoading = false
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    
    init() {
        getTasks()
    }
    
    private func getTasks() {
        guard let currentUserID = auth.currentUser?.uid else { return }
        
        firestore.collection("tasks")
            .whereField("uid", isEqualTo: currentUserID)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error ?? NSError())")
                    return
                }
                
                self.tasks = documents.compactMap { snapshot in
                    do {
                        let task = try snapshot.data(as: TaskModel.self)
                        return task
                    } catch {
                        print("Error decoding task: \(error)")
                        return nil
                    }
                }
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
}
