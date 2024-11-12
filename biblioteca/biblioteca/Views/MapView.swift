//
//  MapView.swift
//  biblioteca
//
//  Created by yoset on 22/08/1403 AP.
//

import Foundation
import SwiftUI

struct MapView: View {
    @State private var selectedRoom: GalleryArea?
    private let galleryAreas: [GalleryArea]
   
    init() {
        self.galleryAreas = [
            // Define gallery areas with appropriate CGRect values
            GalleryArea(label: "Gallery I", rect: CGRect(x: 0.34 * UIScreen.main.bounds.width, y: 0, width: 0.66 * UIScreen.main.bounds.width, height: 0.18 * UIScreen.main.bounds.height)),
            // Add other gallery areas...
        ]
    }
   
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            ForEach(galleryAreas) { area in
                RoomView(area: area, selectedRoom: $selectedRoom)
            }
        }
        .sheet(item: $selectedRoom) { room in
            PaintingListView(roomName: room.label)
        }
    }
}