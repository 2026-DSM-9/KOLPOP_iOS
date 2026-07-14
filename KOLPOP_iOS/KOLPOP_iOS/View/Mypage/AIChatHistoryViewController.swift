//
//  AIChatHistoryViewController.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class AIChatHistoryViewController: UIViewController {

    // TODO: 실제 AI 대화 기록 API 연동 전까지는 목업 데이터를 사용한다.
    private let items: [AIChatHistoryItem] = [
        AIChatHistoryItem(
            id: "0",
            title: "립스틱 사업 아이템 장소 추천",
            lastMessagePreview: "AI 파트너야 고마워!",
            dateText: "2026.07.13",
            messages: [
                ChatMessage(
                    sender: .ai,
                    text: "안녕하세요! 콜팝 AI 파트너예요.\n원하시는 마케팅을 말하시면 그에 맞는 글을 추천해드릴게요!\n\nex. 인스타 글 작성, 태그추천, 포스터 글 작성"
                ),
                ChatMessage(sender: .user, text: "인스타 글 작성"),
                ChatMessage(
                    sender: .ai,
                    text: "요즘 폭염때문에 더워진 날씨!\n미니 선풍기로 벗어나보세요~^^",
                    showCopyButton: true
                )
            ]
        ),
        AIChatHistoryItem(
            id: "1",
            title: "립스틱 사업 아이템 장소 추천",
            lastMessagePreview: "AI 파트너야 고마워!",
            dateText: "2026.07.13",
            messages: [
                ChatMessage(
                    sender: .ai,
                    text: "안녕하세요! 콜팝 AI 파트너예요.\n원하시는 마케팅을 말하시면 그에 맞는 글을 추천해드릴게요!\n\nex. 인스타 글 작성, 태그추천, 포스터 글 작성"
                ),
                ChatMessage(sender: .user, text: "인스타 글 작성"),
                ChatMessage(
                    sender: .ai,
                    text: "요즘 폭염때문에 더워진 날씨!\n미니 선풍기로 벗어나보세요~^^",
                    showCopyButton: true
                )
            ]
        ),
        AIChatHistoryItem(
            id: "2",
            title: "강원도 축제 사업 아이디어 추천",
            lastMessagePreview: "강원도에서 이러한 축제가 열리면 어떻게 해서 이런 사업 아이템 …",
            dateText: "2026.07.13",
            messages: [
                ChatMessage(sender: .user, text: "강원도에서 이러한 축제가 열리면 어떻게 해서 이런 사업 아이템을 추천해줄 수 있어?"),
                ChatMessage(
                    sender: .ai,
                    text: "강원도 지역 축제 특성에 맞춰 굿즈, 팝업 매장, 지역 특산물 콜라보 아이템을 추천드려요!",
                    showCopyButton: true
                )
            ]
        ),
        AIChatHistoryItem(
            id: "3",
            title: "립스틱 사업 아이템 장소 추천",
            lastMessagePreview: "AI 파트너야 고마워!",
            dateText: "2026.07.13",
            messages: [
                ChatMessage(
                    sender: .ai,
                    text: "안녕하세요! 콜팝 AI 파트너예요.\n원하시는 마케팅을 말하시면 그에 맞는 글을 추천해드릴게요!\n\nex. 인스타 글 작성, 태그추천, 포스터 글 작성"
                ),
                ChatMessage(sender: .user, text: "인스타 글 작성"),
                ChatMessage(
                    sender: .ai,
                    text: "요즘 폭염때문에 더워진 날씨!\n미니 선풍기로 벗어나보세요~^^",
                    showCopyButton: true
                )
            ]
        ),
        AIChatHistoryItem(
            id: "4",
            title: "강원도 축제 사업 아이디어 추천",
            lastMessagePreview: "강원도에서 이러한 축제가 열리면 어떻게 해서 이런 사업 아이템 …",
            dateText: "2026.07.13",
            messages: [
                ChatMessage(sender: .user, text: "강원도에서 이러한 축제가 열리면 어떻게 해서 이런 사업 아이템을 추천해줄 수 있어?"),
                ChatMessage(
                    sender: .ai,
                    text: "강원도 지역 축제 특성에 맞춰 굿즈, 팝업 매장, 지역 특산물 콜라보 아이템을 추천드려요!",
                    showCopyButton: true
                )
            ]
        )
    ]

    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .white
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 110
        $0.register(AIChatHistoryCell.self, forCellReuseIdentifier: AIChatHistoryCell.reuseIdentifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "AI 대화 기록"

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 마이페이지가 탭 내비게이션 바를 숨겨두기 때문에 이 화면에서는 다시 보여준다.
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension AIChatHistoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AIChatHistoryCell.reuseIdentifier, for: indexPath) as! AIChatHistoryCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
}

extension AIChatHistoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(AIChatHistoryDetailViewController(item: items[indexPath.row]), animated: true)
    }
}
