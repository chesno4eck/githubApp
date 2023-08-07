//
//  UserModels.swift
//  testGitHubApi
//
//  Created by ALIEV Dmitry on 06.08.2023.
//

import Foundation

struct GHUser: Decodable, Equatable {
    let login: String
    let bio: String?
    let avatarUrl: String?
    let email: String?
}

struct GHUserEdit: Encodable {
    let bio: String
}
