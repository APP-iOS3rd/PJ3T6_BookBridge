//
//  User.swift
//  GoogleSignInSwift
//
//  Created by Josh Kowarsky on 10/6/20.
//

public extension GoogleSignIn {
    struct User: Codable {
        public let id: String
        public let email: String?
        public let verifiedEmail: Bool?
        public let name: String?
        public let givenName: String?
        public let familyName: String?
        public let picture: URL?
        public let locale: String?

        enum CodingKeys: String, CodingKey {
            case id
            case email
            case verifiedEmail = "verified_email"
            case name
            case givenName = "given_name"
            case familyName = "family_name"
            case picture
            case locale
        }
    }
}
