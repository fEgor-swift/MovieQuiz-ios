import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        //заглушка
    }
    
    func show(quiz result: MovieQuiz.QuizResultsViewModel) {
        //заглушка
    }
    
    func showLoadingIndicator() {
        //заглушка
    }
    
    func hideLoadingIndicator() {
        //заглушка
    }
    
    func showNetworkError(message: String) {
        //заглушка
    }
    
    func blockButton(isEnabled: Bool) {
        //заглушка
    }
    
    func setImageBorderColor(isCorrect: Bool) {
        //заглушка
    }
    
    func showAnswerResultView(isCorrect: Bool) {
        //заглушка
    }
    
   
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
