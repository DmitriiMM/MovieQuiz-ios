import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: UIViewController, MovieQuizViewControllerProtocol {
    var viewModel: QuizStepViewModel?
    
    func stopHighlightImageBorderAndButtonsEnabled() {
        
    }
    
    func show(quiz step: QuizStepViewModel) {
       
    }
    
    func highlightImageBorderAndButtonsIsntEnabled(isCorrectAnswer: Bool) {
    
    }
    
    func showLoadingIndicator() {
    
    }
    
    func hideLoadingIndicator() {
    
    }
    
    func showNetworkError(message: String) {
    
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        sut.didReceiveNextQuestion(question: question)
        
        DispatchQueue.main.async {
            let model = viewControllerMock.viewModel
            
            
            XCTAssertNotNil(model?.image)
            XCTAssertEqual(model?.question, "Question Text")
            XCTAssertEqual(model?.questionNumber, "1/10")
        }
    }
}
