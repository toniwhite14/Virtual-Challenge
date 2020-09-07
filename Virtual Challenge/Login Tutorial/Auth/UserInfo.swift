//
//  UserInfo.swift
//  Virtual Challenge
//
//  Created by Mac on 15/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserInfo: ObservableObject {
    enum FBAuthState {
        case undefined, signedOut, signedIn
    }
    @Published var isUserAuthenticated: FBAuthState = .undefined
    @Published var user: FBUser = .init(uid: "", name: "", email: "")
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    func configureFirebaseStateDidChange() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (_, user) in
            //change _ to user if remove comments from below
            guard let _ = user else {
               self.isUserAuthenticated = .signedOut
                return
            }
        self.isUserAuthenticated = .signedIn
            //comment this out when using it on homeView
            FBFirestore.retrieveFBUser(uid: user!.uid) { (result) in
                switch result {
                case.failure(let error):
                    print(error.localizedDescription)
                case.success(let user):
                    self.user = user
                }
            } 
            
        })
        
        
    }
}
