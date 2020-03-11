//
//  OnboardingModels.swift
//  mentory
//
//  Created by Михаил Андреичев on 11.03.2020.
//  Copyright © 2020 Михаил Андреичев. All rights reserved.
//

import UIKit

struct Slide {
    let image: UIImage
    let title: String
    let subtitle: String
    let highlitedText: String

    static func getSlides() -> [Slide] {
        let slide1 = Slide(
            image: Assets.slide1.image,
            title: Text.Onboarding.Slide1.title,
            subtitle: Text.Onboarding.Slide1.subtitle,
            highlitedText: Text.Onboarding.Slide1.highlited
        )
        let slide2 = Slide(
            image: Assets.slide2.image,
            title: Text.Onboarding.Slide2.title,
            subtitle: Text.Onboarding.Slide2.subtitle,
            highlitedText: Text.Onboarding.Slide2.highlited
        )
        let slide3 = Slide(
            image: Assets.slide3.image,
            title: Text.Onboarding.Slide3.title,
            subtitle: Text.Onboarding.Slide3.subtitle,
            highlitedText: Text.Onboarding.Slide3.highlited
        )
        let slide4 = Slide(
            image: Assets.slide4.image,
            title: Text.Onboarding.Slide4.title,
            subtitle: Text.Onboarding.Slide4.subtitle,
            highlitedText: Text.Onboarding.Slide4.highlited
        )
        let slide5 = Slide(
            image: Assets.slide5.image,
            title: Text.Onboarding.Slide5.title,
            subtitle: Text.Onboarding.Slide5.subtitle,
            highlitedText: Text.Onboarding.Slide5.highlited
        )

        return [slide1, slide2, slide3, slide4, slide5]
    }
}
