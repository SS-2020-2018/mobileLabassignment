
import SwiftUI

struct ContentView: View {

    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {

        Group {

            if authViewModel.isSignedIn {
                FContentView()
            } else {
                AuthView()
            }
        }
        .environmentObject(authViewModel)
    }
}

