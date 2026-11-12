import Foundation

enum APIServiceError: LocalizedError {
    case invalidURL
    case networkFailure(Error)
    case invalidResponse(Int)
    case decodingError(Error)
    case missingBundledResource

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid syllabus endpoint URL."
        case .networkFailure(let error):
            return "Network request failed: \(error.localizedDescription)"
        case .invalidResponse(let statusCode):
            return "Server returned HTTP status \(statusCode)."
        case .decodingError(let error):
            return "Failed to parse syllabus data: \(error.localizedDescription)"
        case .missingBundledResource:
            return "Bundled modules.json file was not found."
        }
    }
}

protocol APIServiceProtocol {
    func fetchLearningModules(completion: @escaping (Result<[LearningModule], APIServiceError>) -> Void)
}

final class APIService: APIServiceProtocol {

    static let shared = APIService()

    private let session: URLSession
    private let remoteEndpoint = "https://raw.githubusercontent.com/apple/swift-org-website/main/syllabus/learnquest_modules.json"

    init(session: URLSession? = nil) {
        if let session = session {
            self.session = session
        } else {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 4.0
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            self.session = URLSession(configuration: config)
        }
    }

    func fetchLearningModules(completion: @escaping (Result<[LearningModule], APIServiceError>) -> Void) {
        guard let url = URL(string: remoteEndpoint) else {
            loadLocalFallback(completion: completion)
            return
        }

        let task = session.dataTask(with: url) { [weak self] data, response, _ in
            guard let self = self else { return }

            if let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode),
               let data = data {
                do {
                    let decoded = try JSONDecoder().decode(SyllabusResponse.self, from: data)
                    LocalStorageService.shared.saveCachedModules(decoded.modules)
                    DispatchQueue.main.async {
                        completion(.success(decoded.modules))
                    }
                    return
                } catch {
                    // Fall back to bundled syllabus
                }
            }

            self.loadLocalFallback(completion: completion)
        }
        task.resume()
    }

    func loadLocalFallback(completion: @escaping (Result<[LearningModule], APIServiceError>) -> Void) {
        if let bundleURL = Bundle.main.url(forResource: "modules", withExtension: "json") {
            do {
                let data = try Data(contentsOf: bundleURL)
                let decoded = try JSONDecoder().decode(SyllabusResponse.self, from: data)
                LocalStorageService.shared.saveCachedModules(decoded.modules)
                DispatchQueue.main.async {
                    completion(.success(decoded.modules))
                }
                return
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(error)))
                }
                return
            }
        }

        if let cached = LocalStorageService.shared.loadCachedModules() {
            DispatchQueue.main.async {
                completion(.success(cached))
            }
            return
        }

        DispatchQueue.main.async {
            completion(.failure(.missingBundledResource))
        }
    }
}
