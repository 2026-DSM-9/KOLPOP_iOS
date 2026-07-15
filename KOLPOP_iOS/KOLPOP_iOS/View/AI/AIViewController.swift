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

    private let aiService = AIService()

    private let greetings = [
        "안녕하세요! 콜팝 AI 파트너예요.\n원하시는 지역이나 조건을 말씀해주시면 딱 맞는 매물을 추천해드릴게요!\n\nex. 유동인구 많은 1층 매물 찾아줘",
        "안녕하세요! 콜팝 AI 파트너예요.\n원하시는 사업 아이템과 마케팅 종류를 말하시면 그에 맞는 글을 추천해드릴게요!\n\nex. 인스타 글 작성, 태그추천, 포스터 글 작성",
        "안녕하세요! 콜팝 AI 파트너예요.\n어떤 업종을 운영하고 싶으신지 말씀해주시면 어울리는 사업 아이템을 추천해드릴게요!\n\nex. 대학가 근처 팝업으로 어떤 아이템이 좋을까?"
    ]

    /// AI 서버 연동 전/오류 시 카테고리에 맞게 보여줄 더미 응답
    private let dummyReplies = [
        "말씀하신 조건에 맞는 매물을 찾아봤어요!\n\n📍 대전 유성구 봉명동 1층 매물\n- 유동인구 많은 온천 상권 인근\n- 보증금 300만원 / 일 15만원\n\n더 구체적인 지역이나 평수를 알려주시면 더 좁혀서 추천해드릴게요!",
        "요청하신 내용으로 마케팅 문구를 만들어봤어요!\n\n📢 인스타그램 게시글\n\"오늘만 특별하게, 단 하루의 팝업스토어 🎪\n지금 아니면 못 만나요! 놓치지 마세요 ✨\"\n\n#팝업스토어 #원데이클래스 #대전팝업\n\n원하시는 톤이나 강조하고 싶은 포인트가 있으면 알려주세요!",
        "말씀하신 상권 조건에 어울리는 사업 아이템을 추천드릴게요!\n\n💡 추천 아이템: 무인 스터디카페 / 소품샵 팝업\n- 유동인구 대비 임대료 부담이 낮은 편\n- 짧은 운영 기간에도 회전율이 좋은 업종\n\n예상 타겟 고객층을 알려주시면 더 맞춤형으로 추천해드릴게요!"
    ]

    private var messages: [ChatMessage] = []

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
        resetConversation(for: selectedCategoryIndex)

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

        aiService.send(aiTarget(for: selectedCategoryIndex, message: text)) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let reply):
                    self.receiveReply(reply)
                case .failure(let error):
                    print("AI 응답 실패: \(error)")
                    self.receiveReply(self.dummyReplies[self.selectedCategoryIndex])
                }
            }
        }
    }

    /// 카테고리 칩과 AI 엔드포인트 매핑. "매물 추천"은 대화형 응답이 필요해
    /// (구조화된 필터를 받는) /ai/recommend/listings 대신 /ai/chat/listings를 사용한다.
    private func aiTarget(for categoryIndex: Int, message: String) -> AIAPI {
        switch categoryIndex {
        case 0:
            return .chatListings(message: message)
        case 2:
            return .recommendBusinessItems(message: message)
        default:
            return .marketingAutomation(message: message)
        }
    }

    private func receiveReply(_ text: String) {
        guard let lastIndex = messages.indices.last, messages[lastIndex].isTyping else { return }
        messages[lastIndex] = ChatMessage(sender: .ai, text: text, showCopyButton: true)
        tableView.reloadData()
        scrollToBottom(animated: true)
    }

    private func resetConversation(for categoryIndex: Int) {
        messages = [ChatMessage(sender: .ai, text: greetings[categoryIndex])]
        tableView.reloadData()
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
        guard selectedCategoryIndex != indexPath.item else { return }
        selectedCategoryIndex = indexPath.item
        resetConversation(for: selectedCategoryIndex)
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

extension AIViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
