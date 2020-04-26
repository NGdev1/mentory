//
//  NameView.swift
//  Mentory
//
//  Created by Михаил Андреичев on 16.12.2019.
//

import MDFoundation

final class NameView: UIView {
    struct Appearance {
        static let animationDuration: TimeInterval = 0.3
    }

    // MARK: - Properties

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var greetingLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var nameTitle: UILabel!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var bottomInsetConstraint: NSLayoutConstraint!

    lazy var backButton = UIBarButtonItem(title: Text.Common.back, style: .done, target: nil, action: nil)

    // MARK: - Xib Init

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    private func commonInit() {
        setupStyle()
        addActionHandlers()
    }

    private func setupStyle() {
        nameTextField.placeholder = Text.Name.placeholder
        greetingLabel.text = Text.Name.title
        infoLabel.text = Text.Name.subtitle
        nameTitle.text = Text.Name.whatIsYourName
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Action handlers

    private func addActionHandlers() {
        let defaultNotificationCenter = NotificationCenter.default
        defaultNotificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        defaultNotificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        let dismissTapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboardAction)
        )
        scrollView.addGestureRecognizer(dismissTapRecognizer)
    }

    @objc internal func dismissKeyboardAction() {
        endEditing(true)
    }

    // MARK: - Keyboard action notification

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            as? NSValue else {
            return
        }

        let keyboardSize = keyboardFrame.cgRectValue.size
        adjustContentInset(keyboardSize.height)
    }

    @objc private func keyboardWillHide(notification _: NSNotification) {
        adjustContentInset(.zero)
    }

    // MARK: - Private methods

    private func adjustContentInset(_ contentInset: CGFloat) {
        bottomInsetConstraint.constant = contentInset
        UIView.animate(withDuration: Appearance.animationDuration) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
}
