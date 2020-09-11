//
//  Session.swift
//  Virtual Challenge
//
//  Created by Nicola Grayson on 11/09/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MapKit

class FirebaseSession: ObservableObject {
    
    //MARK: Properties
    @Published var session: FBUser?
    @Published var isLoggedIn: Bool?
    @Published var challenges: [Challenge] = []

 //   var ref: DatabaseReference = Database.database().reference(withPath: "\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))")
   
    var ref = Firestore
        .firestore()
        .collection(FBKeys.CollectionPath.challenges)
    
 
    //MARK: Functions
    func listen() {
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.session = FBUser(uid: user.uid, name: user.displayName!, email: user.email!)
                self.isLoggedIn = true
                self.getChallenges()
            } else {
                self.isLoggedIn = false
                self.session = nil
            }
        }
    }
    
       func getChallenges() -> [Challenge] {
  /*      var challenges: [Challenge] = []
        ref.observe(DataEventType.value) { (snapshot) in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let challenge = Challenge(snapshot: snapshot) {
                    challenges.append(challenge)
                }
            }
        }
        return challenges*/
        return challenges
    }
    
    func uploadChallenge(user: String, title: String, checkpoints: [GeoPoint]) {
        //Generates number going up as time goes on, sets order of challenge's by how old they are.
        let number = Int(Date.timeIntervalSinceReferenceDate * 1000)
        
    //    let postRef = ref.child(String(number))
        let post = Challenge(user: user, title: title, checkpoints: checkpoints)
        ref.addDocument(data: post.toAnyObject() as! [String : Any])
     //   postRef.setValue(post.toAnyObject())
    }
    
    func updateChallenge(title: String, checkpoints: [GeoPoint]) {
  /*      let update = ["checkpoints": checkpoints, "title": title] as [String : Any]
        let childUpdate = ["\(session!.uid)": update]
        ref.updateChildValues(childUpdate)
         }*/}
}
