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
                ),
                ChatMessage(sender: .user, text: "AI 파트너야 고마워!")
            ]
        ),
        AIChatHistoryItem(
            id: "1",
            title: "홍대 유동인구 많은 1층 매물",
            lastMessagePreview: "네, 마음에 드는 매물이 있으면 상세 화면에서 문의해보세요!",
            dateText: "2026.07.12",
            messages: [
                ChatMessage(
                    sender: .ai,
                    text: "안녕하세요! 콜팝 AI 파트너예요.\n원하시는 지역이나 조건을 말씀해주시면 딱 맞는 매물을 추천해드릴게요!\n\nex. 유동인구 많은 1층 매물 찾아줘"
                ),
                ChatMessage(sender: .user, text: "홍대 근처 유동인구 많은 1층 매물 찾아줘"),
                ChatMessage(
                    sender: .ai,
                    text: "홍대입구역 인근 1층 매물을 찾아봤어요!\n\n📍 서울 마포구 홍대 인근\n- 유동인구 많은 메인 상권\n- 보증금 800만원 / 일 25만원",
                    showCopyButton: true
                ),
                ChatMessage(sender: .user, text: "네, 마음에 드는 매물이 있으면 상세 화면에서 문의해보세요!")
            ]
        ),
        AIChatHistoryItem(
            id: "2",
            title: "강원도 축제 사업 아이디어 추천",
            lastMessagePreview: "강원도에서 이러한 축제가 열리면 어떻게 해서 이런 사업 아이템 …",
            dateText: "2026.07.11",
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
            title: "겨울 시즌 팝업스토어 홍보 문구",
            lastMessagePreview: "포스터 문구도 같이 만들어줘서 정말 도움됐어요!",
            dateText: "2026.07.10",
            messages: [
                ChatMessage(
                    sender: .ai,
                    text: "안녕하세요! 콜팝 AI 파트너예요.\n원하시는 사업 아이템과 마케팅 종류를 말하시면 그에 맞는 글을 추천해드릴게요!\n\nex. 인스타 글 작성, 태그추천, 포스터 글 작성"
                ),
                ChatMessage(sender: .user, text: "겨울 시즌 팝업스토어 홍보 문구랑 포스터 문구 만들어줘"),
                ChatMessage(
                    sender: .ai,
                    text: "❄️ 인스타그램 게시글\n\"이 겨울, 단 2주만 만나는 특별한 공간 ☃️\n따뜻한 감성 가득한 팝업스토어에 놀러오세요!\"\n\n#겨울팝업 #한정팝업스토어\n\n📋 포스터 문구\n\"WINTER ONLY POPUP\n12.20 - 1.3 단 15일간\"",
                    showCopyButton: true
                ),
                ChatMessage(sender: .user, text: "포스터 문구도 같이 만들어줘서 정말 도움됐어요!")
            ]
        ),
        AIChatHistoryItem(
            id: "4",
            title: "대학가 상권 소품샵 아이템 추천",
            lastMessagePreview: "타겟 고객층까지 짚어주셔서 참고하기 좋았어요",
            dateText: "2026.07.09",
            messages: [
                ChatMessage(sender: .user, text: "대학가 근처 팝업으로 어떤 아이템이 좋을까?"),
                ChatMessage(
                    sender: .ai,
                    text: "대학가 상권 특성을 고려한 추천이에요!\n\n💡 추천 아이템: 캐릭터 소품샵 / 폴라로이드 포토부스\n- 20대 초반 타겟, 사진 찍기 좋은 포토존 활용\n- 낮은 초기비용으로 짧은 팝업 운영에 적합",
                    showCopyButton: true
                ),
                ChatMessage(sender: .user, text: "타겟 고객층까지 짚어주셔서 참고하기 좋았어요")
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
