import UIKit

protocol MovieQuizViewControllerProtocol: UIViewController {
    func show(quiz step: QuizStepViewModel)
    
    func highlightImageBorderAndButtonsIsntEnabled(isCorrectAnswer: Bool)
    func stopHighlightImageBorderAndButtonsEnabled()
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
