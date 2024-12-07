import Foundation

class UserSession: ObservableObject {
    @Published var isAuthenticated = false
    @Published var username = ""
    
    func register(email: String, username: String, password: String) {
        // Obtiene el diccionario de usuarios almacenados
        var users = UserDefaults.standard.dictionary(forKey: "users") as? [String:String] ?? [:]
        // Registra el nuevo usuario
        users[username] = password
        UserDefaults.standard.set(users, forKey: "users")
    }

    func login(username: String, password: String) {
        let users = UserDefaults.standard.dictionary(forKey: "users") as? [String:String] ?? [:]
        if let storedPass = users[username], storedPass == password {
            self.isAuthenticated = true
            self.username = username
        } else {
            self.isAuthenticated = false
        }
    }

    func logout() {
        self.isAuthenticated = false
        self.username = ""
    }
}
