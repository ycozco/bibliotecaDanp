import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userSession: UserSession
   
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome, \(userSession.username)!")
                    .font(.largeTitle)
                    .padding()

                Image("centro_unsa")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
               
                Text("Explora el arte de nuestra casa Agustina")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
               
                Spacer()
               
                Button(action: {
                    userSession.logout()
                }) {
                    Text("Logout")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(5.0)
                }
                .padding()
            }
            .padding()
            // Aqui NO uses navigationBarHidden(true) si quieres mostrar la barra
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Acción para el ícono izquierdo
                    }) {
                        Image(systemName: "house") // Cambia el icono a tu gusto
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Acción para el ícono derecho
                    }) {
                        Image(systemName: "person.crop.circle") // Cambia el icono a tu gusto
                    }
                }
            }
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}
