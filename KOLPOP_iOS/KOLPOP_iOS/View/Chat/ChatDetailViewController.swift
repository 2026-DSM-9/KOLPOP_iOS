//
//  ChatDetailViewController.swift
//  KOLPOP_iOS
//

import UIKit
import PhotosUI
import SnapKit
import Then
import NukeExtensions

final class ChatDetailViewController: UIViewController {

    private let room: ChatRoom
    private let roomId: Int
    private let chatService = ChatService()
    private let socketService = ChatSocketService()

    private var messages: [ChatDetailMessage] = []

    private let backButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        $0.tintColor = UIColor(named: "1A1C1E")
    }

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.backgroundColor = UIColor(named: "E8E8E8")
    }

    private let titleLabel = UILabel().then {
        $0.font = .paperlogy(.bold, size: 18)
        $0.textColor = UIColor(named: "1A1C1E")
    }

    private let senderNameLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 13)
        $0.textColor = UIColor(named: "A3A4A5")
    }

    private let statusBadge = UIView().then {
        $0.layer.cornerRadius = 10
    }

    private let statusLabel = UILabel().then {
        $0.font = .paperlogy(.semiBold, size: 12)
    }

    private let dividerView = UIView().then {
        $0.backgroundColor = UIColor(named: "E8E8E8")
    }

    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .white
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
    }

    private let inputBarView = ChatInputBarView(showsAttachmentButton: true).then {
        $0.setPlaceholder("메시지를 입력하세요")
    }

    private var inputBarBottomConstraint: Constraint?

    init(room: ChatRoom) {
        self.room = room
        self.roomId = Int(room.id) ?? 0
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupLayout()
        configureHeader()
        setupTableHeader()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ReceivedMessageCell.self, forCellReuseIdentifier: ReceivedMessageCell.reuseIdentifier)
        tableView.register(SentMessageCell.self, forCellReuseIdentifier: SentMessageCell.reuseIdentifier)

        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        inputBarView.onSendTapped = { [weak self] text in self?.sendMessage(text) }
        inputBarView.onAttachmentTapped = { [weak self] in self?.presentImagePicker() }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        loadHistory()
        connectSocket()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        socketService.disconnect()
    }

    private func loadHistory() {
        chatService.fetchMessages(roomId: roomId) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let responses):
                    self.messages = responses.map(ChatDetailMessage.init(response:))
                    self.tableView.reloadData()
                    self.scrollToBottom(animated: false)
                case .failure(let error):
                    print("채팅 내역 조회 실패: \(error)")
                }
            }
        }
    }

    private func connectSocket() {
        socketService.connectAndSubscribe(roomId: roomId) { [weak self] message in
            guard let self else { return }
            DispatchQueue.main.async {
                self.messages.append(ChatDetailMessage(response: message))
                self.tableView.reloadData()
                self.scrollToBottom(animated: true)
            }
        } onError: { error in
            print("채팅 소켓 오류: \(error)")
        }
    }

    private func setupLayout() {
        statusBadge.addSubview(statusLabel)
        [backButton, thumbnailImageView, titleLabel, senderNameLabel, statusBadge, dividerView, tableView, inputBarView].forEach {
            view.addSubview($0)
        }

        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(28)
        }
        thumbnailImageView.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.leading.equalTo(backButton.snp.trailing).offset(12)
            make.width.height.equalTo(44)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.top)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
        senderNameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
        }
        statusBadge.snp.makeConstraints { make in
            make.centerY.equalTo(senderNameLabel)
            make.leading.equalTo(senderNameLabel.snp.trailing).offset(8)
        }
        statusLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10))
        }

        dividerView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(inputBarView.snp.top).offset(-8)
        }
        inputBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
            inputBarBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12).constraint
        }
    }

    private func configureHeader() {
        if let imageURL = room.imageURL {
            NukeExtensions.loadImage(with: imageURL, into: thumbnailImageView)
        }
        titleLabel.text = room.title
        senderNameLabel.text = room.senderName
        statusBadge.backgroundColor = UIColor(named: room.status.backgroundColorName)
        statusLabel.textColor = UIColor(named: room.status.textColorName)
        statusLabel.text = room.status.detailBadgeText
    }

    private func setupTableHeader() {
        let banner = WarningBannerView(
            title: "사기 매물 주의!",
            message: "계약금을 먼저 요구하거나, 실제 매물과 다른 사진을 사용하는 사기 사례가 있습니다. 반드시 현장 확인 후 계약하세요."
        )
        let container = UIView()
        container.addSubview(banner)
        banner.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-16)
        }

        let targetWidth = UIScreen.main.bounds.width
        let height = container.systemLayoutSizeFitting(
            CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        container.frame = CGRect(x: 0, y: 0, width: targetWidth, height: height)
        tableView.tableHeaderView = container
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }

        let keyboardHeight = max(0, view.bounds.height - endFrame.origin.y - view.safeAreaInsets.bottom)
        inputBarBottomConstraint?.update(offset: -12 - keyboardHeight)

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        if keyboardHeight > 0 {
            scrollToBottom(animated: true)
        }
    }

    private func sendMessage(_ text: String) {
        inputBarView.clear()
        socketService.sendMessage(roomId: roomId, content: text)
    }

    private func sendImage(_ image: UIImage) {
        // TODO: 실제 이미지 업로드 API 연동 전까지는 선택한 이미지를 그대로 메시지에 표시한다.
        messages.append(ChatDetailMessage(sender: .me, content: .pickedImage(image), timestamp: "지금"))
        tableView.reloadData()
        scrollToBottom(animated: true)
    }

    private func presentImagePicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    private func scrollToBottom(animated: Bool) {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
}

extension ChatDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        switch message.sender {
        case .other:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedMessageCell.reuseIdentifier, for: indexPath) as! ReceivedMessageCell
            cell.configure(with: message, senderName: room.senderName)
            return cell
        case .me:
            let cell = tableView.dequeueReusableCell(withIdentifier: SentMessageCell.reuseIdentifier, for: indexPath) as! SentMessageCell
            cell.configure(with: message)
            return cell
        }
    }
}

extension ChatDetailViewController: UITableViewDelegate {}

extension ChatDetailViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            guard let image = object as? UIImage else { return }
            DispatchQueue.main.async {
                self?.sendImage(image)
            }
        }
    }
}
