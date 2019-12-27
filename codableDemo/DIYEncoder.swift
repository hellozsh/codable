//
//  DIYEncoder.swift
//  day191219-Codable
//
//  Created by suhua zhou on 2019/12/26.
//
  
import Foundation

fileprivate struct DIYEncodingStorage {
    
    private(set) fileprivate var containers: [NSMutableString] = []
    
    fileprivate init() {}
    
    fileprivate var count: Int {
        return self.containers.count
    }
    
    fileprivate mutating func pushKeyedContainer() -> NSMutableString {
        
        let dictionary = NSMutableString()
        self.containers.append(dictionary)
        return dictionary
    }
    
    fileprivate mutating func pushUnkeyedContainer() -> NSMutableString {
        
        let array = NSMutableString()
        self.containers.append(array)
        return array
    }
    
    // 添加一个字符串序列
    fileprivate mutating func push(container: __owned NSMutableString) {
        
        self.containers.append(container)
    }
    
    // 拿出来一个字符串序列
    fileprivate mutating func popContainer() -> NSMutableString {
        
        return self.containers.popLast() ?? ""
    }
}

// 键值容器
fileprivate struct DIYKeyContainer<K : CodingKey> : KeyedEncodingContainerProtocol {
  
    private var container: NSMutableString
    
    private let encoder: DIYEncoder
    
    var codingPath: [CodingKey]
     
    fileprivate init(encoder: DIYEncoder, codingPath:[CodingKey], container: NSMutableString) {
        
        self.encoder = encoder
        self.codingPath = codingPath
        self.container = container
    }
    
    private func append(_ str: String) {
        
        if container.length > 0 {
            container.append(",")
        }
        container.append(str)
    }
     
    mutating func encodeNil(forKey key: K) throws {
          
    }
    
    mutating func encode(_ value: Bool, forKey key: K) throws {
         
       self.append("\(key.stringValue)=\(value)")
    }
    
    mutating func encode(_ value: String, forKey key: K) throws {
 
        self.append("\(key.stringValue)=\(value)")
    }
    
    mutating func encode(_ value: Double, forKey key: K) throws {
         self.append("\(key.stringValue)=\(value)")
    }
    
    mutating func encode(_ value: Float, forKey key: K) throws {
         self.append("\(key.stringValue)=\(value)")
    }
    
    mutating func encode(_ value: Int, forKey key: K) throws {
        self.append("\(key.stringValue)=\(value)")
    }
    
    mutating func encode(_ value: Int8, forKey key: K) throws {
        self.append("\(key.stringValue)=\(value)")
    }
    
    mutating func encode(_ value: Int16, forKey key: K) throws {
         self.append("\(key.stringValue)=\(value)")
    }
    
    mutating func encode(_ value: Int32, forKey key: K) throws {
         self.append("\(key.stringValue)=\(value)")
    }
    
    mutating func encode(_ value: Int64, forKey key: K) throws {
         self.append("\(key.stringValue)=\(value)")
    }
    
    mutating func encode(_ value: UInt, forKey key: K) throws {
         self.append("\(key.stringValue)=\(value)")
    }
    
    mutating func encode(_ value: UInt8, forKey key: K) throws {
         self.append("\(key.stringValue)=\(value)")
    }
    
    mutating func encode(_ value: UInt16, forKey key: K) throws {
         self.append("\(key.stringValue)=\(value)")
    }
    
    mutating func encode(_ value: UInt32, forKey key: K) throws {
         self.append("\(key.stringValue)=\(value)")
    }
    
    mutating func encode(_ value: UInt64, forKey key: K) throws {
         self.append("\(key.stringValue)=\(value)")
    }
    
    // 如果值不是普通类型，需要对值再次编码，再次编码的话就新建一个字符串序列，用于存储这个值编码后的结果
    mutating func encode<T>(_ value: T, forKey key: K) throws where T : Encodable {
        
        var valueStr = ""
         
        self.append("\(key.stringValue)=")
        
        let depth = self.encoder.storage.count
        
        do {
            self.container = NSMutableString()
            self.encoder.storage.push(container: self.container)
            try value.encode(to: self.encoder)
            
        } catch {
            
            if self.encoder.storage.count > depth {
                let _ = self.encoder.storage.popContainer()
            }
            throw error
        }
         
        if self.encoder.storage.count > depth {
            
             valueStr = self.encoder.storage.popContainer() as String
        }
        self.container = NSMutableString.init(string: "\(self.encoder.storage.popContainer())(\(self.container))")
        self.encoder.storage.push(container: self.container)
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: K) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
         
        let containerKey = key
        let dictionary: NSMutableString
         
        dictionary = NSMutableString()
        self.container.append(dictionary as String)
        
        self.codingPath.append(key)
        defer { self.codingPath.removeLast() }

        let container = DIYKeyContainer<NestedKey>(encoder: self.encoder, codingPath: self.codingPath, container: dictionary)
        
        return KeyedEncodingContainer(container)
    }
    
    mutating func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
         
        let containerKey = key
        let dictionary: NSMutableString
         
        dictionary = NSMutableString()
        self.container.append(dictionary as String)
        
        self.codingPath.append(key)
        defer { self.codingPath.removeLast() }
        
        let container = DIYContainer(encoder: self.encoder, codingPath: self.codingPath, container: dictionary)
        
        return container
    }
    
    mutating func superEncoder() -> Encoder {
         
       return self.encoder
    }
    
    mutating func superEncoder(forKey key: K) -> Encoder {
         
        return self.encoder
    }
}

