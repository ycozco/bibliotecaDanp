import Foundation
import SwiftUI

struct MapView: View {
    @State private var selectedRoom: GalleryArea?
    private let galleryAreas: [GalleryArea]
   
    init() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        self.galleryAreas = [
            // Definición de todas las áreas de la galería
            GalleryArea(
                label: "Gallery I",
                rect: CGRect(x: 0.34 * screenWidth, y: 0, width: 0.66 * screenWidth, height: 0.18 * screenHeight),
                fill: false,
                fillColor: Color.clear
            ),
            GalleryArea(
                label: "Gallery II",
                rect: CGRect(x: 0.70 * screenWidth, y: 0.18 * screenHeight, width: 0.30 * screenWidth, height: 0.34 * screenHeight),
                fill: false,
                fillColor: Color.clear
            ),
            GalleryArea(
                label: "Gallery III",
                rect: CGRect(x: 0.36 * screenWidth, y: 0.42 * screenHeight, width: 0.34 * screenWidth, height: 0.10 * screenHeight),
                fill: false,
                fillColor: Color.clear
            ),
            GalleryArea(
                label: "Sala",
                rect: CGRect(x: 0.36 * screenWidth, y: 0.68 * screenHeight, width: 0.34 * screenWidth, height: 0.10 * screenHeight),
                fill: false,
                fillColor: Color.clear
            ),
            GalleryArea(
                label: "Gallery IV",
                rect: CGRect(x: 0.0 * screenWidth, y: 0.0 * screenHeight, width: 0.26 * screenWidth, height: 0.30 * screenHeight),
                fill: false,
                fillColor: Color.clear
            ),
            GalleryArea(
                label: "Gallery V",
                rect: CGRect(x: 0.0 * screenWidth, y: 0.30 * screenHeight, width: 0.26 * screenWidth, height: 0.22 * screenHeight),
                fill: false,
                fillColor: Color.clear
            ),
            GalleryArea(
                label: "Gallery VI",
                rect: CGRect(x: 0.70 * screenWidth, y: 0.52 * screenHeight, width: 0.30 * screenWidth, height: 0.26 * screenHeight),
                fill: false,
                fillColor: Color.clear
            ),
            GalleryArea(
                label: "Vacio",
                rect: CGRect(x: 0.0 * screenWidth, y: 0.52 * screenHeight, width: 0.26 * screenWidth, height: 0.26 * screenHeight),
                fill: false,
                fillColor: Color.red.opacity(0.5) // Color personalizado para esta área
            ),
            GalleryArea(
                label: "SS.HH",
                rect: CGRect(x: 0.0 * screenWidth, y: 0.78 * screenHeight, width: 0.24 * screenWidth, height: 0.07 * screenHeight),
                fill: true,
                fillColor: Color.cyan // Color personalizado para esta área
            )
        ]
    }
   
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            ForEach(galleryAreas) { area in
                RoomView(area: area, selectedRoom: $selectedRoom)
            }
        }
        .sheet(item: $selectedRoom) { room in
            PaintingListView(roomName: room.label)
        }
    }
}
