//
//  APIServices.swift
//  apiApp
//
//  Created by AbdulKadir Akkaş on 15.03.2021.
//     KWH4EZV6AYTT61TX

import Foundation
import Combine

struct APIServices : Codable {
    
    enum ApiServiceError : Error {
        case encoding
        case badRequest
    }
    
    
    var apiKey : String {
        return keys.randomElement() ?? ""
    }
    
    var keys = ["KWH4EZV6AYTT61TX" , "XWA264Z3R2W5NDO3" , "L242L07TOUB3PZKK" ]
    
    func fetchSymbolsPuplisher(keywords:String) -> AnyPublisher<SearchResults,Error> {
        let result =  parseQuery(text: keywords)
        var symbol = String()
        
        switch result {
        case .success(let query):
            symbol = query
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(symbol)&apikey=\(apiKey)"
        let urlResult = parseUrl(urlString: urlString)
        
        switch urlResult {
        case .success(let url):
            return URLSession.shared.dataTaskPublisher(for: url).map({ $0.data }).decode(type: SearchResults.self, decoder: JSONDecoder()).receive(on: RunLoop.main).eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    
    
    func fetchTimeSeriesMonthlyAdjustedPublisher(keywords:String) -> AnyPublisher<TimeSeriesMonthlyAdjusted,Error> {
        
        let result =  parseQuery(text: keywords)
        var symbol = String()
        
        switch result {
        case .success(let query):
            symbol = query
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=\(symbol)&apikey=\(apiKey)"
        
        let urlResult = parseUrl(urlString: urlString)
        
        switch urlResult {
        case .success(let url):
            return URLSession.shared.dataTaskPublisher(for: url).map({ $0.data }).decode(type: TimeSeriesMonthlyAdjusted.self, decoder: JSONDecoder()).receive(on: RunLoop.main).eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    
   private func  parseQuery( text : String) -> Result<String ,Error>{
    
    if let query = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed){
        return .success(query)
    }else {
        return .failure(ApiServiceError.encoding)
    }
    
    }
    
    
    private func parseUrl(urlString : String) -> Result<URL,Error>{
        
        if let url = URL(string: urlString) {
            return .success(url)
        }else{
            
            return .failure(ApiServiceError.badRequest)
        }
    }
    
    
}
