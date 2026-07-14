//
//  UserMessageCell.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class UserMessageCell: UITableViewCell {

    static let reuseIdentifier = "UserMessageCell"

    private let bubbleView = UIView().then {
        $0.backgroundColor = UIColor(named: "00AEEF")
        $0.layer.cornerRadius = 18
    }

    private let messageLabel = UILabel().then {
        $0.font = .paperlogy(.medium, size: 15)
        $0.textColor = .white
        $0.numberOfLines = 0
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

        bubbleView.addSubview(messageLabel)
        contentView.addSubview(bubbleView)

        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 18, bottom: 12, right: 18))
        }
        bubbleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.greaterThanOrEqualToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    func configure(with message: ChatMessage) {
        messageLabel.text = message.text
    }
}
