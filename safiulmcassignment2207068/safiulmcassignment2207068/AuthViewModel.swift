
import Foundation
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {

    @Published var user: User?
    @Published var errorMessage = ""

    init() {
        user = Auth.auth().currentUser
    }

    var isSignedIn: Bool {
        user != nil
    }

    func signUp(email: String, password: String) async {
        do {
            let result = try await Auth.auth()
                .createUser(withEmail: email, password: password)

            user = result.user
            errorMessage = ""

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signIn(email: String, password: String) async {
        do {
            let result = try await Auth.auth()
                .signIn(withEmail: email, password: password)

            user = result.user
            errorMessage = ""

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
            errorMessage = ""

        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
