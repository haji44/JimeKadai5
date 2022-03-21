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
//        case invalidFirstValue, invalidSecondValue, dividedZero
    static let invalidFirstValue = "割られる数を入力して下さい"
    static let invalidSecondValue = "割る数を入力して下さい"
    static let dividedZero = "割る数には0を入力しないで下さい"
}

class ViewController: UIViewController {
    @IBOutlet weak private var firstTextField: UITextField!
    @IBOutlet weak private var secondTextField: UITextField!
    @IBOutlet weak private var resultLabel: UILabel!
    @IBOutlet weak private var calcButton: UIButton!

    private var subscription = Set<AnyCancellable>()
    let firstSub = PassthroughSubject<Double?, Never>()
    let secondSub = PassthroughSubject<Double?, Never>()
    var isValid: AnyPublisher<Bool, Never> {
        firstSub.combineLatest(secondSub) {numerator, denominator in
            guard numerator != nil, denominator != nil, denominator  != 0 else {
                print("button disable")
                return false
            }
            print("button valid")
            return true
        }
        .eraseToAnyPublisher()
    }
    var result: AnyPublisher<Double, Never> {
        firstSub.combineLatest(secondSub) { numerator, denominator in
            guard let numerator = numerator, let denominator = denominator else { return 0}
            return numerator / denominator
        }
        .eraseToAnyPublisher()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        calcButton.isEnabled = false
        setupKeyboardType()
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

        isValid.assign(to: \.isEnabled, on: calcButton).store(in: &subscription)

        calcButton.tapPublisher.map { _ in Date() }.combineLatest(result)
            .removeDuplicates(by: { $0.0 == $1.0 })
            .map { String($0.1) }
            .assign(to: \.text, on: resultLabel)
            .store(in: &subscription)
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
