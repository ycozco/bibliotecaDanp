import SwiftUI

struct RoomView: View {
    let area: GalleryArea
    @Binding var selectedRoom: GalleryArea?
    
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .border(Color.blue, width: 2)
            .frame(width: area.rect.width, height: area.rect.height)
            .position(x: area.rect.midX, y: area.rect.midY)
            .onTapGesture {
                selectedRoom = area
            }
            .overlay(
                Text(area.label)
                    .foregroundColor(.black)
                    .position(x: area.rect.midX, y: area.rect.midY)
            )
    }
}
