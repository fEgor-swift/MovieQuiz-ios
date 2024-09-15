
import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
        
        var correctAnswers: Int = 0         //
        var currentQuestion: QuizQuestion?  //
        weak var viewController: MovieQuizViewController?       //
        var questionFactory: QuestionFactoryProtocol?       //
        let questionsAmount: Int = 10       //
        private var currentQuestionIndex: Int = 0       //
        private let statisticService: StatisticServiceProtocol!         //
        
        
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
        
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
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
                
                let givenAnswer = isYes
                
                viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
            }
            
            func restartGame() {
                currentQuestionIndex = 0
                correctAnswers = 0
                questionFactory?.requestNextQuestion()
            }
            
            
            func showAnswerResult(isCorrect: Bool) {
                // Реализация метода
                
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
//            func didRecieveNextQuestion(question: QuizQuestion?) {
//                print("Received question: \(String(describing: question))")
//                
//                guard let question = question else {
//                    return
//                }
//                
//                currentQuestion = question
//                let viewModel = convert(model: question)
//                DispatchQueue.main.async { [weak self] in
//                    self?.viewController?.show(quiz: viewModel)
//                }
//            }
            func showNextQuestionOrResults() {
                if self.isLastQuestion() {
                    let text = "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
                    
                    let viewModel = QuizResultsViewModel(
                        title: "Этот раунд окончен!",
                        text: text,
                        buttonText: "Сыграть ещё раз")
                    viewController?.show(quiz: viewModel)
                } else {
                    self.switchToNextQuestion()
                    questionFactory?.requestNextQuestion()  // Важно: должно быть корректно передано
                }
            }
        }


