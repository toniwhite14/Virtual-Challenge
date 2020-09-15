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
  
    @EnvironmentObject var userInfo : UserInfo
    @Published var challenges : [Challenge] = []
    @Published var title = ""
   
    var ref = Firestore
        .firestore()
        .collection(FBKeys.CollectionPath.challenges)
    
    
    func getChallenges(user: String) {
        ref.whereField("user", isEqualTo: user).addSnapshotListener{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
               print("No documents")
               return
             }
             self.challenges = documents.map { queryDocumentSnapshot -> Challenge in
             //   let data = queryDocumentSnapshot.data()
               
                                let id = queryDocumentSnapshot.documentID
                                print(id)
                                let snapshot = queryDocumentSnapshot.data()
              //  self.challenges.append(Challenge(snapshot: snapshot, id: id)!)
                            return Challenge(snapshot: snapshot, id: id)!
                
             }
         }
    }
    
    
    func uploadChallenge(id: String, user: String, title: String, checkpoints: [GeoPoint], distance: String, completed: Bool, active: Bool) {
   
 
        let post = Challenge(id: id, user: user, title: title, checkpoints: checkpoints, distance: distance, completed: completed, active: active)
            ref.addDocument(data: post.toAnyObject() as! [String : Any])
 
    }
    
    func updateChallenge(id: String, user: String, title: String, checkpoints: [GeoPoint], distance: String, completed: Bool, active: Bool) {
 
        let post = Challenge(id: id, user: user, title: title, checkpoints: checkpoints, distance: distance, completed: completed, active: active)
        let docPath = ref.document(id)
        docPath.setData(post.toAnyObject() as! [String : Any])

    }
 
}
