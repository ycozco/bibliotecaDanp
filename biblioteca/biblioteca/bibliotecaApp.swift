import SwiftUI

@main
struct bibliotecaApp: App {
    @StateObject private var userSession = UserSession() //
    var body: some Scene {
        WindowGroup {
            Group {
                if userSession.isAuthenticated {
                    HomeView() //
                        .environmentObject(userSession)
                } else {
                    LoginView() //
                        .environmentObject(userSession)
                }
            }
        }
    }
}
