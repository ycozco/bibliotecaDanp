import SwiftUI

struct PaintingListView: View {
    let roomName: String
    @State private var paintings: [Painting] = []
    @State private var isLoading: Bool = true
    @State private var showError: Bool = false
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading Paintings...")
                } else {
                    List(paintings) { painting in
                        NavigationLink(destination: PaintingDetailView(paintingId: painting.id)) {
                            PaintingRowView(painting: painting)
                        }
                    }
                    .navigationTitle("Paintings in \(roomName)")
                }
            }
            .onAppear {
                fetchPaintings()
            }
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Error"),
                    message: Text("Failed to load paintings."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    func fetchPaintings() {
        let apiService = APIService()
        apiService.fetchPaintings(room: roomName) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let paintings):
                    self.paintings = paintings
                case .failure(_):
                    showError = true
                }
                isLoading = false
            }
        }
    }
}
