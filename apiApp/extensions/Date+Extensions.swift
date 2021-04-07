//
//  Date+Extensions.swift
//  apiApp
//
//  Created by AbdulKadir Akkaş on 25.03.2021.
//

import Foundation

extension Date {
    
    var MMYYFormat : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    
}
