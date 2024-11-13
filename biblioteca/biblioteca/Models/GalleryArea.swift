import Foundation
import SwiftUI

struct GalleryArea: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let rect: CGRect
    let fill: Bool
    let fillColor: Color
}
