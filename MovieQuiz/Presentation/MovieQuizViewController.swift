import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var questionFactory: QuestionFactoryProtocol?
    
    private var statisticService: StatisticService?
    
    private var presenter: MovieQuizPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        imageView.layer.cornerRadius = 20
        showLoadingIndicator()
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    struct Top: Decodable {
        let items: [Movie]
    }
    
    struct Actor: Codable {
        let id: String
        let image: String
        let name: String
        let asCharacter: String
    }
    
    struct Movie: Codable {
        let id: String
        let title: String
        let year: Int
        let image: String
        let releaseDate: String
        let runtimeMins: Int
        let directors: String
        let actorList: [Actor]
        
        enum CodingKeys: CodingKey {
            case id, title, year, image, releaseDate, runtimeMins, directors, actorList
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            title = try container.decode(String.self, forKey: .title)
            
            let year = try container.decode(String.self, forKey: .year)
            self.year = Int(year)!
            
            image = try container.decode(String.self, forKey: .image)
            releaseDate = try container.decode(String.self, forKey: .releaseDate)
            
            let runtimeMins = try container.decode(String.self, forKey: .runtimeMins)
            self.runtimeMins = Int(runtimeMins)!
            
            directors = try container.decode(String.self, forKey: .directors)
            actorList = try container.decode([Actor].self, forKey: .actorList)
        }
    }
    
    func didLoadDataFromServer() {
        presenter?.didLoadDataFromServer()
    }

    func didFailToLoadData(with error: Error) {
        presenter?.didFailToLoadData(with: error)
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] _ in
                self?.questionFactory?.requestNextQuestion()
            })
        presenter?.alertPresenter?.show(model: alertModel)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter?.didReceiveNextQuestion(question: question)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.cornerRadius = 20
    }
    
    private func showNextQuestionOrResults() {
        presenter?.showNextQuestionOrResults()
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            presenter?.correctAnswers += 1
        } else {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            guard let self = self else { return }
            self.noButton.isEnabled = false
            self.yesButton.isEnabled = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
            self.imageView.layer.borderWidth = 0
            self.presenter?.showNextQuestionOrResults()
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter?.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter?.noButtonClicked()
    }
}
