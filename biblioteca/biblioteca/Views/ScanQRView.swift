import SwiftUI
import CodeScanner

struct ScanQRView: View {
    @State private var isPresentingScanner = false
    @State private var scannedPaintingId: Int?
    @State private var showPaintingDetail = false
    @State private var showErrorAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Button(action: {
                    isPresentingScanner = true
                }) {
                    Text("Scan QR Code")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }
                .sheet(isPresented: $isPresentingScanner) {
                    CodeScannerView(
                        codeTypes: [.qr],
                        completion: handleScan
                    )
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Scan QR")
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Invalid QR Code"),
                    message: Text("The scanned QR code is not valid."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationDestination(isPresented: $showPaintingDetail) {
                if let paintingId = scannedPaintingId {
                    PaintingDetailView(paintingId: paintingId)
                }
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isPresentingScanner = false
        
        switch result {
        case .success(let scanResult):
            if let id = Int(scanResult.string) {
                scannedPaintingId = id
                showPaintingDetail = true
            } else {
                showErrorAlert = true
            }
        case .failure(_):
            showErrorAlert = true
        }
    }
}
