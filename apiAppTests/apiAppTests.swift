//
//  apiAppTests.swift
//  apiAppTests
//
//  Created by AbdulKadir Akkaş on 7.04.2021.
//

import XCTest
@testable import apiApp

class apiAppTests: XCTestCase {
    
    var sut : DCAService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DCAService()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        
    }
    
    
    
    /*format for test function name
    what
    given
    expectation */
    
    func testDCAResult_givenDCAIsUsed_expectResult(){
        
    }
    
    
    func testDCAResult_givenDCAIsNotUsed_expectResult(){
        //given
        let initialInvestmentAmount : Double = 500
        let initialDateOfInvestmentIndex : Int = 100
        let monthlyDollarCostAveragingAmount : Double = 4
        //when
       let investmentAmount =  sut.getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex, monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount)
        
        //then
        XCTAssertEqual(investmentAmount, 900)
        
        
    }
    
    
    
    
    
    

//    func testExample()  {
//        //Given
//        //When
//        //Then
//    }
//
//

}
