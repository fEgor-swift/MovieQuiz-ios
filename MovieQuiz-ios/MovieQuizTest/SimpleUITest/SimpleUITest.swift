//
//  SimpleUITest.swift
//  SimpleUITest
//
//  Created by Admin on 06.09.2024.
//

import XCTest

import XCTest
@testable import MovieQuiz // Замените MovieQuiz на ваше имя проекта

final class MathOperationsTests: XCTestCase {

    func testAddition() throws {
        // Given
        let mathOperations = MathOperations()
        let number1 = 5
        let number2 = 7

        // When
        let result = mathOperations.addNumbers(number1, number2)

        // Then
        XCTAssertEqual(result, 12, "Expected result to be 12")
    }
}
