//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Admin on 05.09.2024.
//

import XCTest

struct ArithmeticOperations {
    func addition(num1: Int, num2: Int) -> Int {
        return num1 + num2
    }
    
    func subtraction(num1: Int, num2: Int) -> Int {
        return num1 - num2
    }
    
    func multiplication(num1: Int, num2: Int) -> Int {
        return num1 * num2
    }
}
class MovieQuizTests: XCTestCase {
    func testAddition() throws {
        // Given
        let arithmeticOperations = ArithmeticOperations()
        let num1 = 1
        let num2 = 2
        
        // When
        let result = arithmeticOperations.addition(num1: num1, num2: num2)
        
        // Then
        XCTAssertEqual(result, )
    }
}

