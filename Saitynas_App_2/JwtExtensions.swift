import JWTDecode

extension JWT {
    var email: String? {
        return claim(name: "email").string
    }

    var role: Role? {
        guard let roleClaim = claim(name: "role").string else { return nil }

        return Role(rawValue: roleClaim)
    }
}
