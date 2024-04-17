import SwiftUI

struct HomeView: View {
    
    @State private var isCompleted = false
    @State private var isEditMode = false
    @State private var taskId = ""
    
    @StateObject private var homeViewModel = HomeViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Todos")
                                .font(.title)
                                .bold()
                            
                            Text("Uncompleted: \(homeViewModel.uncompletedTasksCount)")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            authViewModel.signOut()
                        }, label: {
                            Image(systemName: "person.circle")
                                .foregroundStyle(.black)
                        })
                    }
                    .padding(.horizontal)
                    
                    if homeViewModel.tasks.isEmpty {
                        VStack {
                            Spacer()
                            Text("😔")
                                .font(.largeTitle)
                            
                            Text("You don't have any tasks.")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    List {
                        ForEach(homeViewModel.tasks) { task in
                            HStack {
                                ZStack {
                                    Circle()
                                        .strokeBorder(task.isCompleted ? .green : .gray, lineWidth: 1)
                                        .frame(width: 20, height: 20)
                                    
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .foregroundStyle(task.isCompleted ? .green : .gray)
                                        .frame(width: 10, height: 10)
                                }
                                
                                Text(task.taskText)
                                    .strikethrough(task.isCompleted)
                                    .frame(height: 40)
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            Task {
                                                try await homeViewModel.deleteTask(taskId: task.id)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        
                                        Button {
                                          
                                        } label: {
                                            Label("Edit", systemImage: "pencil.and.scribble")
                                            
                                        }
                                        .tint(.gray)
                                    }
                            }
                            .onTapGesture {
                                isCompleted.toggle()
                                
                                Task {
                                    try await homeViewModel.markAsCompleted(taskId: task.id, isCompleted: isCompleted)
                                }
                            }
                        }
                    }
                }
                .listStyle(.inset)
                
                NavigationLink {
                    AddTaskView()
                } label: {
                    Circle()
                        .fill(.black)
                        .frame(width: 50, height: 50)
                        .overlay(content: {
                            Image(systemName: "plus")
                                .foregroundStyle(.white)
                        })
                        .padding()
                }
            }
        }
        .tint(.black)
    }
}

#Preview {
    HomeView()
}
