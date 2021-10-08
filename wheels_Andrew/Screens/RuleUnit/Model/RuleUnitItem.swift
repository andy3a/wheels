//
//  RuleUnitItem.swift
//  wheels_Andrew
//
//  Created by Andrew on 22.07.21.
//

struct RuleUnitItem: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
