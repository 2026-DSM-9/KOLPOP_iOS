//
//  Title.swift
//  KOLPOP_iOS
//
//  Created by Seoyun Jin on 7/13/26.
//

import UIKit
import SnapKit
import Then

class Title: UIView {
    func title() {
        let titleLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 32, weight: .bold)
            $0.textColor = UIColor(named: "0F1010")
            $0.text = "콜팝"
        }
        let subTitleLabel = UILabel().then {
            $0.text = "빈 건물 찾아 팝업 열기"
            $0.textColor = UIColor(named: "C6C6C7")
            $0.font = .systemFont(ofSize: 20, weight: .bold)
        }
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(206)
            $0.height.equalTo(38)
        }
        subTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.height.equalTo(24)
        }
    }
}
