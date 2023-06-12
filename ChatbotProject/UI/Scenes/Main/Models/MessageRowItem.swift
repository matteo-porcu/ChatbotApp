import SwiftUI

struct MessageRowItem: Hashable {
    let role: Role
    let message: String
    
    var color: Color {
        switch role {
        case .user:
            return Color.userMessageBackground
        case .assistant:
            return Color.assistantMessageBackground
        }
    }
}

enum Role: String {
    case user
    case assistant
}
