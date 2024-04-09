import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    private var isValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    private var fillColor: Color {
        isValid ? Color.black : Color.gray.opacity(0.55)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Sign Up")
                    .font(.largeTitle)
                    .bold()
                
                TextField("Email", text: $email)
                    .padding()
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
                
                if isSecure {
                    SecureField("Password", text: $password)
                        .modifier(SecureTextFieldViewModifier(isSecure: $isSecure))
                } else {
                    TextField("Password", text: $password)
                        .modifier(SecureTextFieldViewModifier(isSecure: $isSecure))
                        
                }
                
                ButtonView(title: "Sign Up", action: {
                    Task {
                       try await authViewModel.signUp(email: email, password: password)
                    }
                },
                           fillColor: fillColor,
                           isLoading: authViewModel.isLoading
                )
                .disabled(!isValid || authViewModel.isLoading)
            }
            .padding()
            
            Spacer()
            
            Divider()
            
            HStack {
                Text("Already have an account?")
                    .font(.footnote)
                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Sign In")
                        .font(.footnote)
                        .bold()
                })
            }
        }
    }
}


#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
}
