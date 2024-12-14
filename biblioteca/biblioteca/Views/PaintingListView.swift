import SwiftUI

struct PaintingListView: View {
    let roomId: Int? // Ahora es un Int opcional

    @State private var paintings: [Painting] = []
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false

    // Variables para la paginación
    @State private var currentPage: Int = 1
    @State private var totalPages: Int = 1
    @State private var isLoadingPage: Bool = false

    private let pageSize: Int = 10 // Tamaño de página fijo en 10

    var body: some View {
        NavigationView {
            Group {
                if isLoading && paintings.isEmpty {
                    // Mostrar ProgressView solo si está cargando la primera página
                    ProgressView("Loading Paintings...")
                        .scaleEffect(1.5, anchor: .center)
                } else {
                    List {
                        ForEach(paintings) { painting in
                            NavigationLink(destination: PaintingDetailView(paintingId: painting.id)) {
                                PaintingRowView(painting: painting)
                                    .onAppear {
                                        // Detectar cuando la última pintura aparece para cargar la siguiente página
                                        if painting.id == paintings.last?.id {
                                            loadNextPageIfNeeded()
                                        }
                                    }
                            }
                        }

                        // Mostrar ProgressView al cargar más páginas
                        if isLoadingPage {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                    .navigationTitle(titleText)
                }
            }
            .onAppear {
                if paintings.isEmpty {
                    fetchPaintings(page: currentPage)
                }
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

    private var titleText: String {
        if let id = roomId, id > 0 {
            return "Paintings in gallery \(id)"
        } else {
            return "All Paintings"
        }
    }

    // Función para cargar pinturas con paginación
    func fetchPaintings(page: Int) {
        guard !isLoadingPage && page <= totalPages else {
            return // Evitar múltiples cargas simultáneas o cargar más allá de las páginas disponibles
        }

        isLoadingPage = true
        let apiService = APIService()

        if let id = roomId, id > 0 {
            // Llamar a un método que filtra por roomId y página
            apiService.fetchPaintings(roomId: id, page: page, size: pageSize) { result in
                DispatchQueue.main.async {
                    handleResult(result, page: page)
                }
            }
        } else {
            // Llamar a un método que obtiene todas las pinturas con página
            apiService.fetchAllPaintings(page: page, size: pageSize) { result in
                DispatchQueue.main.async {
                    handleResult(result, page: page)
                }
            }
        }
    }

    // Función para manejar el resultado de la API
    private func handleResult(_ result: Result<PagedResponse<Painting>, Error>, page: Int) {
        switch result {
        case .success(let pagedResponse):
            self.paintings.append(contentsOf: pagedResponse.content)
            self.currentPage = pagedResponse.pageNumber + 1
            self.totalPages = pagedResponse.totalPages
        case .failure(let error):
            print("[DEBUG] Error fetching paintings: \(error)")
            showError = true
        }
        isLoadingPage = false
        isLoading = false
    }

    // Función para cargar la siguiente página si es necesario
    private func loadNextPageIfNeeded() {
        guard currentPage <= totalPages else {
            return // No hay más páginas para cargar
        }
        fetchPaintings(page: currentPage)
    }
}
