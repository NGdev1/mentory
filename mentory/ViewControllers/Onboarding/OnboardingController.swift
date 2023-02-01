//
//  OnboardingController.swift
//  mentory
//
//  Created by Михаил Андреичев on 11.03.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import MDFoundation
import Storable

public class OnboardingController: UIViewController {
    // MARK: - Properties

    lazy var customView: OnboardingView? = view as? OnboardingView

    var data: [Slide] = []
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()

    // MARK: - Init

    init() {
        super.init(
            nibName: Utils.getClassName(OnboardingView.self),
            bundle: Bundle(for: OnboardingView.self)
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        addActionHandlers()
    }

    private func setupAppearance() {
        customView?.setDelegate(self)
        data = Slide.getSlides()
        customView?.updateData(data: data)
    }

    // MARK: - Action handlers

    private func addActionHandlers() {
        customView?.nextButton.addTarget(
            self,
            action: #selector(nextPage),
            for: .touchUpInside
        )
        customView?.skipButton.addTarget(
            self,
            action: #selector(skip),
            for: .touchUpInside
        )
    }

    @objc func skip() {
        openMainPage()
    }

    @objc func nextPage() {
        if customView?.getPage() == data.count - 1 {
            openMainPage()
        } else {
            customView?.nextPage()
        }
    }

    // MARK: - Private methods

    private func openMainPage() {
        selectionFeedbackGenerator.selectionChanged()
        let window = AppDelegate.shared?.window
        if AppService.shared.app.userName == nil {
            let nextController = NameController()
            window?.rootViewController = nextController
        } else {
            let nextController = MainPageController()
            window?.rootViewController = nextController
        }
    }
}

// MARK: - SlidesDataSourceDelegate

extension OnboardingController: SlidesDataSourceDelegate {
    func pageChanged(page: Int) {
        customView?.pageChanged(index: page, pagesCount: data.count)
    }
}
