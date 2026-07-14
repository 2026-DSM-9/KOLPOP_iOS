//
//  SentMessageCell.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class SentMessageCell: UITableViewCell {

    static let reuseIdentifier = "SentMessageCell"

    // 텍스트/이미지 콘텐츠를 갈아끼우는 단일 컨테이너 (ReceivedMessageCell 참고).
    private let contentContainer = UIView().then {
        $0.layer.cornerRadius = 16
    }

    private let messageLabel = UILabel().then {
        $0.font = .paperlogy(.medium, size: 15)
        $0.textColor = .white
        $0.numberOfLines = 0
    }

    private let messageImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor(named: "00AEEF")?.cgColor
    }

    private let timestampLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 12)
        $0.textColor = UIColor(named: "A3A4A5")
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

        contentContainer.addSubview(messageLabel)
        contentContainer.addSubview(messageImageView)
        [timestampLabel, contentContainer].forEach {
            contentView.addSubview($0)
        }

        contentContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-20)
            make.leading.greaterThanOrEqualToSuperview().offset(60)
            make.bottom.equalToSuperview().offset(-12)
        }
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        messageImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        timestampLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentContainer.snp.leading).offset(-8)
            make.centerY.equalTo(contentContainer.snp.bottom).offset(-8)
        }
    }

    func configure(with message: ChatDetailMessage) {
        timestampLabel.text = message.timestamp

        switch message.content {
        case .text(let text):
            messageLabel.text = text
            messageLabel.isHidden = false
            messageImageView.isHidden = true
            contentContainer.backgroundColor = UIColor(named: "00AEEF")
        case .image(let imageName):
            messageImageView.image = UIImage(named: imageName)
            messageLabel.isHidden = true
            messageImageView.isHidden = false
            contentContainer.backgroundColor = .clear
        case .pickedImage(let image):
            messageImageView.image = image
            messageLabel.isHidden = true
            messageImageView.isHidden = false
            contentContainer.backgroundColor = .clear
        }
    }
}
