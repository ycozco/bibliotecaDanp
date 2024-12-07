import SwiftUI

struct PaintingRowView: View {
    let painting: Painting
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: painting.image)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                case .failure(_):
                    Image("default") // Imagen por defecto
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 50)
                @unknown default:
                    Image("default") // Manejo de casos futuros
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                }
            }
            .padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                Text(painting.painting)
                    .font(.headline)
                Text(painting.artist)
                    .font(.subheadline)
            }
        }
    }
}
