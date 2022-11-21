import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    
    func highlightImageBorderAndButtonsIsntEnabled(isCorrectAnswer: Bool)
    func stopHighlightImageBorderAndButtonsEnabled()
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
