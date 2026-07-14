//
//  WarningBannerView.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class WarningBannerView: UIView {

    private let iconImageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill")).then {
        $0.tintColor = UIColor(named: "EA8C21")
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel().then {
        $0.font = .paperlogy(.bold, size: 16)
        $0.textColor = UIColor(named: "1A1C1E")
    }

    private let messageLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 14)
        $0.textColor = UIColor(named: "1A1C1E")
        $0.numberOfLines = 0
    }

    init(title: String, message: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        messageLabel.text = message
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        backgroundColor = UIColor(named: "FAE2C8")
        layer.cornerRadius = 16

        [iconImageView, titleLabel, messageLabel].forEach { addSubview($0) }

        iconImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
