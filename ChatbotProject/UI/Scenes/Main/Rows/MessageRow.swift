import SwiftUI

struct MessageRow: View {
    
    // MARK: - Properties
    
    // The data to populate the MessageRow
    var args: MessageRowItem
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            if args.role == .user {
                Spacer(minLength: 50)
            }
            Text(args.message)
                .padding()
                .background(args.color)
                .cornerRadius(16)
            if args.role == .assistant {
                Spacer(minLength: 50)
            }
        }
        .padding()
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
    }
}

struct MessageRow_Previews: PreviewProvider {
    static var previews: some View {
        MessageRow(args: MessageRowItem(
            role: .user,
            message: "Test message"
        ))
    }
}
