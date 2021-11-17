import Foundation
import Alamofire

class ApiClient
{
    private let queue = DispatchQueue.global(qos: .userInitiated)
    private let decoder = JSONDecoder()
    
    private var apiUrl: String
    private var tokensRepo: UserTokensRepository

    init(_ apiUrl: String, _ tokensRespo: UserTokensRepository) {
        self.apiUrl = apiUrl
        self.tokensRepo = tokensRespo
    }
    
    func get<T: Decodable>(
        _ endpoint: String,
        _ onSuccess: @escaping (T?) -> Void,
        _ onError: @escaping (ErrorDTO?) -> Void
    ) {
        let url = createUrl(endpoint)
        let headers = createHeaders()
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseJSON(queue: queue) { [weak self] response in
                self?.handleResponse(response, onSuccess, onError)
            }
    }
    
    func post<T: Decodable>(
        _ endpoint: String,
        _ body: [String: Any],
        _ onSuccess: @escaping (T?) -> Void,
        _ onError: @escaping (ErrorDTO?) -> Void
    ) {
        let url = createUrl(endpoint)
        let headers = createHeaders()
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON(queue: queue) { [weak self] response in
                self?.handleResponse(response, onSuccess, onError)
            }
    }
    
    private func createUrl(_ endpoint: String) -> URL {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = apiUrl
        components.path = "/api/v1\(endpoint)"
        
        return components.url!
    }
    
    private func createHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Accept": "application/json",
            "X-Api-Request": "true"
        ]
        
        if let token = tokensRepo.accessToken {
            headers.add(name: "Authorization", value: "Bearer \(token)")
        }
        
        return headers
    }
    
    private func handleResponse<T: Decodable, U>(
        _ response: DataResponse<U, AFError>,
        _ onSuccess: @escaping (T?) -> Void,
        _ onError: @escaping (ErrorDTO?) -> Void
    ) {
        switch response.result {
        case .success:
            let data: T? = tryParse(response.data)
            
            DispatchQueue.main.async { onSuccess(data) }
        case .failure:
            var error: ErrorDTO?
            if (response.response?.statusCode == 401) {
                error = ErrorDTO.TokenExpiredError
            } else {
                error = tryParse(response.data)
            }
            
            DispatchQueue.main.async { onError(error) }
        }
    }
    
    private func tryParse<T: Decodable>(_ data: Data?) -> T? {
        guard let data = data else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
}
