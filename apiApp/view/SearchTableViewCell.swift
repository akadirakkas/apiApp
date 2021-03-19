//
//  SearchTableViewCell.swift
//  apiApp
//
//  Created by AbdulKadir Akkaş on 15.03.2021.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var assetNameLAbel : UILabel!
    @IBOutlet weak var assetSymbolLAbel : UILabel!
    @IBOutlet weak var assetTypeLAbel : UILabel!
    
    func configure(with searchResult : SearchResult) {
        
        assetNameLAbel.text = searchResult.name
        assetSymbolLAbel.text = searchResult.symbol
        assetTypeLAbel.text = searchResult.type.appending(" ").appending(searchResult.currency)
        
        
    }
}
