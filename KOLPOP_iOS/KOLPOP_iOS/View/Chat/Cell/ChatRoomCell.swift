//
//  ChatRoomCell.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then
import NukeExtensions

final class ChatRoomCell: UITableViewCell {

    static let reuseIdentifier = "ChatRoomCell"

    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "E8E8E8")?.cgColor
    }

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 14
        $0.backgroundColor = UIColor(named: "E8E8E8")
    }

    private let unreadBadge = UIView().then {
        $0.backgroundColor = UIColor(named: "EA8C21")
        $0.layer.cornerRadius = 10
    }

    private let unreadLabel = UILabel().then {
        $0.font = .paperlogy(.bold, size: 12)
        $0.textColor = .white
        $0.textAlignment = .center
    }

    private let titleLabel = UILabel().then {
        $0.font = .paperlogy(.bold, size: 16)
        $0.textColor = UIColor(named: "00688F")
    }

    private let lastMessageLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 14)
        $0.textColor = UIColor(named: "A3A4A5")
        $0.numberOfLines = 1
    }

    private let senderNameLabel = UILabel().then {
        $0.font = .paperlogy(.medium, size: 14)
        $0.textColor = UIColor(named: "1A1C1E")
    }

    private let statusBadge = UIView().then {
        $0.layer.cornerRadius = 12
    }

    private let statusLabel = UILabel().then {
        $0.font = .paperlogy(.semiBold, size: 13)
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

        unreadBadge.addSubview(unreadLabel)
        statusBadge.addSubview(statusLabel)
        [thumbnailImageView, unreadBadge, titleLabel, lastMessageLabel, senderNameLabel, statusBadge].forEach {
            containerView.addSubview($0)
        }
        contentView.addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20))
        }

        // bottom을 고정으로 잡으면 썸네일(고정 70pt)이 컨테이너 높이를 결정해버려서
        // 텍스트 길이와 무관하게 셀 높이가 항상 똑같이 고정된다.
        // 아래쪽은 여유만 두고(lessThanOrEqualTo), 실제 높이는 텍스트 쪽(senderNameLabel)이 결정하도록 한다.
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
            make.width.height.equalTo(70)
        }
        unreadBadge.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.top).offset(-8)
            make.leading.equalTo(thumbnailImageView.snp.leading).offset(-8)
            make.width.height.equalTo(20)
        }
        unreadLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(14)
            make.trailing.lessThanOrEqualTo(statusBadge.snp.leading).offset(-8)
        }
        statusBadge.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-16)
        }
        statusLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12))
        }

        lastMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(14)
            make.trailing.equalToSuperview().offset(-16)
        }
        senderNameLabel.snp.makeConstraints { make in
            make.top.equalTo(lastMessageLabel.snp.bottom).offset(8)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(14)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    func configure(with room: ChatRoom) {
        if let imageURL = room.imageURL {
            NukeExtensions.loadImage(with: imageURL, into: thumbnailImageView)
        } else {
            thumbnailImageView.image = nil
        }
        titleLabel.text = room.title
        lastMessageLabel.text = room.lastMessage
        senderNameLabel.text = room.senderName

        unreadBadge.isHidden = room.unreadCount <= 0
        unreadLabel.text = "\(room.unreadCount)"

        statusBadge.backgroundColor = UIColor(named: room.status.backgroundColorName)
        statusLabel.textColor = UIColor(named: room.status.textColorName)
        statusLabel.text = room.status.listBadgeText
    }
}
