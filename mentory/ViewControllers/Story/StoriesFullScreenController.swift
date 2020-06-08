//
//  StoriesFullScreenController.swift
//  mentory
//
//  Created by Михаил Андреичев on 21.05.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import MDFoundation

class StoriesFullScreenController: UIViewController {
    // MARK: - Properties

    lazy var customView: StoriesFullScreen? = view as? StoriesFullScreen

    var story: Story
    weak var delegate: MainPageControllerLogic?

    // MARK: - Init

    init(story: Story, delegate: MainPageControllerLogic) {
        self.story = story
        self.delegate = delegate
        super.init(
            nibName: Utils.getClassName(StoriesFullScreen.self),
            bundle: Bundle(for: StoriesFullScreen.self)
        )
        addActionHandlers()
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAppearance() {
        customView?.displayStory(story: story)
    }

    // MARK: - Action handlers

    private func addActionHandlers() {
        let tapRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(tap)
        )
        customView?.storyImageView.addGestureRecognizer(tapRecognizer)
    }

    @objc func tap(_ recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(ofTouch: 0, in: view)
        if location.x > view.width / 2 {
            if let result = delegate?.retrieveNextStory(after: story),
                let story = result.story {
                self.story = story
                let transition = CATransition()
                transition.duration = 0.3
                transition.type = CATransitionType.fade
                transition.subtype = CATransitionSubtype.fromRight
                view.window?.layer.add(transition, forKey: kCATransition)
                customView?.displayStory(story: story)
            } else {
                dismiss(animated: true)
            }
        } else {
            if let result = delegate?.retrievePreviousStory(before: story),
                let story = result.story {
                self.story = story
                let transition = CATransition()
                transition.duration = 0.3
                transition.type = CATransitionType.fade
                transition.subtype = CATransitionSubtype.fromLeft
                view.window?.layer.add(transition, forKey: kCATransition)
                customView?.displayStory(story: story)
            } else {
                dismiss(animated: true)
            }
        }
    }
}

// MARK: - ViewControllerImageBasedAnimatable

extension StoriesFullScreenController: ViewControllerImageBasedAnimatable {
    public var actingImageBasedView: ViewImageBasedAnimatable? {
        // swiftlint:disable unused_setter_value
        get { return customView } set {}
    }
}
