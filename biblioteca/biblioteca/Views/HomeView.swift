import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userSession: UserSession
   
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.pastelPink, Color.skyBlue]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Text("¡Bienvenido, \(userSession.username)!")
                        .font(.custom("PlayfairDisplay-Bold", size: 28))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .padding(.bottom, 20)

                    Image("centro_unsa")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .padding(.bottom, 20)
                    
                    Text("Explora el arte de nuestra casa Agustina")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 40)
                    
                    Spacer()
                    
                    Button(action: {
                        userSession.logout()
                    }) {
                        Text("Cerrar Sesión")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.intenseOrange, Color.electricBlue]),
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            // Acción para el ícono izquierdo
                        }) {
                            Image(systemName: "house")
                                .foregroundColor(.white)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            // Acción para el ícono derecho
                        }) {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.white)
                        }
                    }
                }
                .navigationBarTitle("Inicio", displayMode: .inline)
            }
        }
    }
}
