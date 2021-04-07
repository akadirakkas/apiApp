//
//  DCAService.swift
//  apiApp
//
//  Created by AbdulKadir Akkaş on 30.03.2021.
//

import Foundation
struct DCAService {
    
    
    func calculate (asset : Asset , initialInvestmentAmount : Double , initialDateOfInvestmentIndex : Int , monthlyDollarCostAveragingAmount: Double)  -> DCAResult{
        
        let investmentAmount = getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex, monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount)
        
        let latestSharePlace = getLatestSharePrice(asset: asset)
        
        let numberofShares = getNumberofShare(asset: asset, initialInvestmentAmount: initialInvestmentAmount , initialDateOfInvestmentIndex: initialDateOfInvestmentIndex, monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount)
        
        let currentValue = getcurrentValue(numberOfShares: numberofShares, latestSharePrice: latestSharePlace)
        
        let isProfitable = currentValue > investmentAmount
        
        let gain = currentValue - investmentAmount
        let yeild  = gain / investmentAmount
        let annualReturn = getAnnualReturn(currentValue: currentValue, investmentAmount: investmentAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        
        return.init(currentValue: currentValue,
                    invesmentAmount: investmentAmount,
                    gain: gain,
                    yeild: yeild,
                    annualReturn: annualReturn,
                    isProfitable: isProfitable)
    }
    
    private func getAnnualReturn (currentValue : Double , investmentAmount : Double  , initialDateOfInvestmentIndex : Int) -> Double {
        let rate = currentValue / investmentAmount
        let years = (initialDateOfInvestmentIndex.doubleValue + 1 ) / 12
        return pow(rate, (1 / years)) - 1
        
    }
    
    
     func getInvestmentAmount(initialInvestmentAmount : Double , initialDateOfInvestmentIndex : Int , monthlyDollarCostAveragingAmount: Double) -> Double {
        
        var totalAmount = Double()
        totalAmount += initialInvestmentAmount
        let dollarCostAveragingAmount = initialDateOfInvestmentIndex.doubleValue  * monthlyDollarCostAveragingAmount
        
        totalAmount += dollarCostAveragingAmount
        return totalAmount
        
    }
    
    
    private func getcurrentValue(numberOfShares : Double , latestSharePrice : Double) -> Double {
        return numberOfShares * latestSharePrice
    }
    
    private func getLatestSharePrice (asset : Asset) -> Double {
      return asset.timeSeriesMonthlyAdjusted.getMonthInfos().first?.adjustedClose ?? 0
        
    }
    
    private func getNumberofShare(asset : Asset , initialInvestmentAmount : Double , initialDateOfInvestmentIndex : Int , monthlyDollarCostAveragingAmount: Double) -> Double {
        
       var  totalShare = Double()
        let initialInvestmentOpenPrice = asset.timeSeriesMonthlyAdjusted.getMonthInfos()[initialDateOfInvestmentIndex].adjusted
        let initialInvestmentShares = initialInvestmentAmount / initialInvestmentOpenPrice
        totalShare += initialInvestmentShares
        asset.timeSeriesMonthlyAdjusted.getMonthInfos().prefix(initialDateOfInvestmentIndex).forEach { (monthInfo) in
            let dcaInvestmentShares = monthlyDollarCostAveragingAmount / monthInfo.adjusted
            totalShare += dcaInvestmentShares
        }
        return totalShare
    }
    
}


struct DCAResult {
    let currentValue : Double
    let invesmentAmount : Double
    let gain : Double
    let yeild : Double
    let annualReturn : Double
    let isProfitable: Bool
}
