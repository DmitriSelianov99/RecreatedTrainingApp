//
//  UIStackView + Extension.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 24.06.2023.
//

import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.distribution = .equalSpacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
