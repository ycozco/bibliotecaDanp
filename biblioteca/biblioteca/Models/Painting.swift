import Foundation

struct Painting: Identifiable, Codable {
    let id: Int
    let title: String
    let artist: String
    let description: String
    let imageUrl: String
    let room: String
}
