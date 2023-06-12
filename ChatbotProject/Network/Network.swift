import Foundation
import Alamofire

class Network {
    
    typealias FetchNextMessageHandler = (DataResponse<ChatResponse, AFError>) -> Void
    
    @discardableResult
    static func fetchNextMessage(messages: [Message], handler: @escaping FetchNextMessageHandler) -> DataRequest {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else { fatalError("API key missing") }
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        var parameters = Parameters()
        parameters["model"] = "gpt-3.5-turbo"
        parameters["messages"] = messages.map { message in
            ["role": message.role ?? "", "content": message.content ?? ""]
        }
        
        let headers = HTTPHeaders([
            .authorization("Bearer \(apiKey)"),
            .contentType("application/json")
        ])
        
        return AF
            .request(
                url,
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers
            )
            .validate()
            .responseDecodable(of: ChatResponse.self, completionHandler: handler)
    }
}
