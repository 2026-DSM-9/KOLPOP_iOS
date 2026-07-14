//
//  LoadingOverlayView.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class LoadingOverlayView: UIView {

    private let cardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.08
        $0.layer.shadowRadius = 12
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
    }

    private let activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.color = UIColor(named: "EA8C21")
        $0.startAnimating()
    }

    private let messageLabel = UILabel().then {
        $0.font = .paperlogy(.medium, size: 15)
        $0.textColor = UIColor(named: "1A1C1E")
        $0.textAlignment = .center
    }

    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        backgroundColor = UIColor.black.withAlphaComponent(0.05)

        addSubview(cardView)
        cardView.addSubview(activityIndicator)
        cardView.addSubview(messageLabel)

        cardView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(40)
            make.trailing.lessThanOrEqualToSuperview().offset(-40)
        }
        activityIndicator.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(activityIndicator.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
}
