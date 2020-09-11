//
//  FBKeys.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import Foundation
enum FBKeys {
    
    enum CollectionPath {
        static let users = "users"
        static let challenges = "Challenges"
    }
    
    enum User {
        static let uid = "uid"
        static let name = "name"
        static let email = "email"
        
        // Add app specific keys here
    }
    enum Challenge {
        static let user = "user"
        static let title = "title"
        static let checkpoints = "checkpoints"
    }
}
