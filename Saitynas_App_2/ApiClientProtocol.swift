import Foundation

protocol ApiClientProtocol {
    func get<T: Decodable>(
        _ endpoint: String,
        _ onSuccess: @escaping (T?) -> Void,
        onError: @escaping (ErrorDTO?) -> Void
    )

    func post<T: Decodable>(
        _ endpoint: String,
        _ body: [String: Any],
        _ onSuccess: @escaping (T?) -> Void,
        _ onError: @escaping (ErrorDTO?) -> Void
    )

    func delete<T: Decodable>(
        _ endpoint: String,
        _ onSuccess: @escaping (T?) -> Void,
        _ onError: @escaping (ErrorDTO?) -> Void
    )
}
