//
//  TypingIndicatorView.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class TypingIndicatorView: UIView {

    private let dots: [UIView] = (0..<3).map { _ in
        UIView().then {
            $0.backgroundColor = UIColor(named: "A3A4A5")
            $0.layer.cornerRadius = 4
        }
    }

    private lazy var stackView = UIStackView(arrangedSubviews: dots).then {
        $0.axis = .horizontal
        $0.spacing = 6
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        dots.forEach { dot in
            dot.snp.makeConstraints { make in
                make.width.height.equalTo(8)
            }
        }
    }

    func startAnimating() {
        for (index, dot) in dots.enumerated() {
            dot.transform = .identity
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
            animation.values = [0, -5, 0]
            animation.keyTimes = [0, 0.5, 1]
            animation.duration = 0.9
            animation.repeatCount = .infinity
            animation.beginTime = CACurrentMediaTime() + Double(index) * 0.15
            dot.layer.add(animation, forKey: "typingBounce")
        }
    }

    func stopAnimating() {
        dots.forEach { $0.layer.removeAnimation(forKey: "typingBounce") }
    }
}
