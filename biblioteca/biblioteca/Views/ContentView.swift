import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userSession: UserSession
   
    var body: some View {
        TabView {
            HomeView()
                .environmentObject(userSession)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
           
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
           
            ScanQRView()
                .tabItem {
                    Label("ScanQR", systemImage: "qrcode.viewfinder")
                }

            // Ejemplo: roomId = 3 listará las pinturas de la sala con id = 3
            PaintingListView(roomId: 3)
                .tabItem {
                    Label("Painting", systemImage: "paintbrush")
                }
        }
    }
}
