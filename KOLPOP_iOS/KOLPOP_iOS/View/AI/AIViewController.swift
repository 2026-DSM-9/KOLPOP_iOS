//
//  AIViewController.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class AIViewController: UIViewController {

    private let categories = [
        PopupCategory(title: "매물 추천"),
        PopupCategory(title: "마케팅 자동화"),
        PopupCategory(title: "사업 아이템 추천")
    ]
    private var selectedCategoryIndex = 1

    private var messages: [ChatMessage] = [
        ChatMessage(
            sender: .ai,
            text: "안녕하세요! 콜팝 AI 파트너예요.\n원하시는 사업 아이템과 마케팅 종류를 말하시면 그에 맞는 글을 추천해드릴게요!\n\nex. 인스타 글 작성, 태그추천, 포스터 글 작성"
        )
    ]

    private let titleLabel = UILabel().then {
        $0.text = "AI 파트너"
        $0.font = .paperlogy(.semiBold, size: 24)
        $0.textColor = UIColor(named: "0F1010")
    }

    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.minimumInteritemSpacing = 8
            $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        return UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            $0.register(CategoryChipCell.self, forCellWithReuseIdentifier: CategoryChipCell.reuseIdentifier)
        }
    }()

    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .white
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 120
        $0.register(AIMessageCell.self, forCellReuseIdentifier: AIMessageCell.reuseIdentifier)
        $0.register(UserMessageCell.self, forCellReuseIdentifier: UserMessageCell.reuseIdentifier)
    }

    private let inputBarView = ChatInputBarView().then {
        $0.setPlaceholder("메시지를 입력하세요")
    }

    private var inputBarBottomConstraint: Constraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.titleView = nil
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupLayout()

        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        inputBarView.onSendTapped = { [weak self] text in self?.sendMessage(text) }

        categoryCollectionView.selectItem(
            at: IndexPath(item: selectedCategoryIndex, section: 0),
            animated: false,
            scrollPosition: []
        )

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupLayout() {
        [titleLabel, categoryCollectionView, tableView, inputBarView].forEach { view.addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(20)
        }
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(inputBarView.snp.top).offset(-8)
        }
        inputBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
            inputBarBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12).constraint
        }
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
        messages.append(ChatMessage(sender: .user, text: text))
        messages.append(ChatMessage(sender: .ai, text: "", isTyping: true))
        tableView.reloadData()
        scrollToBottom(animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            self?.receiveReply(to: text)
        }
    }

    private func receiveReply(to text: String) {
        guard let lastIndex = messages.indices.last, messages[lastIndex].isTyping else { return }
        messages[lastIndex] = ChatMessage(sender: .ai, text: makeReply(to: text), showCopyButton: true)
        tableView.reloadData()
        scrollToBottom(animated: true)
    }

    private func makeReply(to text: String) -> String {
        // TODO: 실제 AI 생성 API 연동 전까지는 데모용 고정 답변을 사용한다.
        "요즘 폭염때문에 더워진 날씨!\n미니 선풍기로 벗어나보세요~^^"
    }

    private func scrollToBottom(animated: Bool) {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
}

extension AIViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryChipCell.reuseIdentifier, for: indexPath) as! CategoryChipCell
        cell.configure(title: categories[indexPath.item].title)
        return cell
    }
}

extension AIViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.font = .paperlogy(.medium, size: 12)
        label.text = categories[indexPath.item].title
        let width = label.intrinsicContentSize.width + 40
        return CGSize(width: width, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.item
    }
}

extension AIViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        switch message.sender {
        case .ai:
            let cell = tableView.dequeueReusableCell(withIdentifier: AIMessageCell.reuseIdentifier, for: indexPath) as! AIMessageCell
            cell.configure(with: message)
            cell.onCopyTapped = {
                UIPasteboard.general.string = message.text
            }
            return cell
        case .user:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserMessageCell.reuseIdentifier, for: indexPath) as! UserMessageCell
            cell.configure(with: message)
            return cell
        }
    }
}

extension AIViewController: UITableViewDelegate {}
