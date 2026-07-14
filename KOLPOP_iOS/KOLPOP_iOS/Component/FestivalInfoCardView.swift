//
//  FestivalInfoCardView.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class FestivalInfoCardView: UIView {

    private let titleLabel = UILabel().then {
        $0.font = .paperlogy(.bold, size: 18)
        $0.textColor = UIColor(named: "0F1010")
    }

    private let dDayBadge = UIView().then {
        $0.backgroundColor = UIColor(named: "F2BA7A")
        $0.layer.cornerRadius = 10
    }

    private let dDayLabel = UILabel().then {
        $0.font = .paperlogy(.semiBold, size: 13)
        $0.textColor = UIColor(named: "5E380D")
    }

    private let calendarIcon = UIImageView(image: UIImage(systemName: "calendar")).then {
        $0.tintColor = UIColor(named: "A3A4A5")
        $0.contentMode = .scaleAspectFit
    }

    private let dateLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 14)
        $0.textColor = UIColor(named: "767778")
    }

    private let organizerLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 13)
        $0.textColor = UIColor(named: "A3A4A5")
    }

    private let descriptionLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 14)
        $0.textColor = UIColor(named: "1A1C1E")
    }

    private let divider = UIView().then {
        $0.backgroundColor = UIColor(named: "E8E8E8")
    }

    private let buildingIcon = UIImageView(image: UIImage(systemName: "building.2.fill")).then {
        $0.tintColor = UIColor(named: "EA8C21")
        $0.contentMode = .scaleAspectFit
    }

    private let nearbyBuildingLabel = UILabel().then {
        $0.font = .paperlogy(.medium, size: 14)
        $0.textColor = UIColor(named: "1A1C1E")
    }

    /// 한 줄로 말줄임되는 목록용, 여러 줄로 전체를 보여주는 상세 화면용을 모두 지원한다.
    init(descriptionNumberOfLines: Int = 1) {
        super.init(frame: .zero)
        descriptionLabel.numberOfLines = descriptionNumberOfLines
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "E8E8E8")?.cgColor

        dDayBadge.addSubview(dDayLabel)
        [titleLabel, dDayBadge, calendarIcon, dateLabel, organizerLabel, descriptionLabel, divider, buildingIcon, nearbyBuildingLabel].forEach {
            addSubview($0)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        dDayBadge.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        dDayLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10))
        }

        calendarIcon.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(16)
        }
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calendarIcon)
            make.leading.equalTo(calendarIcon.snp.trailing).offset(6)
        }
        organizerLabel.snp.makeConstraints { make in
            make.top.equalTo(calendarIcon.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(organizerLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        divider.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }

        buildingIcon.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.height.equalTo(18)
        }
        nearbyBuildingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(buildingIcon)
            make.leading.equalTo(buildingIcon.snp.trailing).offset(6)
        }
    }

    func configure(with festival: Festival, nearbyVacantBuildingCount: Int) {
        titleLabel.text = festival.name
        dDayLabel.text = festival.dDayText
        dateLabel.text = festival.dateRangeText
        organizerLabel.text = "\(festival.place) · \(festival.region)"
        descriptionLabel.text = festival.content ?? festival.address

        let countText = "\(nearbyVacantBuildingCount)개"
        let text = "근처 빈 건물 \(countText)"
        let attributed = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: UIFont.paperlogy(.medium, size: 14),
                .foregroundColor: UIColor(named: "1A1C1E") ?? .black
            ]
        )
        if let range = text.range(of: countText) {
            attributed.addAttributes(
                [
                    .foregroundColor: UIColor(named: "EA8C21") ?? .orange,
                    .font: UIFont.paperlogy(.bold, size: 14)
                ],
                range: NSRange(range, in: text)
            )
        }
        nearbyBuildingLabel.attributedText = attributed
    }
}
