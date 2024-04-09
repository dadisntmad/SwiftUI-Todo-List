import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    @MainActor
    func signUp(email: String, password: String) async throws {
        
        isLoading = true
        
        do {
            guard let user = try? await auth.createUser(withEmail: email, password: password) else { return }
            
            let newUser = UserModel(uid: user.user.uid, email: email)
            
            try firestore.collection("users").document(newUser.uid).setData(from: newUser)
            
            isLoading = false
            
        } catch (let error) {
            print("Sign Up Error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func signIn(email: String, password: String) async throws {
        isLoading = true
        
        do {
            try await auth.signIn(withEmail: email, password: password)
            
            isLoading = false
            
        } catch (let error) {
            print("Sign In Error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func signOut() {
        isLoading = true
        
        do {
            try auth.signOut()
            
            isLoading = false
        } catch (let error) {
            print("Sign Out Error: \(error.localizedDescription)")
        }
    }
}

