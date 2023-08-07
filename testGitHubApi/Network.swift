//
//  Network.swift
//  testGitHubApi
//
//  Created by ALIEV Dmitry on 06.08.2023.
//

import ComposableArchitecture
import Foundation

struct GHUserClient {
    var fetchUser: @Sendable () async throws -> GHUser
    var updateBio: @Sendable (String) async throws -> GHUser
}

extension DependencyValues {
    var ghUserClient: GHUserClient {
        get { self[GHUserClient.self] }
        set { self[GHUserClient.self] = newValue }
    }
}

extension GHUserClient: DependencyKey {
    static let liveValue = Self(
        fetchUser: {
            let endpoint = "https://api.github.com/user"
            let request = try createRequest(endpoint: endpoint)
            let (data, _) = try await URLSession.shared.data(for: request)
            return try SnakecasedDecoder().decode(GHUser.self, from: data)
        },
        updateBio: { bio in
            let endpoint = "https://api.github.com/user"
            var request = try createRequest(endpoint: endpoint)
            request.httpMethod = "PATCH"
            request.httpBody = try JSONEncoder().encode(GHUserEdit(bio: bio))
            let (data, _) = try await URLSession.shared.data(for: request)
            return try SnakecasedDecoder().decode(GHUser.self, from: data)
        }
    )
    
    static let testValue = Self(
        fetchUser: unimplemented("\(Self.self).fetch"),
        updateBio: unimplemented("\(Self.self).updateBio")
    )
    
    private static func createRequest(endpoint: String) throws -> URLRequest {
        guard let url = URL(string: endpoint) else {
            throw GHError.invalidUrl
        }
        var request = URLRequest(url: url)
        return request.withAuthHeader()
    }
}

extension URLRequest {
    mutating func withAuthHeader() -> Self {
        self.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
        return self
    }
}

enum GHError: Error {
    case invalidUrl
    case unknown
}

class SnakecasedDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
