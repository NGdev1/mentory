//
//  NameView.swift
//  Mentory
//
//  Created by Михаил Андреичев on 16.12.2019.
//

import MDFoundation

final class NameView: UIView {
    /// Adaptive view state
    enum ViewState {
        /// normal on iphone X, 11, iPad
        case normal
        /// normal on iPhone SE
        case normalSE
        /// normal on iPhone 7 or 8
        case normal7or8
    }

    enum Appearance {
        static func changeState(_ state: ViewState) {
            switch state {
            case .normal:
                nameTopOffset = 60

            case .normal7or8:
                nameTopOffset = 40

            case .normalSE:
                nameTopOffset = 20
            }
        }

        static var nameTopOffset: CGFloat = 50
        static let animationDuration: TimeInterval = 0.3
    }

    // MARK: - Properties

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var greetingLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var nameTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var bottomInsetConstraint: NSLayoutConstraint!
    @IBOutlet var nameTopConstraint: NSLayoutConstraint!

    lazy var nextView: NextInputView = .init()

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
        if ScreenSize.current == .sizeIPhoneSE {
            Appearance.changeState(.normalSE)
        } else if ScreenSize.current == .sizeIPhone8 {
            Appearance.changeState(.normal7or8)
        } else {
            Appearance.changeState(.normal)
        }
        updateConstraintsConstants()
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
            as? NSValue
        else {
            return
        }

        let keyboardSize = keyboardFrame.cgRectValue.size
        adjustContentInset(keyboardSize.height)
    }

    @objc private func keyboardWillHide(notification _: NSNotification) {
        adjustContentInset(nextView.height)
    }

    // MARK: - Private methods

    private func adjustContentInset(_ contentInset: CGFloat) {
        bottomInsetConstraint.constant = contentInset
        UIView.animate(withDuration: Appearance.animationDuration) { [weak self] in
            self?.layoutIfNeeded()
        }
    }

    private func updateConstraintsConstants() {
        nameTopConstraint.constant = Appearance.nameTopOffset
    }
}
