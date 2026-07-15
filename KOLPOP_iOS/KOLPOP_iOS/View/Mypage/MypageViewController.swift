//
//  MypageViewController.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class MypageViewController: UIViewController {

    private let myPageService = MyPageService()
    private let authService = AuthService()
    private var profile = UserProfile.mock
    private let loadingOverlayView = LoadingOverlayView(message: "내 정보를 불러오는 중이에요")

    private let titleLabel = UILabel().then {
        $0.text = "마이페이지"
        $0.font = .paperlogy(.semiBold, size: 24)
        $0.textColor = UIColor(named: "0F1010")
    }

    private let profileCardView = UIView().then {
        $0.backgroundColor = UIColor(named: "002C3C")
        $0.layer.cornerRadius = 16
    }

    private let nameLabel = UILabel().then {
        $0.font = .paperlogy(.bold, size: 22)
        $0.textColor = .white
    }

    private let phoneLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 16)
        $0.textColor = UIColor.white.withAlphaComponent(0.85)
    }

    private let editButton = UIButton(type: .system).then {
        $0.setTitle("수정", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .paperlogy(.semiBold, size: 14)
        $0.backgroundColor = UIColor(named: "004660")
        $0.layer.cornerRadius = 16
    }

    private lazy var likedListingsRow = MenuRowView(
        iconName: "heart",
        title: "찜한 매물",
        subtitle: "관심 등록한 빈 건물 등록"
    )

    private lazy var aiHistoryRow = MenuRowView(
        iconName: "sparkles",
        title: "AI 대화 기록",
        subtitle: "관심 등록한 빈 건물 등록"
    )

    private lazy var logoutRow = MenuRowView(
        iconName: "rectangle.portrait.and.arrow.right",
        title: "로그아웃",
        subtitle: nil,
        tintColorName: "EA8C21"
    )

    private lazy var withdrawRow = MenuRowView(
        iconName: "person.fill.xmark",
        title: "회원탈퇴",
        subtitle: nil,
        tintColorName: "EA8C21"
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupLayout()
        configure()
        setupActions()
        fetchMyPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        // 수정 화면에서 돌아왔을 때 변경된 이름을 바로 반영하기 위함
        configure()
    }

    private func setupLayout() {
        profileCardView.addSubview(nameLabel)
        profileCardView.addSubview(phoneLabel)
        profileCardView.addSubview(editButton)

        [titleLabel, profileCardView, likedListingsRow, aiHistoryRow, logoutRow, withdrawRow, loadingOverlayView].forEach {
            view.addSubview($0)
        }

        loadingOverlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(20)
        }
        profileCardView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        editButton.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(60)
            make.height.equalTo(32)
        }
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }

        likedListingsRow.snp.makeConstraints { make in
            make.top.equalTo(profileCardView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        aiHistoryRow.snp.makeConstraints { make in
            make.top.equalTo(likedListingsRow.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        logoutRow.snp.makeConstraints { make in
            make.top.equalTo(aiHistoryRow.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        withdrawRow.snp.makeConstraints { make in
            make.top.equalTo(logoutRow.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func fetchMyPage() {
        myPageService.fetchMyPage { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.loadingOverlayView.isHidden = true
                switch result {
                case .success(let myPage):
                    self.profile = UserProfile(name: myPage.name, phoneNumber: myPage.phone, email: myPage.email, introduction: myPage.introduction)
                    self.configure()
                case .failure(let error):
                    print("마이페이지 조회 실패: \(error)")
                }
            }
        }
    }

    private func configure() {
        nameLabel.text = profile.name
        phoneLabel.text = profile.phoneNumber
    }

    private func setupActions() {
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        likedListingsRow.onTap = { [weak self] in
            self?.navigationController?.pushViewController(LikedListingsViewController(), animated: true)
        }
        aiHistoryRow.onTap = { [weak self] in
            self?.navigationController?.pushViewController(AIChatHistoryViewController(), animated: true)
        }
        logoutRow.onTap = { [weak self] in
            self?.confirmLogout()
        }
        withdrawRow.onTap = { [weak self] in
            self?.confirmWithdraw()
        }
    }

    @objc private func editTapped() {
        let editViewController = ProfileEditViewController(profile: profile) { [weak self] updatedProfile in
            self?.profile = updatedProfile
            self?.configure()
        }
        navigationController?.pushViewController(editViewController, animated: true)
    }

    private func confirmLogout() {
        let alert = UIAlertController(title: nil, message: "정말 로그아웃 할까요?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        present(alert, animated: true)
    }

    private func performLogout() {
        authService.logout { result in
            if case let .failure(error) = result {
                print("로그아웃 API 실패(로컬 로그아웃은 계속 진행): \(error)")
            }
            DispatchQueue.main.async {
                TokenStore.shared.accessToken = nil
                TokenStore.shared.currentUserId = nil
                self.moveToLoginScreen()
            }
        }
    }

    private func moveToLoginScreen() {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first
        else { return }

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.rootViewController = UINavigationController(rootViewController: LoginViewController())
        }
    }

    private func confirmWithdraw() {
        let alert = UIAlertController(title: nil, message: "정말 회원탈퇴 할까요?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "탈퇴", style: .destructive) { _ in
            // TODO: 실제 회원탈퇴 API 연동 예정
        })
        present(alert, animated: true)
    }
}
