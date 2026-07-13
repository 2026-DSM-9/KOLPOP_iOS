//
//  CalendarDayCell.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class CalendarDayCell: UICollectionViewCell {

    static let reuseIdentifier = "CalendarDayCell"

    enum Style {
        case normal
        case today
        case selected
    }

    private let backgroundShape = UIView().then {
        $0.layer.cornerRadius = 8
    }

    private let dayLabel = UILabel().then {
        $0.font = .paperlogy(.medium, size: 17)
        $0.textColor = UIColor(named: "1A1C1E")
        $0.textAlignment = .center
    }

    private let dotView = UIView().then {
        $0.backgroundColor = UIColor(named: "EA8C21")
        $0.layer.cornerRadius = 3
        $0.isHidden = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(backgroundShape)
        contentView.addSubview(dayLabel)
        contentView.addSubview(dotView)

        backgroundShape.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.center.equalToSuperview()
        }
        dayLabel.snp.makeConstraints { make in
            make.center.equalTo(backgroundShape)
        }
        dotView.snp.makeConstraints { make in
            make.top.equalTo(backgroundShape.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(6)
        }
    }

    func configure(day: Int?, style: Style, hasEvent: Bool) {
        guard let day else {
            dayLabel.text = nil
            backgroundShape.backgroundColor = .clear
            dotView.isHidden = true
            isUserInteractionEnabled = false
            return
        }

        isUserInteractionEnabled = true
        dayLabel.text = "\(day)"
        dotView.isHidden = !hasEvent

        switch style {
        case .normal:
            backgroundShape.backgroundColor = .clear
            dayLabel.textColor = UIColor(named: "1A1C1E")
        case .today:
            backgroundShape.backgroundColor = UIColor(named: "FAE2C8")
            dayLabel.textColor = UIColor(named: "1A1C1E")
        case .selected:
            backgroundShape.backgroundColor = UIColor(named: "EA8C21")
            backgroundShape.layer.cornerRadius = 18
            dayLabel.textColor = .white
        }

        if style != .selected {
            backgroundShape.layer.cornerRadius = 8
        }
    }
}
