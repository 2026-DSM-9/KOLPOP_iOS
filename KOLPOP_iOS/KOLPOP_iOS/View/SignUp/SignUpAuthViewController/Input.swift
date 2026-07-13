//
//  Input.swift
//  KOLPOP_iOS
//
//  Created by Seoyun Jin on 7/13/26.
//

import UIKit
import SnapKit
import Then

class Input: UIView {
    func inputView() {
        let phoneTitle = UILabel().then {
            $0.text = "전화번호"
            $0.textColor = UIColor(named: "A3A4A5")
            $0.font = .systemFont(ofSize: 16, weight: .regular)
        }
        let phoneTextField = UITextField().then {
            $0.textColor = UIColor(named: "0F1010")
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.attributedPlaceholder = NSAttributedString(
                string: "전화번호를 입력 해 주세요",
                attributes: [.foregroundColor: UIColor(named: "D9D9D9")!]
            )
            $0.layer.borderColor = UIColor(named: "D9D9D9")!.cgColor
            $0.layer.cornerRadius = 25
        }
        let codeTitle = UILabel().then {
            $0.text = "인증코드"
            $0.textColor = UIColor(named: "A3A4A5")
            $0.font = .systemFont(ofSize: 16, weight: .regular)
        }
        let codeTextField = UITextField().then {
            $0.textColor = UIColor(named: "0F1010")
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.attributedPlaceholder = NSAttributedString(
                string: "인증코드를 입력해주세요",
                attributes: [.foregroundColor: UIColor(named: "D9D9D9")!]
            )
            $0.layer.borderColor = UIColor(named: "D9D9D9")!.cgColor
            $0.layer.cornerRadius = 25
        }
        
        [phoneTitle, phoneTextField, codeTitle, codeTextField].forEach {
            self.addSubview($0)
        }
        phoneTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(34)
            $0.height.equalTo(19)
        }
        phoneTextField.snp.makeConstraints {
            $0.leading.trailing.equalTo(34)
            $0.top.equalTo(phoneTitle.snp.bottom).offset(12)
            $0.height.equalTo(52)
        }
        codeTitle.snp.makeConstraints {
            $0.top.equalTo(phoneTextField.snp.bottom).offset(44)
            $0.leading.equalTo(34)
            $0.height.equalTo(19)
        }
        codeTextField.snp.makeConstraints {
            $0.leading.trailing.equalTo(34)
            $0.top.equalTo(codeTitle.snp.bottom).offset(12)
            $0.height.equalTo(52)
        }
    }
}
