import Foundation
import SwiftUI

struct GalleryArea: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let rect: CGRect
    let fill: Bool
    let fillColor: Color

    static func == (lhs: GalleryArea, rhs: GalleryArea) -> Bool {
        return lhs.id == rhs.id &&
               lhs.label == rhs.label &&
               lhs.rect == rhs.rect &&
               lhs.fill == rhs.fill
        // fillColor no se compara porque Color no es Equatable
    }
}
