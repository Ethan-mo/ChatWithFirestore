//
//  ConversationViewModel.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/04/05.
//

import Foundation

struct ConversationViewModel {
    private let conversation: Conversation
    
    var timestamp: String {
        let date = conversation.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    init(conversation: Conversation) {
        self.conversation = conversation
    }
}
