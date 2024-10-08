import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var alertPresenter: AlertPresenter?
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    var statisticService: StatisticServiceProtocol!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad вызвано")
        configureImageView()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.requestNextQuestion()
        statisticService = StatisticService()
        alertPresenter = AlertPresenter(viewController: self)
       
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticService()
        
        showLoadingIndicator()
        questionFactory?.loadData()
        
    }
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
//    
//    func didFailToLoadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
//    }
    func didFailToLoadData(with error: Error) {
        print("Не удалось загрузить данные, произошла ошибка: \(error.localizedDescription)")
        showNetworkError(message: error.localizedDescription)
    }
    
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    private func configureImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
            self?.yesButton.isEnabled = true
            self?.noButton.isEnabled = true
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    @IBAction private func yesButton(_ sender: UIButton) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        if let currentQuestion = currentQuestion {
            let givenAnswer = true
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    }
    
    @IBAction private func noButton(_ sender: UIButton) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        if let currentQuestion = currentQuestion {
            let givenAnswer = false
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.showAlert(model: model)
    }
    
    private func showNextQuestionOrResults() {
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        if currentQuestionIndex == questionsAmount - 1 {
            let resultModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "",
                buttonText: "Сыграть еще раз",
                correctAnswers: correctAnswers,
                totalQuestions: questionsAmount
            )
            
            // Сохраняем текущий результат
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            show(quiz: resultModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        // Получаем текущие данные
        let bestGameResult = statisticService.bestGame
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let gamesCount = statisticService.gamesCount
        
        // Текущий результат
        let currentGame = GameResult(correct: correctAnswers, total: questionsAmount, date: Date())
        
        // Рекорд
        let recordDateString: String
        if bestGameResult.total > 0 {
            recordDateString = bestGameResult.date.dateTimeString
        } else {
            recordDateString = "Не установлен"
        }
        
        // Формирование сообщения
        var message = """
        Ваш результат: \(correctAnswers)/\(questionsAmount)
        Количество сыгранных квизов: \(gamesCount)
        Рекорд: \(bestGameResult.correct)/\(bestGameResult.total) (\(recordDateString))
        Средняя точность: \(accuracy)%
        """
        
        // Проверка, был ли побит рекорд
        if currentGame.isBetterThan(bestGameResult) {
            message += "\n\nРекордная игра"
        }
        
        // Создаем модель для алерта
        let alertModel = AlertModel(
            title: result.title,
            message: message,
            buttonText: result.buttonText,
            completion: { [weak self] in
                guard let self = self else { return }
                self.correctAnswers = 0
                self.currentQuestionIndex = 0
                self.questionFactory?.requestNextQuestion()
            }
        )
        
        // Используем AlertPresenter для отображения алерта
        alertPresenter?.showAlert(model: alertModel)
    }
    
}
