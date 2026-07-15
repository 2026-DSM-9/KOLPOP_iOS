//
//  UIViewController+DismissKeyboard.swift
//  KOLPOP_iOS
//

import UIKit

extension UIViewController {

    /// 화면의 빈 공간을 탭하면 키보드를 내리도록 한다. 버튼 등 다른 터치 동작은 막지 않는다.
    func dismissKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditingOnTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func endEditingOnTap() {
        view.endEditing(true)
    }
}
