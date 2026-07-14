//
//  InfoCardView.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class InfoCardView: UIView {

    let contentContainer = UIView()

    init(iconName: String, title: String, iconTintColorName: String = "1A1C1E") {
        super.init(frame: .zero)
        setupLayout(iconName: iconName, title: title, iconTintColorName: iconTintColorName)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout(iconName: String, title: String, iconTintColorName: String) {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "E8E8E8")?.cgColor

        let iconImageView = UIImageView(image: UIImage(systemName: iconName)).then {
            $0.tintColor = UIColor(named: iconTintColorName)
            $0.contentMode = .scaleAspectFit
        }
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .paperlogy(.bold, size: 17)
            $0.textColor = UIColor(named: "1A1C1E")
        }

        [iconImageView, titleLabel, contentContainer].forEach { addSubview($0) }

        iconImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
        }
        contentContainer.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
