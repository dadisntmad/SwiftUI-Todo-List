import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var signUpError: String?
    @Published var signInError: String?
    @Published var isAuthenticated = false
    
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    
    init() {
        checkAuthentication()
    }
    
    @MainActor
    func signUp(email: String, password: String) async throws {
        
        isLoading = true
        
        do {
            
            try await auth.createUser(withEmail: email, password: password)
            
            let newUser = UserModel(uid: auth.currentUser?.uid ?? "", email: email)
            
            try firestore.collection("users").document(newUser.uid).setData(from: newUser)
            
            isAuthenticated = true
            signUpError = nil
            isLoading = false
            
        } catch (let error) {
            isLoading = false
            
            let e = error as NSError
            
            switch e.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                signUpError = "Email already in use."
            case AuthErrorCode.weakPassword.rawValue:
                signUpError = "Weak password."
            default:
                signUpError = e.localizedDescription
            }
        }
    }
    
    @MainActor
    func signIn(email: String, password: String) async throws {
        isLoading = true
        
        do {
            try await auth.signIn(withEmail: email, password: password)
            
            isAuthenticated = true
            signInError = nil
            isLoading = false
            
        } catch (let error) {
            
            isLoading = false
            
            let e = error as NSError
            
            switch e.code {
            case AuthErrorCode.invalidEmail.rawValue, AuthErrorCode.wrongPassword.rawValue:
                signInError = "Invalid email or password. Please try again."
            default:
                signInError = e.localizedDescription
            }
        }
    }
    
    @MainActor
    func signOut() {
        isLoading = true
        
        do {
            try auth.signOut()
            isAuthenticated = false
            isLoading = false
        } catch (let error) {
            isLoading = false
            
            print("Sign Out Error: \(error.localizedDescription)")
        }
    }
    
    private func checkAuthentication() {
        let res = auth.currentUser?.uid != nil
        
        isAuthenticated = res
    }
}

