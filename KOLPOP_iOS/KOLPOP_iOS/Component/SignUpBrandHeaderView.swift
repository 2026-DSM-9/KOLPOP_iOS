//
//  SignUpBrandHeaderView.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class SignUpBrandHeaderView: UIView {

    private let titleLabel = UILabel().then {
        $0.text = "콜팝"
        $0.font = .paperlogy(.bold, size: 28)
        $0.textColor = UIColor(named: "0F1010")
        $0.textAlignment = .center
    }

    private let subtitleLabel = UILabel().then {
        $0.text = "빈 건물 찾아 팝업 열기"
        $0.font = .paperlogy(.semiBold, size: 17)
        $0.textColor = UIColor(named: "C6C6C7")
        $0.textAlignment = .center
    }

    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        [titleLabel, subtitleLabel].forEach { addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
