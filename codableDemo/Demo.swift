//
//  Demo.swift
//  day191219-Codable
//
//  Created by suhua zhou on 2019/12/26.
//

import Foundation

//MARK: 使用Codable
struct Coordinate: Codable {
    
    var latitude: Double
    var longitude: Double
    // 标准库的所有基本类型(bool、String等)，都实现了Codable
    // 由于所有的存储属性都是可以编解码的，所以Swift编码器会自动生成实现协议的代码
}

struct Placemark: Codable {
    
    var name: String
    var coordinate: Coordinate
    // 同理会自动生成实现代码
    
    
    // 也可以自实现
    private enum CodingKeys: String,CodingKey {
        case name
        case coordinate = "coor"
    }

    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(coordinate, forKey: .coordinate)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
    }
    init(name: String, coordinate: Coordinate) {
        
        self.name = name
        self.coordinate = coordinate
    }
}

// 使用
func JSONcode() {
    
    //实例数组
    let places = [Placemark(name: "a", coordinate: Coordinate(latitude: 1, longitude: 1)),
                  Placemark(name: "b", coordinate: Coordinate(latitude: 2, longitude: 2))]
    
    // 编码
    let encoder = JSONEncoder()
    var jsonData : Data?
    do {
        jsonData = try encoder.encode(places)  // 该方法接受一个实现了Encodable协议的实例,返回Data类型
        print("编码结果"+String(decoding: jsonData!, as: UTF8.self))
    } catch {
        print(error)
    }
    
    // 解码
    let decoder = JSONDecoder()
    do {
        let dePlaces = try decoder.decode([Placemark].self, from:jsonData!)
        print("解码结果:\(dePlaces)");
    } catch  {
        print(error)
    }
}


//MARK:

/* JSONEncoder()实例，调用encoder.encode(places) {
    
     __JSONEncoder实例，调用_encoder.box_(places) {
 
         调用 place.encode(to self)
         
     }
}
 
 */
// 实例内部会调用
  
