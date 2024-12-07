import SwiftUI

@main
struct bibliotecaApp: App {
    @StateObject var userSession = UserSession()
    
    var body: some Scene {
        WindowGroup {
            if userSession.isAuthenticated {
                ContentView()
                    .environmentObject(userSession)
            } else {
                LoginView()
                    .environmentObject(userSession)
            }
        }
    }
}
