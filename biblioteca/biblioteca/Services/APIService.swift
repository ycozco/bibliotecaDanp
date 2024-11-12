import Foundation

class APIService {
    let baseURL = Constants.apiBaseURL
    
    func fetchPaintings(room: String, completion: @escaping (Result<[Painting], Error>) -> Void) {
        let urlString = "\(baseURL)/paintings?page=1&size=10&room=\(room.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        performRequest(url: url, completion: completion)
    }
    
    func fetchPaintingDetail(id: Int, completion: @escaping (Result<Painting, Error>) -> Void) {
        let urlString = "\(baseURL)/paintings/\(id)"
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        performRequest(url: url, completion: completion)
    }
    
    private func performRequest<T: Codable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }
        task.resume()
    }
}

enum APIError: Error {
    case invalidURL
    case noData
}
