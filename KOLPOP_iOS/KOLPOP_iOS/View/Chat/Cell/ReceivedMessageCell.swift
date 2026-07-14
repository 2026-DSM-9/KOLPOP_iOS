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

    // isHidden만으로는 제약이 계속 살아있어 messageImageView의 고정 200x200 크기가
    // 텍스트 메시지일 때도 contentContainer 크기를 강제해버린다.
    // 두 콘텐츠 타입의 제약을 따로 두고 필요한 쪽만 활성화한다.
    private var textConstraints: [Constraint] = []
    private var imageConstraints: [Constraint] = []

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
            textConstraints = [
                make.top.equalToSuperview().offset(16).constraint,
                make.leading.equalToSuperview().offset(16).constraint,
                make.trailing.equalToSuperview().offset(-16).constraint,
                make.bottom.equalToSuperview().offset(-16).constraint
            ]
        }
        messageImageView.snp.makeConstraints { make in
            imageConstraints = [
                make.top.equalToSuperview().constraint,
                make.leading.equalToSuperview().constraint,
                make.trailing.equalToSuperview().constraint,
                make.bottom.equalToSuperview().constraint,
                make.width.equalTo(200).constraint,
                make.height.equalTo(200).constraint
            ]
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
            showText()
            contentContainer.backgroundColor = UIColor(named: "F8F8F8")
        case .image(let imageName):
            messageImageView.image = UIImage(named: imageName)
            showImage()
            contentContainer.backgroundColor = .clear
        case .pickedImage(let image):
            messageImageView.image = image
            showImage()
            contentContainer.backgroundColor = .clear
        }
    }

    private func showText() {
        messageLabel.isHidden = false
        messageImageView.isHidden = true
        imageConstraints.forEach { $0.deactivate() }
        textConstraints.forEach { $0.activate() }
    }

    private func showImage() {
        messageLabel.isHidden = true
        messageImageView.isHidden = false
        textConstraints.forEach { $0.deactivate() }
        imageConstraints.forEach { $0.activate() }
    }
}
