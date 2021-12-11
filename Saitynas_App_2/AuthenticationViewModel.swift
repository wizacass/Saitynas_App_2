import Foundation

class AuthenticationViewModel {
    func validateEmail(_ email: String?) -> String? {
        guard let email = email else { return "generic_error" }
        if email.isEmpty { return "Email cannot be empty" }
        if !email.isEmail { return "Incorrect email format!" }

        return nil
    }

    func validatePassword(_ password: String?) -> String? {
        guard let password = password else { return "generic_error" }
        if password.isEmpty { return "Password cannot be empty!" }

        return nil
    }

    func validateNewPassword(_ password: String?) -> String? {
        guard let password = password else { return "generic_error" }

        if password.isEmpty { return "Password cannot be empty!" }

        if password.count < 8 {
            return "Password should be at least 8 characters long!"
        }

        if !password.hasUppercase {
            return "Password should have at least one uppercase letter!"
        }

        if !password.hasNumber {
            return "Password should contain at least 1 number!"
        }

        return nil
    }
}
