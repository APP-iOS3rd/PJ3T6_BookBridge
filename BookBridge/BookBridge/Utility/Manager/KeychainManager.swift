//
//  KeychainManager.swift
//  BookBridge
//
//  Created by 이민호 on 2/2/24.
//

import Foundation

enum KeychainError: Error {
    case itemNotFound
    case duplicateItem
    case invalidItemFormat
    case unknown(OSStatus)
}

class KeychainManager {
    static let service = Bundle.main.bundleIdentifier
    
    // MARK: - Save
    
    static func save(account: String, value: String, isForce: Bool = false) throws {
        try save(account: account, value: value.data(using: .utf8)!, isForce: isForce)
    }
    
    static func save(account: String, value: Data, isForce: Bool = false) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            kSecValueData as String: value as AnyObject,
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            if isForce {
                try update(account: account, value: value)
                return
            } else {
                throw KeychainError.duplicateItem
            }
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    // MARK: - Update
    
    static func update(account: String, value: String) throws {
        try update(account: account, value: value.data(using: .utf8)!)
    }
    
    static func update(account: String, value: Data) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            kSecValueData as String: value as AnyObject,
        ]
        
        let attributes: [String: AnyObject] = [
            kSecValueData as String: value as AnyObject
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateItem
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    // MARK: - Load
    
    static func load(account: String) throws -> String {
        try String(decoding: load(account: account), as: UTF8.self)
    }
    
    static private func load(account: String) throws -> Data {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue,
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
        guard let password = result as? Data else {
            throw KeychainError.invalidItemFormat
        }
        
        return password
    }
    
    // MARK: - Delete
    
    static func delete(account: String) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
}
