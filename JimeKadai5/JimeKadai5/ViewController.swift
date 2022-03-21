//
//  ViewController.swift
//  JimeKadai5
//
//  Created by kitano hajime on 2022/03/18.
//

import UIKit
import Combine
import CombineCocoa

private enum AlertMessage: Error {
    static let invalidFirstValue = "Numerator is empty"
    static let invalidSecondValue = "Denominator is not allowed "
    static let dividedZero = "Can't dived by zero"
}

class ViewController: UIViewController {
    @IBOutlet weak private var firstTextField: UITextField!
    @IBOutlet weak private var secondTextField: UITextField!
    @IBOutlet weak private var resultLabel: UILabel!
    @IBOutlet weak private var calcButton: UIButton!
    var text: String?

    private var subscription = Set<AnyCancellable>()
    let firstSub = PassthroughSubject<Double?, Never>()
    let secondSub = PassthroughSubject<Double?, Never>()
    var result: AnyPublisher<Double, Never> {
        firstSub.combineLatest(secondSub) { numerator, denominator in
            guard let numerator = numerator else {
                self.text = AlertMessage.invalidFirstValue
                return 0
            }
            guard let denominator = denominator else {
                self.text = AlertMessage.invalidSecondValue
                return 0
            }
            guard denominator != 0 else {
                self.text = AlertMessage.dividedZero
                return 0
            }
            self.text = nil
            return numerator / denominator
        }
        .eraseToAnyPublisher()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        calcButton.isEnabled = false
//        setupKeyboardType()
        setupTapGesture()
        setupBinds()
    }

    private func setupBinds() {
        firstTextField.textPublisher.map { value in
            guard let value = value.flatMap({Double($0)}) else { return nil }
            return value
        }
        .sink { self.firstSub.send($0) }
        .store(in: &subscription)

        secondTextField.textPublisher.map { value in
            guard let value = value.flatMap({Double($0)}) else { return nil }
            return value
        }
        .sink { self.secondSub.send($0) }
        .store(in: &subscription)


        calcButton.tapPublisher.map { _ in Date() }.combineLatest(result)
            .removeDuplicates(by: { $0.0 == $1.0 })
            .map {
                if let text = self.text {
                    self.showAlert(message: text)
                }
                return String($0.1)
            }
            .assign(to: \.text, on: resultLabel)
            .store(in: &subscription)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
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
