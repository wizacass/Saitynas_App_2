import Foundation
import JWTDecode

class JwtUser {
    var role: Role? {
        return jwt?.role
    }
    
    var email: String? {
        return jwt?.email
    }
    
    private var jwt: JWT?
    private var tokensRepository: UserTokensRepository
    
    private let id = UUID()
    
    init(_ tokensRepository: UserTokensRepository) {
        self.tokensRepository = tokensRepository
    }
    
    private func updateToken() {
        guard let token = tokensRepository.accessToken else { return }
        jwt = try? decode(jwt: token)
    }
}

extension JwtUser: StateObserverDelegate {
    var observerId: UUID {
        return id
    }
    
    func onLogin() {
        updateToken()
    }
    
    func onLogout() {
        updateToken()
    }
}
