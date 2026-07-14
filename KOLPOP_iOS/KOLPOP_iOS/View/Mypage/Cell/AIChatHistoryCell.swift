//
//  AIChatHistoryCell.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class AIChatHistoryCell: UITableViewCell {

    static let reuseIdentifier = "AIChatHistoryCell"

    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "E8E8E8")?.cgColor
    }

    private let titleLabel = UILabel().then {
        $0.font = .paperlogy(.bold, size: 16)
        $0.textColor = UIColor(named: "0F1010")
    }

    private let previewLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 14)
        $0.textColor = UIColor(named: "A3A4A5")
        $0.numberOfLines = 1
    }

    private let dateLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 13)
        $0.textColor = UIColor(named: "A3A4A5")
    }

    private let chevronImageView = UIImageView(image: UIImage(systemName: "arrow.right")).then {
        $0.tintColor = UIColor(named: "1A1C1E")
        $0.contentMode = .scaleAspectFit
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        selectionStyle = .none
        backgroundColor = .clear

        [titleLabel, previewLabel, dateLabel, chevronImageView].forEach {
            containerView.addSubview($0)
        }
        contentView.addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20))
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.lessThanOrEqualTo(chevronImageView.snp.leading).offset(-8)
        }
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(20)
        }
        previewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(previewLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    func configure(with item: AIChatHistoryItem) {
        titleLabel.text = item.title
        previewLabel.text = item.lastMessagePreview
        dateLabel.text = item.dateText
    }
}
