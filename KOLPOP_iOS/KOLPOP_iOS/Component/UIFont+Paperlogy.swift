//
//  UIFont+Paperlogy.swift
//  KOLPOP_iOS
//

import UIKit

extension UIFont {

    enum Paperlogy: String {
        case regular = "Paperlogy-4Regular"
        case medium = "Paperlogy-5Medium"
        case semiBold = "Paperlogy-6SemiBold"
        case bold = "Paperlogy-7Bold"
    }

    static func paperlogy(_ weight: Paperlogy, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: weight.rawValue, size: size) else {
            return .systemFont(ofSize: size, weight: .regular)
        }
        return font
    }
}
