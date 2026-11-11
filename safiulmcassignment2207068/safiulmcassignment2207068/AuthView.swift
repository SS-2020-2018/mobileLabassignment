
import SwiftUI

struct AuthView: View {

    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var email = ""
    @State private var password = ""

    var body: some View {

        VStack(spacing: 20) {

            Text("Firebase Notes")
                .font(.largeTitle)
                .bold()

            TextField("Email Address", text: $email)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            if !authViewModel.errorMessage.isEmpty {
                Text(authViewModel.errorMessage)
                    .foregroundColor(.red)
            }

            Button("Sign In") {
                Task {
                    await authViewModel.signIn(
                        email: email,
                        password: password
                    )
                }
            }
            .buttonStyle(.borderedProminent)

            Button("Create Account") {
                Task {
                    await authViewModel.signUp(
                        email: email,
                        password: password
                    )
                }
            }
            .buttonStyle(.bordered)

        }
        .padding()
    }
}
