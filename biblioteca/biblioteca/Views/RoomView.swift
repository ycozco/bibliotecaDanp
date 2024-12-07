import SwiftUI

struct RoomView: View {
    let area: GalleryArea
    @Binding var selectedRoom: GalleryArea?
    
    var body: some View {
        Rectangle()
            .fill(area.fillColor)
            .frame(width: area.rect.width, height: area.rect.height)
            .position(x: area.rect.midX, y: area.rect.midY)
            .onTapGesture {
                if !area.fill {
                    selectedRoom = area
                }
            }
            .overlay(
                Text(area.label)
                    .font(.caption)
                    .foregroundColor(.black)
            )
    }
}
