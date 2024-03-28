//
//  Auth.swift
//  GoogleSignInSwift
//
//  Created by Josh Kowarsky on 10/5/20.
//

public extension GoogleSignIn {
    struct Auth: Codable {
        public enum TokenType: String, Codable {
            case Bearer
        }
        public let accessToken: String
        public let expiresAt: Date
        public let refreshToken: String?
        public let scope: String
        public let tokenType: TokenType
        public let idToken: String

        public init(accessToken: String, expiresAt: Date, refreshToken: String?, scope: String, tokenType: TokenType, idToken: String) {
            self.accessToken = accessToken
            self.expiresAt = expiresAt
            self.refreshToken = refreshToken
            self.scope = scope
            self.tokenType = tokenType
            self.idToken = idToken
        }

        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case expiresAt = "expires_in"
            case refreshToken = "refresh_token"
            case scope
            case tokenType = "token_type"
            case idToken = "id_token"
        }

        static func dateDecodingStrategy(decoder: Decoder) throws -> Date {
            let container = try decoder.singleValueContainer()
            let expiresSeconds = try container.decode(Int.self)
            return Date().addingTimeInterval(TimeInterval(expiresSeconds))
        }

        public static func +(lhs: GoogleSignIn.Auth, rhs: GoogleSignIn.Auth) -> GoogleSignIn.Auth {
            let latest = lhs.expiresAt > rhs.expiresAt ? lhs : rhs
            let older = lhs.expiresAt < rhs.expiresAt ? lhs : rhs
            if latest.refreshToken == nil {
                return Auth(
                    accessToken: latest.accessToken,
                    expiresAt: latest.expiresAt,
                    refreshToken: older.refreshToken,
                    scope: latest.scope,
                    tokenType: latest.tokenType,
                    idToken: latest.idToken
                )
            } else {
                return latest
            }
        }
    }
}
