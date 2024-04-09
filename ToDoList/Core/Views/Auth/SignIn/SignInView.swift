import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    private var isValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    private var fillColor: Color {
        isValid ? Color.black : Color.gray.opacity(0.55)
    }
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 24) {
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Sign In")
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
                    
                    if let error = authViewModel.signInError {
                        ErrorView(error: error)
                    }
                    
                    ButtonView(title: "Sign In", action: {
                        Task {
                            try await authViewModel.signIn(email: email, password: password)
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
                    Text("Don't have an account?")
                        .font(.footnote)
                    
                    NavigationLink("Sign Up") {
                        SignUpView()
                    }
                    .font(.footnote)
                    .bold()
                }
            }
        }
        .tint(Color.black)
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthViewModel())
}
