import SwiftUI

class UserSession: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var username: String = ""
    
    func login(username: String, password: String) {
        if username.lowercased() == "user" && password.lowercased() == "user" {
            self.username = username
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
    
    func logout() {
        username = ""
        isAuthenticated = false
    }
}
