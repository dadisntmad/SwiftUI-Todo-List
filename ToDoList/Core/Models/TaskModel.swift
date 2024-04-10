import Foundation

struct TaskModel: Identifiable, Codable {
    let uid: String
    let taskId: String
    let taskText: String
    let createdAt: Date
    let isCompleted: Bool
    
    var id: String {
        taskId
    }
}
