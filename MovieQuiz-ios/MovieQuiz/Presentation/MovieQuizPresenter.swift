
import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    
    var correctAnswers: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var questionFactory: QuestionFactoryProtocol?
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private let statisticService: StatisticServiceProtocol!
    
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        statisticService = StatisticService()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        print("Не удалось загрузить данные, произошла ошибка: \(error.localizedDescription)")
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
            self?.viewController?.enableButtons()
        }
    }
    
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    

    func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        viewController?.disableButtons()
        
        let givenAnswer = isYes
        let isCorrect = givenAnswer == currentQuestion.correctAnswer
        
        viewController?.showAnswerResultView(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
        }
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            let resultsViewModel = makeResultsMessage()
            viewController?.show(quiz: resultsViewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    
    }
    func showAnswerResult(isCorrect: Bool) {
        viewController?.showAnswerResultView(isCorrect: isCorrect)

        if isCorrect {
            correctAnswers += 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    func makeResultsMessage() -> QuizResultsViewModel {
        let bestGameResult = statisticService.bestGame
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let gamesCount = statisticService.gamesCount
        
        let currentGame = GameResult(correct: correctAnswers, total: questionsAmount, date: Date())
        let recordDateString = bestGameResult.total > 0 ? bestGameResult.date.dateTimeString : "Не установлен"
        
        var message = """
        Ваш результат: \(correctAnswers)/\(questionsAmount)
        Количество сыгранных квизов: \(gamesCount)
        Рекорд: \(bestGameResult.correct)/\(bestGameResult.total) (\(recordDateString))
        Средняя точность: \(accuracy)%
        """
        
        if currentGame.isBetterThan(bestGameResult) {
            message += "\n\nРекордная игра"
        }
        
        return QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: message,
            buttonText: "Сыграть ещё раз"
        )
    }
}


