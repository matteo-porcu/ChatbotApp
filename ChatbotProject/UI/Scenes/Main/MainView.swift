import SwiftUI

struct MainView: View {
    
    // MARK: - ViewModel

    @ObservedObject var viewModel = MainViewModel()

    // MARK: - Body
    
    var body: some View {
        VStack {
            List(viewModel.items, id: \.self) { item in
                MessageRow(args: item)
            }
            .listStyle(.plain)
            Spacer()
            switch viewModel.state {
            case .ready:
                // If the user can send a new message, show the text field and the "Send" button
                HStack {
                    TextField("", text: $viewModel.currentMessage)
                        .textFieldStyle(.roundedBorder)
                    Spacer()
                    Button {
                        viewModel.sendMessage()
                    } label: {
                        Text("Send")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.buttonBackground)
                            .cornerRadius(16)
                    }
                }
                .padding()
            case .loading:
                // If the app is waiting for a response from the API, show a ProgressView
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            case .error:
                // If the last request failed, show the "Resend" button
                Button {
                    viewModel.sendMessage(isResend: true)
                } label: {
                    Text("Resend")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.buttonBackground)
                        .cornerRadius(16)
                }
                .padding()
            }
        }
        // Update the items array when the view appears (this will trigger the List to update to show the the current messages)
        .onAppear {
            viewModel.updateItems()
        }
        // Update the items array when a message is added to the messages array (this will trigger the List to update to show the the current messages)
        .onChange(of: viewModel.messages) { _ in
            viewModel.updateItems()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
