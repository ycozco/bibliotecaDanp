import SwiftUI

struct PaintingDetailView: View {
    var paintingId: Int?
    @State private var painting: Painting?
    @State private var isLoading: Bool = true
    @State private var showError: Bool = false
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading Painting Details...")
            } else if let painting = painting {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(painting.title)
                            .font(.largeTitle)
                            .padding(.bottom, 5)
                        
                        Text("By \(painting.artist)")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 10)
                        
                        AsyncImage(url: URL(string: painting.imageUrl)) { image in
                            image.resizable()
                                .scaledToFit()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 10)
                        
                        Text(painting.description)
                            .font(.body)
                            .padding(.bottom, 10)
                        
                        Spacer()
                    }
                    .padding()
                }
                .navigationTitle("Painting Details")
            } else {
                Text("Failed to load painting details.")
            }
        }
        .onAppear {
            if let id = paintingId {
                fetchPaintingDetail(id: id)
            }
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Error"),
                message: Text("Failed to load painting details."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func fetchPaintingDetail(id: Int) {
        let apiService = APIService()
        apiService.fetchPaintingDetail(id: id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let painting):
                    self.painting = painting
                case .failure(_):
                    showError = true
                }
                isLoading = false
            }
        }
    }
}
