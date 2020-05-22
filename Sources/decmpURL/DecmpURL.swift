import Foundation

public struct DecmpURL {
    let url: URL
    public init(url: URL) {
        self.url = url
    }
    
    public func decompress(completion: @escaping (Result<URL, Error>) -> Void) {
        var request = URLRequest(url: self.url)
        request.httpMethod = "HEAD"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let res = response as? HTTPURLResponse else {
                completion(.failure(DecmpError.noHost(self.url)))
                return
            }
            guard let url = res.url else {
                completion(.failure(DecmpError.noUrl))
                return
            }
            completion(.success(url))
        }
        task.resume();
    }
}

public enum DecmpError: Error {
    case noUrl
    case noHost(URL)
    case unknown
}
