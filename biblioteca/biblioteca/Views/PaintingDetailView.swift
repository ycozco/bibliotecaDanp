import SwiftUI
import AVFoundation

struct PaintingDetailView: View {
    let paintingId: Int
    @State private var painting: Painting?
    @State private var isLoading: Bool = true
    @State private var showError: Bool = false

    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying: Bool = false

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading Painting...")
                    .scaleEffect(1.5, anchor: .center)
            } else if let painting = painting {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        AsyncImage(url: URL(string: painting.image)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(12)
                            case .failure(_):
                                Image("default")
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(12)
                            case .empty:
                                ProgressView()
                                    .frame(height: 200)
                            @unknown default:
                                Image("default")
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(12)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 16)

                        VStack(alignment: .leading, spacing: 8) {
                            Text(painting.painting)
                                .font(.largeTitle)
                                .bold()

                            Text("Artist: \(painting.artist)")
                                .font(.title2)

                            Text("Year of Painting: \(painting.yearOfPainting)")
                            Text("Adjusted Price: \(painting.adjustedPrice)")
                            Text("Original Price: \(painting.originalPrice)")
                            Text("Date of Sale: \(painting.dateOfSale)")
                            Text("Year of Sale: \(painting.yearOfSale)")
                            Text("Seller: \(painting.seller)")
                            if let buyer = painting.buyer, !buyer.isEmpty {
                                Text("Buyer: \(buyer)")
                            }
                            Text("Auction House: \(painting.auctionHouse)")
                            if let description = painting.description, !description.isEmpty {
                                Text("Description: \(description)")
                            }
                            Text("Room: \(painting.room)")
                        }
                        .padding(.horizontal)

                        // Controles de audio
                        HStack(spacing: 20) {
                            Button(action: playAudio) {
                                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.blue)
                            }
                            Button(action: stopAudio) {
                                Image(systemName: "stop.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.top, 16)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding()
                }
            } else {
                Text("Painting not found.")
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Painting Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchPaintingDetail()
            setupAudio()
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Error"),
                message: Text("Failed to load painting details."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    func fetchPaintingDetail() {
        let apiService = APIService()
        apiService.fetchPaintingDetail(id: paintingId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let painting):
                    self.painting = painting
                case .failure(let error):
                    print("[DEBUG] Error fetching painting detail: \(error)")
                    showError = true
                }
                isLoading = false
            }
        }
    }

    func setupAudio() {
        guard let asset = NSDataAsset(name: "diana_and_callisto") else {
            print("[DEBUG] Audio asset not found.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(data: asset.data)
            audioPlayer?.prepareToPlay()
        } catch {
            print("[DEBUG] Error initializing audio player: \(error)")
        }
    }

    func playAudio() {
        if isPlaying {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
        isPlaying.toggle()
    }

    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPlaying = false
    }
}
