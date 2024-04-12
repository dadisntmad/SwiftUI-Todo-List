import SwiftUI

struct HomeView: View {
    @State private var showBottomSheet = false
    @State private var taskText = ""
    @State private var isCompleted = false
    
    @StateObject private var homeViewModel = HomeViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    
    private var isNotValid: Bool {
        taskText.isEmpty
    }
    
    var body: some View {
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
                                        // edit
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
            
            Button(action: {
                showBottomSheet.toggle()
            }, label: {
                Circle()
                    .fill(.black)
                    .frame(width: 50, height: 50)
                    .overlay(content: {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                    })
                    .padding()
            })
            .sheet(isPresented: $showBottomSheet, content: {
                VStack {
                    Capsule()
                        .fill(.gray)
                        .frame(width: 35, height: 2)
                        .padding(.bottom, 24)
                    
                    Spacer()
                    
                    TextField("Walk a dog...", text: $taskText)
                        .padding()
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .textInputAutocapitalization(.never)
                        .submitLabel(.done)
                        .padding(.bottom, 14)
                    
                    ButtonView(title: "Add Task", action: {
                        Task {
                            try await homeViewModel.addTask(taskText: taskText)
                            taskText = ""
                        }
                        
                        if !homeViewModel.isLoading {
                            showBottomSheet = false
                        }
                    },
                               fillColor: isNotValid || homeViewModel.isLoading ? .gray.opacity(0.65) : .black,
                               isLoading: homeViewModel.isLoading
                    )
                    .disabled(isNotValid || homeViewModel.isLoading)
                    
                    Spacer()
                }
                .presentationDetents([.medium])
                .padding()
            })
        }
    }
}

#Preview {
    HomeView()
}
