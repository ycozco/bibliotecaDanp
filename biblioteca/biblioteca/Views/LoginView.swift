import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showErrorAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Login")
                    .font(.largeTitle)
                    .padding()
                
                TextField("Username", text: $username)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                
                Button(action: {
                    userSession.login(username: username, password: password)
                    if !userSession.isAuthenticated {
                        showErrorAlert = true
                    }
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }
                .padding(.top, 20)
                .alert(isPresented: $showErrorAlert) {
                    Alert(
                        title: Text("Login Failed"),
                        message: Text("Incorrect username or password."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                NavigationLink(destination: RegisterView()) {
                    Text("Don't have an account? Register")
                        .foregroundColor(.blue)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}
