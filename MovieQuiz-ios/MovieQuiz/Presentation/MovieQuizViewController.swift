import UIKit

final class MovieQuizViewController: UIViewController {
    
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenter?
    var statisticService: StatisticServiceProtocol!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self) // Сначала инициализируем presenter
        presenter.viewController = self // Затем настраиваем
        configureImageView()
        statisticService = StatisticService()
        alertPresenter = AlertPresenter(viewController: self)
        imageView.layer.cornerRadius = 20
        showLoadingIndicator()
        view.accessibilityIdentifier = "mainView"
    }
    
    func showLoadingIndicator() { //
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    
    private func configureImageView() {             //
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
    }
    
    
    
    func show(quiz step: QuizStepViewModel) {          //
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {   //
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {        //
        presenter.noButtonClicked()
    }
    
    
    func showAnswerResultView(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            presenter.correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        
    }
    func hideLoadingIndicator() {          //
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    func showNetworkError(message: String) {       //
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.resetQuestionIndex()
            self.presenter.correctAnswers = 0
        }
        
        alertPresenter?.showAlert(model: model)
    }
    
    
    
    func show(quiz result: QuizResultsViewModel) {
        // Получаем текущие данные
        let bestGameResult = statisticService.bestGame
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let gamesCount = statisticService.gamesCount
        
        // Текущий результат
        let currentGame = GameResult(correct: presenter.correctAnswers, total: presenter.questionsAmount, date: Date())
        
        // Рекорд
        let recordDateString: String
        if bestGameResult.total > 0 {
            recordDateString = bestGameResult.date.dateTimeString
        } else {
            recordDateString = "Не установлен"
        }
        
        // Формирование сообщения
        var message = """
        Ваш результат: \(presenter.correctAnswers)/\(presenter.questionsAmount)
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
                self.presenter.correctAnswers = 0
                self.presenter.restartGame()
            }
        )
        
        // Используем AlertPresenter для отображения алерта
        alertPresenter?.showAlert(model: alertModel)
    }
    
}

