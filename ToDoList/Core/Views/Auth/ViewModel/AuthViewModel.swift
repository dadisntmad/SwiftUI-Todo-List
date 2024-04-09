import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    
    
   private let auth = Auth.auth()
   private let firestore = Firestore.firestore()
    
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
}

