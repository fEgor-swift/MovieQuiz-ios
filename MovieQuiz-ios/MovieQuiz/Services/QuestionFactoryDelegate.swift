

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузки
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
