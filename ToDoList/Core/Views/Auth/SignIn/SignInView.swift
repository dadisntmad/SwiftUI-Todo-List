import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    
    
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
                        .padding()
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(alignment: .trailing) {
                            Image(systemName: isSecure ? "eye" : "eye.slash")
                                .foregroundStyle(isSecure ? Color.gray : Color.black)
                                .padding(.trailing, 16)
                                .onTapGesture {
                                    withAnimation {
                                        isSecure.toggle()
                                    }
                                }
                        }
                        .textInputAutocapitalization(.never)
                } else {
                    TextField("Password", text: $password)
                        .padding()
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(alignment: .trailing) {
                            Image(systemName: isSecure ? "eye" : "eye.slash")
                                .foregroundStyle(isSecure ? Color.gray : Color.black)
                                .padding(.trailing, 16)
                                .onTapGesture {
                                    withAnimation {
                                        isSecure.toggle()
                                    }
                                }
                        }
                        .textInputAutocapitalization(.never)
                }
                
                ButtonView(title: "Sign In", action: {
                    
                },
                           fillColor: fillColor
                )
                .disabled(!isValid)
            }
            .padding()
            
            Spacer()
            
            Divider()
            
            HStack {
                Text("Don't have an account?")
                    .font(.footnote)
                
                Text("Sign Up")
                    .font(.footnote)
                    .bold()
                    .onTapGesture {
                        
                    }
            }
        }
    }
}

#Preview {
    SignInView()
}
