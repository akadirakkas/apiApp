//
//  APIServices.swift
//  apiApp
//
//  Created by AbdulKadir Akkaş on 15.03.2021.
//     KWH4EZV6AYTT61TX

import Foundation
import Combine

struct APIServices : Codable {
    var apiKey : String {
        return keys.randomElement() ?? ""
    }
    let keys = ["KWH4EZV6AYTT61TX" , "XWA264Z3R2W5NDO3" , "L242L07TOUB3PZKK" ]
    
    func fetchSymbolsPuplisher(keywords:String) -> AnyPublisher<SearchResults,Error> {
        
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(apiKey)"
        let url = URL(string: urlString)!
        
        
        return URLSession.shared.dataTaskPublisher(for: url).map({ $0.data }).decode(type: SearchResults.self, decoder: JSONDecoder()).receive(on: RunLoop.main).eraseToAnyPublisher()
    }
    
    
    
    
}
