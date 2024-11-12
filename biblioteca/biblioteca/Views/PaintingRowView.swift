import SwiftUI

struct PaintingRowView: View {
    let painting: Painting
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: painting.imageUrl)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(painting.title)
                    .font(.headline)
                Text(painting.artist)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 5)
    }
}
