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

    private enum AlertMessage {
        static let invalidFirstValue = "割られる数を入力して下さい"
        static let invalidSecondValue = "割る数を入力して下さい"
        static let dividedZero = "割る数には0を入力しないで下さい"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardType()
        setupTapGesture()
    }

    @IBAction private func calcurateButtonTapped(_ sender: UIButton) {
        guard let firstValue = firstTextField.text.flatMap({ Double($0) }) else {
            showAlert(message: AlertMessage.invalidFirstValue)
            return
        }
        guard let secondValue = secondTextField.text.flatMap({ Double($0) }) else {
            showAlert(message: AlertMessage.invalidSecondValue)
            return
        }
        guard secondValue != 0 else {
            showAlert(message: AlertMessage.dividedZero)
            return
        }
        resultLabel.text = String(firstValue / secondValue)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "課題5", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    private func setupKeyboardType() {
        [firstTextField, secondTextField].forEach { $0?.keyboardType = .numberPad }
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func didTapView() {
        view.endEditing(true)
    }
}
