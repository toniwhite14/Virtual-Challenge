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
                        
                                let snapshot = queryDocumentSnapshot.data()
              //  self.challenges.append(Challenge(snapshot: snapshot, id: id)!)
                            return Challenge(snapshot: snapshot, id: id)!
                
             }
         }
    }
    
    
    func uploadChallenge(id: String, user: String, title: String, checkpoints: [GeoPoint], distance: String, completed: Bool, active: Bool, progress: Double) {
   
 
        let post = Challenge(id: id, user: user, title: title, checkpoints: checkpoints, distance: distance, completed: completed, active: active, progress: progress)
            ref.addDocument(data: post.toAnyObject() as! [String : Any])
 
    }
    
    func updateChallenge(challenge: String, user: String, title: String, checkpoints: [GeoPoint], distance: String, active: Bool, completed: Bool, progress: Double) {
     print("updating")
     //   let ref2 = Firestore.firestore().collection(FBKeys.CollectionPath.challenges).document(challenge.id)
        let post = Challenge(id: challenge, user: user, title: title, checkpoints: checkpoints, distance: distance, completed: completed, active: active, progress: progress).toAnyObject()
   /*     let title = ["title": title] as [String: Any]
        let checkpoints = ["checkpoints": checkpoints] as [String: Any]
        let distance = ["distance": distance] as [String: Any]
        let active = ["active": active] as [String: Any]
        let completed = ["completed": completed] as [String: Any]
       print(checkpoints)
     //   ref2.setData(post.toAnyObject()as! [String : Any], merge: false)
        
        let docPath = ref.document(challenge)
        
        docPath.updateData(title)
        docPath.updateData(checkpoints)
        docPath.updateData(distance)
        docPath.updateData(active)
        docPath.updateData(completed)*/
        ref.document(challenge).updateData(post as! [String: Any])
        

    }
 
}
