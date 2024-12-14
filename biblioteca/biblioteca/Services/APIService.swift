import Foundation
import Security
import SwiftUI

// MARK: - APIError
enum APIError: Error {
    case invalidURL
    case noData
}

// MARK: - TrustingSessionDelegate

class TrustingSessionDelegate: NSObject, URLSessionDelegate {
    let localCertData: Data

    init(localCertData: Data) {
        self.localCertData = localCertData
        super.init()
        print("[DEBUG] TrustingSessionDelegate initialized with local certificate data of size: \(localCertData.count) bytes")
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("[DEBUG] Received authentication challenge for host: \(challenge.protectionSpace.host)")

        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            print("[DEBUG] No serverTrust found, canceling challenge")
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        // Crear el certificado SecCertificate a partir de datos DER
        guard let localCert = SecCertificateCreateWithData(nil, localCertData as CFData) else {
            print("[DEBUG] Could not create SecCertificate from localCertData.")
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        // Establecer el certificado local como el único ancla de confianza
        SecTrustSetAnchorCertificates(serverTrust, [localCert] as CFArray)
        SecTrustSetAnchorCertificatesOnly(serverTrust, true) // Solo confiar en este certificado

        var error: CFError?
        let isServerTrusted = SecTrustEvaluateWithError(serverTrust, &error)

        if isServerTrusted {
            print("[DEBUG] Certificate trusted. Using credential.")
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            if let error = error {
                print("[DEBUG] Certificate not trusted by SecTrust. Error: \(error.localizedDescription)")
            } else {
                print("[DEBUG] Certificate not trusted by SecTrust.")
            }
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}

// MARK: - PagedResponse

struct PagedResponse<T: Codable>: Codable {
    let content: [T]
    let pageNumber: Int
    let pageSize: Int
    let totalElements: Int
    let totalPages: Int
    let last: Bool
}

// MARK: - APIService

class APIService {
    let baseURL = Constants.apiBaseURL

    func fetchAllPaintings(page: Int, size: Int, completion: @escaping (Result<PagedResponse<Painting>, Error>) -> Void) {
        let urlString = "\(baseURL)/paintings?page=\(page)&size=\(size)"
        guard let url = URL(string: urlString) else {
            print("[DEBUG] Invalid URL: \(urlString)")
            completion(.failure(APIError.invalidURL))
            return
        }
        print("[DEBUG] fetchAllPaintings: URL = \(url.absoluteString)")
        performRequest(url: url, completion: completion)
    }

    func fetchPaintings(roomId: Int, page: Int, size: Int, completion: @escaping (Result<PagedResponse<Painting>, Error>) -> Void) {
        let urlString = "\(baseURL)/paintings?page=\(page)&size=\(size)&roomId=\(roomId)"
        guard let url = URL(string: urlString) else {
            print("[DEBUG] Invalid URL: \(urlString)")
            completion(.failure(APIError.invalidURL))
            return
        }
        print("[DEBUG] fetchPaintings: URL = \(url.absoluteString)")
        performRequest(url: url, completion: completion)
    }

    func fetchPaintingDetail(id: Int, completion: @escaping (Result<Painting, Error>) -> Void) {
        let urlString = "\(baseURL)/paintings/\(id)"
        guard let url = URL(string: urlString) else {
            print("[DEBUG] Invalid URL: \(urlString)")
            completion(.failure(APIError.invalidURL))
            return
        }
        print("[DEBUG] fetchPaintingDetail: URL = \(url.absoluteString)")
        performRequest(url: url, completion: completion)
    }

    private func performRequest<T: Codable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        // Carga del certificado local en formato DER
        guard let certPath = Bundle.main.path(forResource: "certificate", ofType: "der"),
              let certData = try? Data(contentsOf: URL(fileURLWithPath: certPath)) else {
            print("[DEBUG] Failed to load certificate.der from bundle")
            completion(.failure(APIError.invalidURL))
            return
        }

        print("[DEBUG] Certificate loaded from path: \(certPath), size: \(certData.count) bytes")

        let sessionDelegate = TrustingSessionDelegate(localCertData: certData)
        let session = URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: nil)

        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("[DEBUG] Request error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("[DEBUG] HTTP status code: \(httpResponse.statusCode)")
                for (key, value) in httpResponse.allHeaderFields {
                    print("[DEBUG] Response header: \(key) = \(value)")
                }
            }

            guard let data = data else {
                print("[DEBUG] No data received from server")
                completion(.failure(APIError.noData))
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("[DEBUG] Raw JSON Response: \(jsonString)")
            } else {
                print("[DEBUG] Could not decode raw response as UTF-8 string.")
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                print("[DEBUG] Decoding successful. Parsed \(T.self).")
                completion(.success(decodedData))
            } catch let decodingError {
                print("[DEBUG] Decoding error: \(decodingError)")
                completion(.failure(decodingError))
            }
        }
        print("[DEBUG] Starting network request to \(url.absoluteString)")
        task.resume()
    }
}
