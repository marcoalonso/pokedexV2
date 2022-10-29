//
//  Pokemon.swift
//  Pokedex
//
//  Created by marco rodriguez on 22/08/22.
//

import Foundation


struct Pokemon: Codable {
    let name: String
    let attack: Int
    let defense: Int
    let description: String
    let imageUrl: String
    let type: String
}

//struct Lista: Codable {
//    var listaPokemon : [String: [AnyObject]]
//    = ["null," : [Pokemon].self]
//}

