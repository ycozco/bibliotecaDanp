import Foundation

struct Painting: Identifiable, Codable {
    let id: Int
    let painting: String
    let artist: String
    let yearOfPainting: String
    let adjustedPrice: String
    let originalPrice: String
    let dateOfSale: String
    let yearOfSale: Int
    let seller: String
    let buyer: String?
    let auctionHouse: String
    let image: String
    let paintingWikipediaProfile: String?
    let artistWikipediaProfile: String?
    let description: String?
    let room: Int
}
