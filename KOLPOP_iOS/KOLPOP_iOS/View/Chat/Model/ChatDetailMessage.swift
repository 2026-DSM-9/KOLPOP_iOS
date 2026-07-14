//
//  ChatDetailMessage.swift
//  KOLPOP_iOS
//

import UIKit

struct ChatDetailMessage {
    enum Sender {
        case me
        case other
    }

    enum Content {
        /// 데모용 목업 메시지에서 사용하는 로컬 에셋 이미지
        case image(String)
        /// 사용자가 사진 피커로 직접 선택해 보낸 이미지
        case pickedImage(UIImage)
        case text(String)
    }

    let sender: Sender
    let content: Content
    let timestamp: String
}
