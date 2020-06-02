import Foundation

public struct DecmpURL {
    let url: URL
    public init(url: URL) {
        self.url = url
    }
    
    public func decompress(completion: @escaping (Result<URL, Error>) -> Void) {
        var request = URLRequest(url: self.url)
        request.httpMethod = "HEAD"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let res = response as? HTTPURLResponse else {
                completion(.failure(DecmpError.noHost(self.url)))
                return
            }
            guard let url = res.url else {
                completion(.failure(DecmpError.noUrl))
                return
            }
            switch res.statusCode {
            case 200:
                completion(.success(url))
            case 204:
                if let xredirectto = res.allHeaderFields["x-redirect-to"] as? String,
                    let xredirectURL = URL(string: xredirectto) {
                    let next = DecmpURL(url: xredirectURL)
                    next.decompress(completion: completion)
                } else {
                    fallthrough
                }
            default:
                completion(.success(url))
            }
        }
        task.resume();
    }
}

class SessionTaskDelegate: NSObject, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        print("redirect")
    }
}

public enum DecmpError: Error {
    case noUrl
    case noHost(URL)
    case unknown
}
