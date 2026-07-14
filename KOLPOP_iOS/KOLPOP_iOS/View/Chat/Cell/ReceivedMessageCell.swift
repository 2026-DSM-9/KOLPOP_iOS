//
//  ReceivedMessageCell.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class ReceivedMessageCell: UITableViewCell {

    static let reuseIdentifier = "ReceivedMessageCell"

    private let senderNameLabel = UILabel().then {
        $0.font = .paperlogy(.bold, size: 15)
        $0.textColor = UIColor(named: "1A1C1E")
    }

    // 텍스트/이미지 콘텐츠를 갈아끼우는 단일 컨테이너.
    // 서로 다른 두 뷰가 각자 top/bottom을 잡으면 오토레이아웃 충돌이 나므로
    // 셀의 높이를 결정하는 지점은 이 컨테이너 하나로 고정한다.
    private let contentContainer = UIView().then {
        $0.layer.cornerRadius = 16
    }

    private let messageLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 15)
        $0.textColor = UIColor(named: "1A1C1E")
        $0.numberOfLines = 0
    }

    private let messageImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
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
        [senderNameLabel, contentContainer, timestampLabel].forEach {
            contentView.addSubview($0)
        }

        senderNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
        }
        contentContainer.snp.makeConstraints { make in
            make.top.equalTo(senderNameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-60)
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
            make.leading.equalTo(contentContainer.snp.trailing).offset(8)
            make.centerY.equalTo(contentContainer.snp.bottom).offset(-8)
        }
    }

    func configure(with message: ChatDetailMessage, senderName: String) {
        senderNameLabel.text = senderName
        timestampLabel.text = message.timestamp

        switch message.content {
        case .text(let text):
            messageLabel.text = text
            messageLabel.isHidden = false
            messageImageView.isHidden = true
            contentContainer.backgroundColor = UIColor(named: "F8F8F8")
        case .image(let imageName):
            messageImageView.image = UIImage(named: imageName)
            messageLabel.isHidden = true
            messageImageView.isHidden = false
            contentContainer.backgroundColor = .clear
        }
    }
}
