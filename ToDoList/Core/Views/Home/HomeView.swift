import SwiftUI

struct HomeView: View {
    @State private var isCompleted = false
    @State private var showSheet = false
    @State private var taskText = ""
    
    @StateObject private var homeViewModel = HomeViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    private var isNotValid: Bool {
        taskText.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Todos")
                                .font(.title)
                                .bold()
                            
                            if homeViewModel.uncompletedTasksCount > 0 {
                                Text("Uncompleted: \(homeViewModel.uncompletedTasksCount)")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
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
                    
                    if homeViewModel.isLoading {
                        VStack {
                            Spacer()
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                    } else if homeViewModel.tasks.isEmpty {
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
                                        .tint(.red)
                                        
                                        Button {
                                            showSheet.toggle()
                                            taskText = task.taskText
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
                            .sheet(isPresented: $showSheet, content: {
                                VStack {
                                    Capsule()
                                        .fill(.gray.opacity(0.5))
                                        .frame(width: 30, height: 1.5)
                                    
                                    Spacer()
                                    
                                    TextField("Update or write a new task...", text: $taskText)
                                        .padding()
                                        .frame(height: 50)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.gray.opacity(0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .textInputAutocapitalization(.never)
                                        .submitLabel(.done)
                                        .padding(.bottom, 14)
                                    
                                    ButtonView(title: "Save", action: {
                                        Task {
                                            try await homeViewModel.editTask(taskId: task.id, taskText: taskText)
                                            taskText = ""
                                        }
                                        
                                        if !homeViewModel.isLoading {
                                            showSheet = false
                                        }
                                    },
                                               fillColor: isNotValid || homeViewModel.isLoading ? .gray.opacity(0.65) : .black,
                                               isLoading: homeViewModel.isLoading
                                    )
                                    .disabled(isNotValid || homeViewModel.isLoading)
                                    
                                    Spacer()
                                    
                                }
                                .padding()
                                .presentationDetents([.medium])
                            })
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
