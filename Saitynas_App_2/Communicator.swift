import Foundation

// swiftlint:disable file_length
class Communicator {

    private var apiClient: ApiClientProtocol
    private var authenticationManager: AuthenticationManager
    
    init(_ apiClient: ApiClient, _ authenticationManager: AuthenticationManager) {
        self.apiClient = apiClient
        self.authenticationManager = authenticationManager
    }
    
    func getMessage(
        onSuccess: @escaping (MessageDTO?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        apiClient.get("", onSuccess, onError: handleError)
    }
    
    func getRoles(
        onSuccess: @escaping (EnumListDTO?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        apiClient.get("/roles", onSuccess, onError: handleError)
    }
}

// MARK: - Specialists
extension Communicator {
    func getSpecialists(
        onSuccess: @escaping (SpecialistsDTO?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/specialists"
        apiClient.get(endpoint, onSuccess, onError: { [weak self] error in
            self?.retryGetRequest(endpoint, error, onSuccess, onError: handleError)
        })
    }
    
    func getSpecialist(
        _ id: Int,
        onSuccess: @escaping (SpecialistDTO?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/specialists/\(id)"
        apiClient.get(endpoint, onSuccess, onError: { [weak self] error in
            self?.retryGetRequest(endpoint, error, onSuccess, onError: handleError)
        })
    }

    func getSpecialistEvaluations(
        _ id: Int,
        onSuccess: @escaping (EvaluationsDTO?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/specialists/\(id)/evaluations"
        apiClient.get(endpoint, onSuccess, onError: { [weak self] error in
            self?.retryGetRequest(endpoint, error, onSuccess, onError: handleError)
        })
    }

    func createSpecialist(
        _ s: CreateSpecialistDTO,
        onSuccess: @escaping (NullObject?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/specialists"
        let body: [String: Any] = [
            "firstName": s.firstName,
            "lastname": s.lastName,
            "city": s.city,
            "specialityId": s.specialityId
        ]

        apiClient.post(endpoint, body, onSuccess, { [weak self] error in
            self?.retryPostRequest(endpoint, body, error, onSuccess, onError: handleError)
        })
    }
}

// MARK: - Specialities
extension Communicator {
    func getSpecialities (
        onSuccess: @escaping (EnumListDTO?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/specialities"
        apiClient.get(endpoint, onSuccess, onError: { [weak self] error in
            self?.retryGetRequest(endpoint, error, onSuccess, onError: handleError)
        })
    }
}

// MARK: - Activity Status
extension Communicator {
    func getActivityStatuses (
        onSuccess: @escaping (EnumListDTO?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/activityStatuses"
        apiClient.get(endpoint, onSuccess, onError: { [weak self] error in
            self?.retryGetRequest(endpoint, error, onSuccess, onError: handleError)
        })
    }
}

// MARK: - Patients
extension Communicator {
    func createPatient(
        _ p: Patient,
        onSuccess: @escaping (NullObject?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void) {
            let endpoint = "/patients"
            let body: [String: Any] = [
                "firstName": p.firstName,
                "lastname": p.lastName,
                "birthDate": p.birthDate,
                "city": p.city
            ]

            apiClient.post(endpoint, body, onSuccess, { [weak self] error in
                self?.retryPostRequest(endpoint, body, error, onSuccess, onError: handleError)
            })
    }
}

// MARK: - Consultations
extension Communicator {
    func requestConsultation(
        _ deviceToken: String,
        _ specialityId: Int?,
        onSuccess: @escaping (IdDto?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/consultations"
        var body: [String: Any] = [
            "deviceToken": deviceToken
        ]

        if let specialityId = specialityId {
            body["specialityId"] = specialityId
        }

        apiClient.post(endpoint, body, onSuccess, { [weak self] error in
            self?.retryPostRequest(endpoint, body, error, onSuccess, onError: handleError)
        })
    }

    func cancelConsultation(
        _ consultationId: Int,
        _ deviceToken: String,
        onSuccess: @escaping (NullObject?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/consultations/cancel"
        let body: [String: Any] = [
            "consultationId": consultationId,
            "deviceToken": deviceToken
        ]

        apiClient.post(endpoint, body, onSuccess, { [weak self] error in
            self?.retryPostRequest(endpoint, body, error, onSuccess, onError: handleError)
        })
    }

    func endConsultation(
        _ consultationId: Int,
        _ deviceToken: String,
        onSuccess: @escaping (NullObject?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/consultations/end"
        let body: [String: Any] = [
            "consultationId": consultationId,
            "deviceToken": deviceToken
        ]

        apiClient.post(endpoint, body, onSuccess, { [weak self] error in
            self?.retryPostRequest(endpoint, body, error, onSuccess, onError: handleError)
        })
    }
}

// MARK: - Workplaces
extension Communicator {
    func getWorkplaces(
        onSuccess: @escaping (WorkplacesDTO?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/workplaces"

        apiClient.get(endpoint, onSuccess, onError: { [weak self] error in
            self?.retryGetRequest(endpoint, error, onSuccess, onError: handleError)
        })
    }

    func getWorkplaceSpecialists(
        _ workplaceId: Int,
        onSuccess: @escaping (SpecialistsDTO?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/workplaces/\(workplaceId)/specialists"

        apiClient.get(endpoint, onSuccess, onError: { [weak self] error in
            self?.retryGetRequest(endpoint, error, onSuccess, onError: handleError)
        })
    }
}

// MARK: - Evaluations
extension Communicator {
    func postEvaluation(
        _ value: Int,
        _ comment: String,
        _ specialistId: Int,
        onSuccess: @escaping (NullObject?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/evaluations"

        let body: [String: Any] = [
            "value": value,
            "comment": comment,
            "specialistId": specialistId
        ]

        apiClient.post(endpoint, body, onSuccess, handleError)
    }

    func editEvaluation(
        _ id: Int,
        _ value: Int,
        _ comment: String,
        onSuccess: @escaping (NullObject?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/evaluations/\(id)"

        let body: [String: Any] = [
            "value": value,
            "comment": comment
        ]

        apiClient.put(endpoint, body, onSuccess, handleError)
    }

    func deleteEvaluation(
        _ id: Int,
        onSuccess: @escaping (NullObject?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/evaluations/\(id)"

        apiClient.delete(endpoint, onSuccess, handleError)
    }
}

// MARK: - User information
extension Communicator {
    func getMyEvaluations(
        onSuccess: @escaping (EvaluationsDTO?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/users/me/evaluations"
        apiClient.get(endpoint, onSuccess, onError: { [weak self] error in
            self?.retryGetRequest(endpoint, error, onSuccess, onError: handleError)
        })
    }

    func getMyActivityStatus (
        onSuccess: @escaping (GetEnumDTO?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/users/me/status"
        apiClient.get(endpoint, onSuccess, onError: { [weak self] error in
            self?.retryGetRequest(endpoint, error, onSuccess, onError: handleError)
        })
    }

    func updateMyActivityStatus (
        _ statusId: Int,
        onSuccess: @escaping (NullObject?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/users/me/status"
        let body: [String: Any] = [
            "specialistStatus": statusId
        ]

        apiClient.put(endpoint, body, onSuccess, { [weak self] error in
            self?.retryPutRequest(endpoint, body, error, onSuccess, onError: handleError)
        })
    }
}

// MARK: - Requests retry
extension Communicator {
    private func retryGetRequest<T: Decodable>(
        _ endpoint: String,
        _ error: ErrorDTO?,
        _ onSuccess: @escaping (T?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        if error?.type == 401 {
            authenticationManager.refreshTokens(onSuccess: { [weak self] in
                self?.apiClient.get(endpoint, onSuccess, onError: handleError)
            }, onError: handleError)
        } else {
            DispatchQueue.main.async { handleError(error) }
        }
    }

    private func retryPostRequest<T: Decodable>(
        _ endpoint: String,
        _ body: [String: Any],
        _ error: ErrorDTO?,
        _ onSuccess: @escaping (T?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        if error?.type == 401 {
            authenticationManager.refreshTokens(onSuccess: { [weak self] in
                self?.apiClient.post(endpoint, body, onSuccess, handleError)
            }, onError: handleError)
        } else {
            DispatchQueue.main.async { handleError(error) }
        }
    }

    private func retryPutRequest<T: Decodable>(
        _ endpoint: String,
        _ body: [String: Any],
        _ error: ErrorDTO?,
        _ onSuccess: @escaping (T?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        if error?.type == 401 {
            authenticationManager.refreshTokens(onSuccess: { [weak self] in
                self?.apiClient.put(endpoint, body, onSuccess, handleError)
            }, onError: handleError)
        } else {
            DispatchQueue.main.async { handleError(error) }
        }
    }
}