fileprivate struct DIYSingleContainer: SingleValueEncodingContainer {
    
    private let container: NSMutableString
       
    private let encoder: DIYEncoder
    
    var codingPath: [CodingKey]
    
    fileprivate init(encoder: DIYEncoder, codingPath:[CodingKey], container: NSMutableString) {
        
        self.encoder = encoder
        self.codingPath = codingPath
        self.container = container
    }
    
    mutating func encodeNil() throws {
        
    }
    
    mutating func encode(_ value: Bool) throws {
         container.append("\(value)")
    }
    
    mutating func encode(_ value: String) throws {
         container.append("\(value)")
    }
    
    mutating func encode(_ value: Double) throws {
         container.append("\(value)")
    }
    
    mutating func encode(_ value: Float) throws {
         container.append("\(value)")
    }
    
    mutating func encode(_ value: Int) throws {
         container.append("\(value)")
    }
    
    mutating func encode(_ value: Int8) throws {
         container.append("\(value)")
    }
    
    mutating func encode(_ value: Int16) throws {
         container.append("\(value)")
    }
    
    mutating func encode(_ value: Int32) throws {
         container.append("\(value)")
    }
    
    mutating func encode(_ value: Int64) throws {
         container.append("\(value)")
    }
    
    mutating func encode(_ value: UInt) throws {
         container.append("\(value)")
    }
    
    mutating func encode(_ value: UInt8) throws {
         container.append("\(value)")
    }
    
    mutating func encode(_ value: UInt16) throws {
         container.append("\(value)")
    }
    
    mutating func encode(_ value: UInt32) throws {
         container.append("\(value)")
    }
    
    mutating func encode(_ value: UInt64) throws {
         container.append("\(value)")
    }
    
    mutating func encode<T>(_ value: T) throws where T : Encodable {
         container.append("\(value)")
    }
}

