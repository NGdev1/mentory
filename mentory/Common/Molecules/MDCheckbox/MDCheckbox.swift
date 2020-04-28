//
//  MDCheckbox.swift
//  mentory
//
//  Created by Михаил Андреичев on 28.04.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

public typealias CheckboxValueChangedBlock = (_ isOn: Bool) -> Void

@objc
public enum MDCheckboxLine: Int {
    case normal
    case thin
}

public final class MDCheckbox: UIView {
    // MARK: - Properties

    fileprivate var on: Bool = false

    fileprivate let selectionFeedbackGenerator = UISelectionFeedbackGenerator()

    public var checkboxValueChangedBlock: CheckboxValueChangedBlock?

    // MARK: Customization

    public var bgColor: UIColor = UIColor.clear {
        didSet {
            if !isOn {
                setBackground(bgColor)
            }
        }
    }

    public var bgColorSelected = UIColor.clear {
        didSet {
            if isOn {
                setBackground(bgColorSelected)
            }
        }
    }

    public var color: UIColor = UIColor.blue {
        didSet {
            checkmark.color = color
        }
    }

    public var borderColorSelected: UIColor = UIColor.gray
    public var borderColorUnselected: UIColor = UIColor.gray

    public var checkboxCornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = checkboxCornerRadius
            backgroundView.layer.cornerRadius = checkboxCornerRadius
        }
    }

    public var line = MDCheckboxLine.normal

    // MARK: Private properties

    fileprivate var button = UIButton()
    fileprivate var checkmark = MDCheckmarkView()
    internal var backgroundView = UIImageView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    fileprivate func setupView() {
        // Init base properties

        bgColorSelected = .clear
        bgColor = .clear
        line = .thin
        color = Assets.winterGreen.color
        borderColorUnselected = Assets.coolGrey.color
        borderColorSelected = Assets.winterGreen.color
        borderWidth = 1.5
        checkboxCornerRadius = 11

        backgroundView.frame = bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.layer.masksToBounds = true
        addSubview(backgroundView)

        // Setup checkmark
        checkmark.frame = bounds
        checkmark.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(checkmark)

        // Setup button
        button.frame = bounds
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.addTarget(self, action: #selector(MDCheckbox.buttonDidSelected), for: .touchUpInside)
        addSubview(button)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        button.bounds = bounds
        checkmark.bounds = bounds
        showCheckmark(isOn, animated: false)
    }
}

// MARK: - Public

public extension MDCheckbox {
    func setOn(_ on: Bool) {
        setOn(on, animated: false)
    }

    func setOn(_ on: Bool, animated: Bool) {
        self.on = on
        showCheckmark(on, animated: animated)

        if animated {
            UIView.animate(withDuration: 0.275, animations: { [weak self] in
                guard let self = self else { return }
                self.setBackground(on ? self.bgColorSelected : self.bgColor)
                self.setBorderColor(on ? self.borderColorSelected : self.borderColorUnselected)
            })
        } else {
            setBackground(on ? bgColorSelected : bgColor)
            setBorderColor(on ? borderColorSelected : borderColorUnselected)
        }
    }

    var isOn: Bool {
        return on
    }

    internal func setBackground(_ backgroundColor: UIColor) {
        backgroundView.image = UIImage.from(color: backgroundColor)
    }

    internal func setBorderColor(_ color: UIColor) {
        borderColor = color
    }
}

// MARK: - Private

extension MDCheckbox {
    @objc fileprivate func buttonDidSelected() {
        setOn(on == false, animated: true)
        selectionFeedbackGenerator.selectionChanged()
        checkboxValueChangedBlock?(on)
    }

    fileprivate func showCheckmark(_ show: Bool, animated: Bool) {
        if show == true {
            checkmark.strokeWidth = bounds.width / (line == .normal ? 10 : 20)
            checkmark.show(animated)
        } else {
            checkmark.hide(animated)
        }
    }
}
