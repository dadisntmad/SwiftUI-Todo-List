import SwiftUI

struct AddTaskView: View {
    @State private var taskText = ""
    
    @StateObject var homeViewModel = HomeViewModel()
    @Environment(\.dismiss) private var dismiss
    
    private var isNotValid: Bool {
        taskText.isEmpty
    }
    
    var body: some View {
        VStack {
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
                    dismiss()
                }
            },
                       fillColor: isNotValid || homeViewModel.isLoading ? .gray.opacity(0.65) : .black,
                       isLoading: homeViewModel.isLoading
            )
            .disabled(isNotValid || homeViewModel.isLoading)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AddTaskView()
}
