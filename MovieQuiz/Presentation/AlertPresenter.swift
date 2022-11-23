import UIKit

class AlertPresenter {
    
    func show(controller: UIViewController?, model: AlertModel) {
        
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Alert"
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: model.completion
        )
        
        alert.addAction(action)
        controller?.present(alert, animated: true)
    }
}
