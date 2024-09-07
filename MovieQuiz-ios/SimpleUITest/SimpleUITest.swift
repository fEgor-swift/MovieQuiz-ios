
import XCTest

final class SimpleUITest: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false // тестирование прекращается при первой ошибке
        app = XCUIApplication()
        app.launch() // запуск приложения
    }

    override func tearDownWithError() throws {
        app = nil // обнуляем ссылку на приложение после теста
    }

    // Тест для проверки запуска приложения
    func testAppLaunch() throws {
        // Проверяем, что главный экран отображается после запуска
        XCTAssertTrue(app.otherElements["mainView"].exists, "Main view is not visible.")
    }
}
