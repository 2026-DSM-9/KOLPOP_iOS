//
//  QuickMenuCell.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class QuickMenuCell: UICollectionViewCell {

    static let reuseIdentifier = "QuickMenuCell"

    private let iconBackgroundView = UIView().then {
        $0.layer.cornerRadius = 12
    }

    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let arrowImageView = UIImageView(image: UIImage(systemName: "arrow.right")).then {
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.numberOfLines = 1
    }

    private let subtitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true

        iconBackgroundView.addSubview(iconImageView)
        [iconBackgroundView, arrowImageView, titleLabel, subtitleLabel].forEach {
            contentView.addSubview($0)
        }

        iconBackgroundView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(44)
        }
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(22)
        }
        arrowImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(22)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(subtitleLabel.snp.top).offset(-4)
        }
    }

    enum Style {
        case calendar
        case aiPartner
    }

    func configure(style: Style) {
        switch style {
        case .calendar:
            contentView.backgroundColor = UIColor(named: "00AEEF")
            iconBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.25)
            iconImageView.image = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
            iconImageView.tintColor = .white
            arrowImageView.tintColor = .white
            titleLabel.textColor = .white
            titleLabel.text = "지역 축제 캘린더"
            subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.85)
            subtitleLabel.text = "전국 축제를 한 눈에"
        case .aiPartner:
            contentView.backgroundColor = UIColor(named: "0F1010")
            iconBackgroundView.backgroundColor = UIColor(named: "EA8C21")
            iconImageView.image = UIImage(named: "AI")?.withRenderingMode(.alwaysTemplate)
            iconImageView.tintColor = .white
            arrowImageView.tintColor = .white
            titleLabel.textColor = .white
            titleLabel.text = "AI 사업 파트너"
            subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.85)
            subtitleLabel.text = "마케팅 자동화"
        }
    }
}
