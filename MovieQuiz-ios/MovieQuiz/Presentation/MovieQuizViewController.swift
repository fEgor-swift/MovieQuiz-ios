import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
 
    
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
        presenter = MovieQuizPresenter(viewController: self)
        presenter.viewController = self
        configureImageView()
        statisticService = StatisticService()
        alertPresenter = AlertPresenter(viewController: self)
        imageView.layer.cornerRadius = 20
        showLoadingIndicator()
        view.accessibilityIdentifier = "mainView"
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    
    private func configureImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
    }
    
    
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    func blockButton(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    func showAnswerResultView(isCorrect: Bool) {
        setImageBorderColor(isCorrect: isCorrect)
    }
    
    func setImageBorderColor(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        setBorderProperties(color: isCorrect ? UIColor(named: "YP Green")!.cgColor : UIColor(named: "YP Red")!.cgColor)
    }
    
    private func setBorderProperties(color: CGColor) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = color
    }
    
    func hideLoadingIndicator() {          
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    func showNetworkError(message: String) {
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
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: { [weak self] in
                guard let self = self else { return }
                self.presenter.restartGame()
            }
        )
        
        alertPresenter?.showAlert(model: alertModel)
    }
    
}

