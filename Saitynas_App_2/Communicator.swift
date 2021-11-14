import Foundation

class Communicator {

    private var apiClient: ApiClient

    init(_ apiClient: ApiClient) {
        self.apiClient = apiClient
    }

    func getMessage(
        onSuccess: @escaping (MessageDto?) -> Void,
        onError: @escaping (Error?) -> Void
    ) {
        apiClient.get("", onSuccess, onError)
    }
}
