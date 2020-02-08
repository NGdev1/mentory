//
//  UIView+ActivityIndicator.swift
//  Mouse
//
//  Created by Andreichev Michail on 27.10.2018
//  Copyright © 2017 Complimaker. All rights reserved.
//

import UIKit

public enum LoadingIndicatorPostion {
    case top(inset: CGFloat)
    case center
    case bottom
}

extension UIView {
    private var hudView: HudView? {
        for case let subview as HudView in subviews {
            return subview
        }
        return nil
    }

    public func startShowingActivityIndicator(
        position: LoadingIndicatorPostion = .center,
        needToDimBackground: Bool = false
    ) {
        stopShowingActivityIndicator()
        let hud = HudView(
            frame: frame,
            position: position,
            needToDimBackground: needToDimBackground
        )
        addSubview(hud)
        hud.makeEdgesEqualToSuperview()
    }

    public func stopShowingActivityIndicator() {
        hudView?.removeFromSuperview()
    }
}

private class HudView: UIView {
    private lazy var loadingView: UIActivityIndicatorView = {
        var loadingView: UIActivityIndicatorView
        if #available(iOS 13, *) {
            loadingView = UIActivityIndicatorView(style: .large)
        } else {
            loadingView = UIActivityIndicatorView(style: .gray)
        }
        loadingView.x = width / 2 - loadingView.width / 2
        loadingView.startAnimating()
        return loadingView
    }()

    private lazy var dimBackgroundEffect: UIView = {
        let view = UIView(frame: frame)
        view.backgroundColor = Assets.black.color
        view.alpha = 0
        view.isUserInteractionEnabled = true
        return view
    }()

    public init(
        frame: CGRect,
        position: LoadingIndicatorPostion,
        needToDimBackground: Bool
    ) {
        super.init(frame: frame)
        if needToDimBackground {
            dimBackground()
        }
        addLoadingView(position: position)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addLoadingView(position: LoadingIndicatorPostion) {
        addSubview(loadingView)

        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
        ])

        switch position {
        case let .top(inset):
            topAnchor.constraint(equalTo: loadingView.topAnchor, constant: inset).isActive = true
        case .center:
            centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        case .bottom:
            bottomAnchor.constraint(equalTo: loadingView.bottomAnchor).isActive = true
        }
    }

    private func dimBackground() {
        addSubview(dimBackgroundEffect)
        dimBackgroundEffect.makeEdgesEqualToSuperview()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.dimBackgroundEffect.alpha = 0.8
        }
    }
}
