//
//  MenuRowView.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class MenuRowView: UIView {

    var onTap: (() -> Void)?

    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "E8E8E8")?.cgColor
    }

    private let iconBackgroundView = UIView().then {
        $0.backgroundColor = UIColor(named: "F8F8F8")
        $0.layer.cornerRadius = 12
    }

    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel().then {
        $0.font = .paperlogy(.bold, size: 16)
    }

    private let subtitleLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 13)
        $0.textColor = UIColor(named: "A3A4A5")
    }

    private let chevronImageView = UIImageView(image: UIImage(systemName: "arrow.right")).then {
        $0.tintColor = UIColor(named: "1A1C1E")
        $0.contentMode = .scaleAspectFit
    }

    init(iconName: String, title: String, subtitle: String?, tintColorName: String = "1A1C1E") {
        super.init(frame: .zero)
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = UIColor(named: tintColorName)
        titleLabel.text = title
        titleLabel.textColor = UIColor(named: tintColorName)
        subtitleLabel.text = subtitle
        setupLayout(hasSubtitle: subtitle != nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout(hasSubtitle: Bool) {
        iconBackgroundView.addSubview(iconImageView)
        containerView.addSubview(iconBackgroundView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(chevronImageView)
        addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        iconBackgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48)
        }
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(22)
        }
        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }

        // 서브타이틀이 없는 행(로그아웃/회원탈퇴)은 titleLabel이 컨테이너 높이를 결정하고,
        // 있는 행은 subtitleLabel이 결정하도록 구성 시점에 갈라서 불필요한 여백을 없앤다.
        if hasSubtitle {
            containerView.addSubview(subtitleLabel)
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(18)
                make.leading.equalTo(iconBackgroundView.snp.trailing).offset(14)
                make.trailing.lessThanOrEqualTo(chevronImageView.snp.leading).offset(-8)
            }
            subtitleLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(4)
                make.leading.equalTo(iconBackgroundView.snp.trailing).offset(14)
                make.bottom.equalToSuperview().offset(-18)
            }
        } else {
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(22)
                make.bottom.equalToSuperview().offset(-22)
                make.leading.equalTo(iconBackgroundView.snp.trailing).offset(14)
                make.trailing.lessThanOrEqualTo(chevronImageView.snp.leading).offset(-8)
            }
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rowTapped))
        addGestureRecognizer(tapGesture)
    }

    @objc private func rowTapped() {
        onTap?()
    }
}
