import SwiftUI

struct MapView: View {
    @State private var selectedRoom: GalleryArea?
    private let galleryAreas: [GalleryArea]

    init() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let margin: CGFloat = 10 // Margen general

        // Definición de áreas con colores únicos
        self.galleryAreas = [
            GalleryArea(
                label: "Gallery I",
                rect: CGRect.zero,
                fill: true,
                fillColor: Color.blue.opacity(0.3) // Color único
            ),
            GalleryArea(
                label: "Gallery II",
                rect: CGRect.zero,
                fill: true,
                fillColor: Color.green.opacity(0.3) // Color único
            ),
            GalleryArea(
                label: "Gallery III",
                rect: CGRect.zero,
                fill: true,
                fillColor: Color.yellow.opacity(0.3) // Color único
            ),
            GalleryArea(
                label: "Sala",
                rect: CGRect.zero,
                fill: true,
                fillColor: Color.purple.opacity(0.3) // Color único
            ),
            GalleryArea(
                label: "Gallery IV",
                rect: CGRect.zero,
                fill: true,
                fillColor: Color.orange.opacity(0.3) // Color único
            ),
            GalleryArea(
                label: "Gallery V",
                rect: CGRect.zero,
                fill: true,
                fillColor: Color.pink.opacity(0.3) // Color único
            ),
            GalleryArea(
                label: "Gallery VI",
                rect: CGRect.zero,
                fill: true,
                fillColor: Color.cyan.opacity(0.3) // Color único
            ),
            GalleryArea(
                label: "Vacio",
                rect: CGRect.zero,
                fill: true,
                fillColor: Color.red.opacity(0.5) // Color único
            ),
            GalleryArea(
                label: "SS.HH",
                rect: CGRect.zero,
                fill: true,
                fillColor: Color.gray.opacity(0.3) // Color único
            )
        ]
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)

                // Diseño de las áreas con GeometryReader
                createRoomAreas(using: geometry)
            }
            .sheet(item: $selectedRoom) { room in
                if let roomId = roomId(for: room.label) {
                    PaintingListView(roomId: roomId)
                } else {
                    Text("No paintings available for \(room.label)")
                        .font(.headline)
                        .padding()
                }
            }
        }
    }

    func createRoomAreas(using geometry: GeometryProxy) -> some View {
        let screenWidth = geometry.size.width
        let screenHeight = geometry.size.height
        let margin: CGFloat = 10 // Margen general

        return ForEach(galleryAreas.indices, id: \.self) { index in
            let area = galleryAreas[index]
            let frame = calculateFrame(for: index, screenWidth: screenWidth, screenHeight: screenHeight, margin: margin)

            ZStack {
                // Fondo del área con color y opacidad
                Rectangle()
                    .fill(area.fillColor)
                    .frame(width: frame.width, height: frame.height)
                    .border(Color.black, width: 2) // Borde del área

                // Texto centrado
                Text(area.label)
                    .foregroundColor(.black)
                    .font(.headline)
            }
            .position(x: frame.midX, y: frame.midY)
            .onTapGesture {
                selectedRoom = area
            }
        }
    }

    func calculateFrame(for index: Int, screenWidth: CGFloat, screenHeight: CGFloat, margin: CGFloat) -> CGRect {
        switch index {
        case 0: // Gallery I
            return CGRect(x: margin, y: margin, width: screenWidth - 2 * margin, height: 0.15 * screenHeight)
        case 1: // Gallery II
            return CGRect(x: screenWidth * 0.65, y: 0.18 * screenHeight, width: screenWidth * 0.3 - margin, height: 0.2 * screenHeight)
        case 2: // Gallery III
            return CGRect(x: margin, y: 0.4 * screenHeight, width: screenWidth * 0.5 - 1.5 * margin, height: 0.1 * screenHeight)
        case 3: // Sala
            return CGRect(x: screenWidth * 0.5 + margin, y: 0.4 * screenHeight, width: screenWidth * 0.5 - 1.5 * margin, height: 0.1 * screenHeight)
        case 4: // Gallery IV
            return CGRect(x: margin, y: 0.55 * screenHeight, width: screenWidth * 0.4 - margin, height: 0.12 * screenHeight)
        case 5: // Gallery V
            return CGRect(x: screenWidth * 0.6, y: 0.55 * screenHeight, width: screenWidth * 0.4 - margin, height: 0.12 * screenHeight)
        case 6: // Gallery VI
            return CGRect(x: margin, y: 0.72 * screenHeight, width: screenWidth - 2 * margin, height: 0.15 * screenHeight)
        case 7: // Vacio
            return CGRect(x: screenWidth * 0.65, y: 0.9 * screenHeight, width: screenWidth * 0.3 - margin, height: 0.07 * screenHeight)
        case 8: // SS.HH
            return CGRect(x: margin, y: 0.9 * screenHeight, width: screenWidth * 0.3 - margin, height: 0.07 * screenHeight)
        default:
            return CGRect.zero
        }
    }

    func roomId(for label: String) -> Int? {
        switch label {
        case "Gallery I": return 1
        case "Gallery II": return 2
        case "Gallery III": return 3
        case "Sala": return nil
        case "Gallery IV": return 4
        case "Gallery V": return 5
        case "Gallery VI": return 6
        case "Vacio": return nil
        case "SS.HH": return nil
        default:
            return nil
        }
    }
}
