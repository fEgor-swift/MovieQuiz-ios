

import XCTest // не забывайте импортировать фреймворк для тестирования

//@testable import MovieQuiz // импортируем наше приложение для тестирования

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
class MovieQuizTest: XCTestCase {
    func testAddition() throws {
        let aritmeticOperations = ArithmeticOperations()
        let num1 = 1
        let num2 = 2
        
        let result = aritmeticOperations.addition(num1: num1, num2: num2)
        XCTAssertEqual(result, 3)
    }
    
}
