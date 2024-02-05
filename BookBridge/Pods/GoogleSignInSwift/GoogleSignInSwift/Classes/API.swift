//
//  API.swift
//  GoogleSignInSwift
//
//  Created by Josh Kowarsky on 10/5/20.
//

public protocol GoogleSignInAPI {
    func request(_ request: GoogleSignInRequest, completion: @escaping CompletionBlock)
}

public extension GoogleSignInAPI {
    typealias CompletionBlock = (GoogleSignIn.Result) -> Void
}

public extension GoogleSignIn {
    enum Result {
        case success(data: Data)
        case error(error: Swift.Error)
    }

    struct API: GoogleSignInAPI {
        enum Error: Swift.Error {
            case networkError
            case noData
            case httpError(code: Int)
        }

        public init() {}

        public func request(_ request: GoogleSignInRequest, completion: @escaping CompletionBlock) {
            guard let urlRequest = try? request.asURLRequest() else { return }
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if error != nil {
                    completion(.error(error: Error.networkError))
                    return
                }
                guard let data = data else {
                    completion(.error(error: Error.noData))
                    return
                }
                if let response = response as? HTTPURLResponse {
                    guard (200 ... 299) ~= response.statusCode else {
                        completion(.error(error: Error.httpError(code: response.statusCode)))
                        return
                    }
                }
                completion(.success(data: data))
            }
            task.resume()
        }
    }
}
