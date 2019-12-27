//
//  main.swift
//  codableDemo
//
//  Created by suhua zhou on 2019/12/27.
//  Copyright © 2019 suhua zhou. All rights reserved.
//

import Foundation


JSONcode()


print("------------------------------")
 

struct Pet: Codable {
    
    var name : String
    var call : String
}

//MARK: 使用Codable
struct Person: Codable {
    
    var age: Int
    var name: String
    var height: Double
     
    var pet: Pet
}

let pet = Pet(name: "dog", call: "汪汪")
let per = Person(age: 2, name: "ai_pple", height: 158.6, pet: pet)

let encoder = DIYEncoder()
var str : String?
do {
    str = try encoder.encode(per)
    print("\(str ?? "")")
} catch {
    print(error)
}
