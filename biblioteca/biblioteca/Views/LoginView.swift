import SwiftUI
extension Color {
    static let pastelPink = Color(red: 255 / 255, green: 182 / 255, blue: 193 / 255)
    static let skyBlue = Color(red: 135 / 255, green: 206 / 255, blue: 235 / 255)
    static let intenseOrange = Color(red: 255 / 255, green: 140 / 255, blue: 0 / 255)
    static let electricBlue = Color(red: 0 / 255, green: 191 / 255, blue: 255 / 255)
}
struct LoginView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showErrorAlert: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo con degradado artístico
                LinearGradient(gradient: Gradient(colors: [Color.pastelPink, Color.skyBlue]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    // Imagen artistica
                    Image("centro_unsa")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .padding(.bottom, 20)
                    
                    // Título estilizado
                    Text("Iniciar Sesión")
                        .font(.custom("PlayfairDisplay-Bold", size: 32))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .padding(.bottom, 30)
                    
                    // Campo de texto para el nombre de usuario
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                            TextField("Nombre de usuario", text: $username)
                                .autocapitalization(.none)
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                    
                    // Campo de texto seguro para la contraseña
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                            SecureField("Contraseña", text: $password)
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                    
                    // Botón de Login estilizado
                    Button(action: {
                        userSession.login(username: username, password: password)
                        if !userSession.isAuthenticated {
                            showErrorAlert = true
                        }
                    }) {
                        Text("Ingresar")
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
                    .padding(.bottom, 20)
                    .alert(isPresented: $showErrorAlert) {
                        Alert(
                            title: Text("Error de Inicio"),
                            message: Text("Nombre de usuario o contraseña incorrectos."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    
                    // Enlace de navegación a la vista de registro
                    NavigationLink(destination: RegisterView().environmentObject(userSession)) {
                        Text("¿No tienes una cuenta? Regístrate")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .underline()
                    }
                    .padding(.bottom, 40)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}
