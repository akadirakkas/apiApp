//
//  String+Extensions.swift
//  apiApp
//
//  Created by AbdulKadir Akkaş on 22.03.2021.
//

import Foundation

extension String {
    func addbrackets() -> String {
        return "(\(self))"
    }
    
    func prefix (withText text : String ) -> String {
        return text + self
    }
    
   
    
}
