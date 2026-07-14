//
//  AIChatHistoryDetailViewController.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class AIChatHistoryDetailViewController: UIViewController {

    private let item: AIChatHistoryItem

    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .white
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 120
        $0.register(AIMessageCell.self, forCellReuseIdentifier: AIMessageCell.reuseIdentifier)
        $0.register(UserMessageCell.self, forCellReuseIdentifier: UserMessageCell.reuseIdentifier)
    }

    init(item: AIChatHistoryItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = item.title

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

extension AIChatHistoryDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        item.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = item.messages[indexPath.row]
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

extension AIChatHistoryDetailViewController: UITableViewDelegate {}
