//
//  SearchResults.swift
//  apiApp
//
//  Created by AbdulKadir Akkaş on 15.03.2021.
//

import Foundation
struct SearchResults : Codable {
    let item : [SearchResult]
    
    enum CodingKeys :  String , CodingKey {
        case item = "bestMatches"
    }
}

struct SearchResult : Codable {
    
    let symbol : String
    let name : String
    let type : String
    let currency : String
    
    
    enum CodingKeys : String , CodingKey {
        
        case symbol = "1. symbol"
        case name = "2. name"
        case type = "3. type"
        case currency = "8. currency"
    }
    
}
