import SwiftUI

struct HomeView: View {
    @State private var showBottomSheet = false
    @State private var taskText = ""
    
    @StateObject private var homeViewModel = HomeViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    
    private var isNotValid: Bool {
        taskText.isEmpty
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Todos")
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        // filter
                    }, label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundStyle(.black)
                    })
                    
                    Button(action: {
                        authViewModel.signOut()
                        
                    }, label: {
                        Image(systemName: "person.circle")
                            .foregroundStyle(.black)
                    })
                }
                .padding(.horizontal)
                
                
                List {
                    ForEach(homeViewModel.tasks) { task in
                        HStack {
                            ZStack {
                                Circle()
                                    .strokeBorder(.green, lineWidth: 1)
                                    .frame(width: 20, height: 20)
                                
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .foregroundStyle(.green)
                                    .frame(width: 10, height: 10)
                            }
                            .opacity(task.isCompleted ? 1 : 0)
                            
                            Text(task.taskText)
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
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
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
