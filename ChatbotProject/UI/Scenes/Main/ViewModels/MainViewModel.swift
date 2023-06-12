import Foundation

enum MainViewModelState {
    case ready
    case loading
    case error
}

class MainViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var state: MainViewModelState = .ready
    
    // Array containing the data used to populate the View; each element contains the data for one message (the message text and if the message was written by the user or the assistant)
    @Published var items: [MessageRowItem] = []
    
    // This array contains the entire conversation; each time the user writes a new message this conversation will be sent to the API
    @Published var messages: [Message] = [
        // Inserting a system message at the beginning of the conversation, to influence the kind of responses the language model will generate
        Message(role: "system", content: "Talk in rhyme")
    ]
    
    // Content of the message text field
    @Published var currentMessage: String = ""
    
    // MARK: - Public methods
    
    // The method to send the conversation to the API; this is called both when the user sends a new message, and when when an error occured and the message needs to be resent
    func sendMessage(isResend: Bool = false) {
        // Add the new user message if needed
        if !isResend {
            guard !currentMessage.isEmpty else { return } // Return if the message text field is empty
            messages.append(
                Message(role: "user", content: currentMessage)
            )
        }
        currentMessage = ""
        state = .loading
        // Send the conversation
        Network.fetchNextMessage(messages: messages) { response in
            switch response.result {
            case .success(let chatResponse):
                self.state = .ready
                if let message = chatResponse.choices?.first?.message {
                    // Add the newly received message
                    self.messages.append(message)
                }
            case .failure(let error):
                self.state = .error
                print(error)
            }
        }
    }
    
    // Map the array of messages to an array of MessageRowItems
    func updateItems() {
        var items = messages.compactMap { item -> MessageRowItem? in
            // Since for the Role enum we only defined the user and assistant cases, system messages will not be included in the array (and so they will not be shown to the user)
            guard let role = Role(rawValue: item.role ?? "") else { return nil }
            return MessageRowItem(
                role: role,
                message: item.content ?? ""
            )
        }
        items.insert(
            // Inserting a "faked" message; this will be shown to the user as an initial message from the chatbot
            MessageRowItem(
                role: .assistant,
                message: """
                In rhymes that dance and verses anew,
                I'm ready to converse and rhyme with you.
                """
            ),
            at: 0
        )
        self.items = items
    }
    
}
