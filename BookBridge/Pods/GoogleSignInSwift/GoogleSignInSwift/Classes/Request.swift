//
//  Request.swift
//  GoogleSignInSwift
//
//  Created by Josh Kowarsky on 10/5/20.
//

public protocol GoogleSignInRequest {
    var baseURLString: String { get }
    var method: GoogleSignIn.HTTPMethod { get }
    var path: String { get }
    var parameters: GoogleSignIn.Parameters { get }
    var headers: GoogleSignIn.HTTPHeaders { get }
    func asURL() throws -> URL
    func asURLRequest() throws -> URLRequest
}

public extension GoogleSignIn {
    enum HTTPMethod: String {
        case get
        case post
    }

    typealias Parameters = [String: Any]
    typealias HTTPHeaders = [String: String]
}

extension GoogleSignIn {
    enum Request: GoogleSignInRequest {
        enum Error: Swift.Error {
            case createURLError
        }

        var baseURLString: String {
            switch self {
            case .auth:
                return "https://accounts.google.com/o/oauth2/v2"
            case .token, .refreshToken:
                return "https://oauth2.googleapis.com"
            case .getProfile:
                return "https://www.googleapis.com/oauth2/v2"
            }
        }

        case auth(clientId: String, scopes: [String], redirectURI: String)
        case token(code: String, clientId: String, redirectURI: String)
        case refreshToken(clientId: String, refreshToken: String)
        case getProfile(accessToken: String)

        var method: HTTPMethod {
            switch self {
            case .auth, .getProfile:
                return .get
            case .token, .refreshToken:
                return .post
            }
        }

        var path: String {
            switch self {
            case .auth:
                return "auth"
            case .token, .refreshToken:
                return "token"
            case .getProfile:
                return "userinfo"
            }
        }

        var parameters: Parameters {
            switch self {
            case .auth(let clientId, let scopes, let redirectURI):
                return [
                    "client_id": clientId,
                    "scope": scopes.joined(separator: " "),
                    "response_type": "code",
                    "redirect_uri": "\(redirectURI):code"
                ]
            case .token(let code, let clientId, let redirectURI):
                return [
                    "code": code,
                    "client_id": clientId,
                    "grant_type": "authorization_code",
                    "redirect_uri": "\(redirectURI):code"
                ]
            case .refreshToken(let clientId, let refreshToken):
                return [
                    "client_id": clientId,
                    "refresh_token": refreshToken,
                    "grant_type": "refresh_token"
                ]
            case .getProfile(let accessToken):
                return [
                    "access_token": accessToken,
                    "alt": "json"
                ]
            }
        }

        var headers: HTTPHeaders {
            return [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        }

        func asURL() throws -> URL {
            guard var components = URLComponents(string: baseURLString) else {
                throw Error.createURLError
            }
            components.path = "\(components.path)/\(path)"
            if method == .get {
                components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
            }
            guard let url = components.url else {
                throw Error.createURLError
            }

            return url
        }

        func asURLRequest() throws -> URLRequest {
            let url = try asURL()
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30.0)
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
            if method == .post {
                request.httpBody = parameters.percentEncoded()
            }
            request.httpMethod = method.rawValue.uppercased()
            return request
        }
    }
}

private extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

private extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
