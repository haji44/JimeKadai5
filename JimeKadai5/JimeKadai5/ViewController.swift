//
//  ViewController.swift
//  JimeKadai5
//
//  Created by kitano hajime on 2022/03/18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!

    enum AlertContext {
        case invalidFirstValue, invalidSecondValue, dividedZero

        var message: String {
            switch self {
            case .invalidFirstValue:
                return "First input value is invalid."
            case .invalidSecondValue:
                return "Second input value is invalid"
            case .dividedZero:
                return "Can't divide by zero"
            }
        }

        var title: String {
            switch self {
            case .invalidFirstValue:
                return ""
            case .invalidSecondValue:
                return ""
            case .dividedZero:
                return ""
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardConfig()
    }

    @IBAction func calcurateButtonTapped(_ sender: UIButton) {
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
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
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