fileprivate struct DIYContainer : UnkeyedEncodingContainer {
   
    var count: Int
    
    private let container: NSMutableString
    
    private let encoder: DIYEncoder
    
    var codingPath: [CodingKey]
     
    fileprivate init(encoder: DIYEncoder, codingPath:[CodingKey], container: NSMutableString) {
        
        self.encoder = encoder
        self.codingPath = codingPath
        self.container = container
        count = 0
    }
    
    mutating func encodeNil() throws {
        container.append("<nil>")
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        
        let dictionary = NSMutableString()
        self.container.append(dictionary as String)

//        let container = _JSONKeyedEncodingContainer<NestedKey>(referencing: self.encoder, codingPath: self.codingPath, wrapping: dictionary)
        let container = DIYKeyContainer<NestedKey>(encoder: self.encoder, codingPath: self.codingPath, container: dictionary)
        return KeyedEncodingContainer(container)
    }
    
    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        
        let dictionary = NSMutableString()
        self.container.append(dictionary as String)
        
        let container = DIYContainer(encoder: self.encoder, codingPath: self.codingPath, container: dictionary)
        
        return container
    }
    
    mutating func superEncoder() -> Encoder {
        
        return self.encoder
    }
    
    mutating func encode(_ value: Double) throws {
         
        container.append("\(value)")
    }
    
    mutating func encode(_ value: Float) throws {
         
        container.append("\(value)")
    }
    
    mutating func encode(_ value: Int) throws {
        container.append("\(value)")
    }
    mutating func encode(_ value: Int16) throws {
        container.append("\(value)")
    }
    
    mutating func encode(_ value: Int32) throws {
        container.append("\(value)")
    }
    
    mutating func encode(_ value: Int64) throws {
        container.append("\(value)")
    }
    
    mutating func encode(_ value: UInt) throws {
        container.append("\(value)")
    }
    
    mutating func encode(_ value: UInt8) throws {
        container.append("\(value)")
    }
    
    mutating func encode(_ value: UInt16) throws {
         container.append("\(value)")
    }
    
    mutating func encode(_ value: UInt32) throws {
         container.append("\(value)")
    }
    
    mutating func encode(_ value: UInt64) throws {
        container.append("\(value)")
    }
    
    mutating func encode<T>(_ value: T) throws where T : Encodable {
         container.append("\(value)")
    }
    
    mutating func encode(_ value: Bool) throws {
         container.append("\(value)")
    }
}
 
class DIYEncoder: Encoder {
     
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    fileprivate var storage: DIYEncodingStorage
    
    public var codingPath: [CodingKey] = []
 
    
    init(codingPath: [CodingKey] = []) {
        self.codingPath = codingPath
        self.storage = DIYEncodingStorage()
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {

        let topContainer: NSMutableString
        if self.canEncodeNewValue {
            topContainer = self.storage.pushKeyedContainer()
        } else {

            guard let container = self.storage.containers.last else {
                preconditionFailure("Attempt to push new keyed encoding container when already previously encoded at this path.")
            }
            topContainer = container
        }
        let container = DIYKeyContainer<Key>(encoder: self, codingPath: self.codingPath, container: topContainer)
        return KeyedEncodingContainer(container)
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {

        let topContainer: NSMutableString
        if self.canEncodeNewValue {
            topContainer = self.storage.pushKeyedContainer()
        } else {

            guard let container = self.storage.containers.last else {
                preconditionFailure("Attempt to push new keyed encoding container when already previously encoded at this path.")
            }
            topContainer = container
        }
        return DIYContainer(encoder: self, codingPath: self.codingPath, container: topContainer)
    }

    func singleValueContainer() -> SingleValueEncodingContainer {

        let topContainer: NSMutableString
        if self.canEncodeNewValue {
            topContainer = self.storage.pushKeyedContainer()
        } else {

            guard let container = self.storage.containers.last else {
                preconditionFailure("Attempt to push new keyed encoding container when already previously encoded at this path.")
            }
            topContainer = container
        }
        
        return DIYSingleContainer(encoder: self, codingPath: self.codingPath, container: topContainer)
    }
    
    fileprivate var canEncodeNewValue: Bool {
        
        return self.storage.count == self.codingPath.count
    }
    
    func encode<T : Encodable>(_ value: T) throws -> String {
        
        try value.encode(to: self)
        return self.storage.popContainer() as String
    }
}



