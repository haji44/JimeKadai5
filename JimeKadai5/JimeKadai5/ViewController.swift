//
//  ViewController.swift
//  JimeKadai5
//
//  Created by kitano hajime on 2022/03/18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak private var firstTextField: UITextField!
    @IBOutlet weak private var secondTextField: UITextField!
    @IBOutlet weak private var resultLabel: UILabel!

    enum AlertContext {
        case invalidFirstValue, invalidSecondValue, dividedZero

        var message: String {
            switch self {
            case .invalidFirstValue:
                return "The input value should be numeric, and empty is not allowed."
            case .invalidSecondValue:
                return "The input value should be numeric, and empty is not allowed."
            case .dividedZero:
                return "Can't divide by zero"
            }
        }

        var title: String {
            switch self {
            case .invalidFirstValue:
                return "Check your first input"
            case .invalidSecondValue:
                return "Check your second input"
            case .dividedZero:
                return "Check your second input"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardConfig()
    }

    @IBAction private func calcurateButtonTapped(_ sender: UIButton) {
        guard let firstValue = firstTextField.text.map({ Double($0) }), !(firstValue == nil) else {
            showAlert(AlertContext.invalidFirstValue)
            return
        }
        guard let secondValue = secondTextField.text.map({ Double($0) }), !(secondValue == nil) else {
            showAlert(AlertContext.invalidSecondValue)
            return
        }
        if secondValue == 0 {
            showAlert(AlertContext.dividedZero)
            return
        }
        resultLabel.text = String(firstValue! / secondValue!)
    }

    private func showAlert(_ context: AlertContext) {
        let alert = UIAlertController(title: context.title, message: context.message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    private func keyboardConfig() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func didTapView() {
        view.endEditing(true)
    }
}
