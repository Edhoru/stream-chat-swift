//
//  Member.swift
//  StreamChatCore
//
//  Created by Alexey Bukhtin on 18/04/2019.
//  Copyright © 2019 Stream.io Inc. All rights reserved.
//

import Foundation

/// A member.
public struct Member: Codable, Equatable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case user
        case role
        case created = "created_at"
        case updated = "updated_at"
        case isInvited = "invited"
        case inviteAccepted = "invite_accepted_at"
        case inviteRejected = "invite_rejected_at"
    }
    
    /// A user.
    public let user: User
    /// A role of the user.
    public let role: Role
    /// A created date.
    public let created: Date
    /// A updated date.
    public let updated: Date
    /// Checks if he was invited.
    public let isInvited: Bool
    /// A date when an invited was accepted.
    public let inviteAccepted: Date?
    /// A date when an invited was rejected.
    public let inviteRejected: Date?

    /// Init a member.
    ///
    /// - Parameters:
    ///   - user: a user.
    ///   - role: a role.
    public init(_ user: User) {
        self.user = user
        role = .member
        created = Date()
        updated = Date()
        isInvited = false
        inviteAccepted = nil
        inviteRejected = nil
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(user.id)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decode(User.self, forKey: .user)
        created = try container.decode(Date.self, forKey: .created)
        updated = try container.decode(Date.self, forKey: .updated)
        isInvited = try container.decodeIfPresent(Bool.self, forKey: .isInvited) ?? false
        inviteAccepted = try container.decodeIfPresent(Date.self, forKey: .inviteAccepted)
        inviteRejected = try container.decodeIfPresent(Date.self, forKey: .inviteRejected)
        role = try container.decodeIfPresent(Role.self, forKey: .role) ?? .member
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(user)
    }
}

public extension Member {
    /// A role.
    enum Role: String, Codable {
        case member
        case moderator
        case admin
        case owner
    }
}
