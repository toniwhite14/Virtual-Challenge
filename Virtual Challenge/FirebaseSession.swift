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
   // @Published var session: FBUser?
    @EnvironmentObject var userInfo : UserInfo
 //   @Published var isLoggedIn: Bool?
 //   @Published var challenges: [Challenge] = []

    
   
    var ref = Firestore
        .firestore()
        .collection(FBKeys.CollectionPath.challenges)
    
    

    
    func uploadChallenge(id: String, user: String, title: String, checkpoints: [GeoPoint], distance: String, completed: Bool, active: Bool) {
        //Generates number going up as time goes on, sets order of challenge's by how old they are.
    //    let number = Int(Date.timeIntervalSinceReferenceDate * 1000)
        
    //    let postRef = ref.child(String(number))
        let post = Challenge(id: id, user: user, title: title, checkpoints: checkpoints, distance: distance, completed: completed, active: active)
            ref.addDocument(data: post.toAnyObject() as! [String : Any])
     //   postRef.setValue(post.toAnyObject())
    }
    
    func updateChallenge(id: String, user: String, title: String, checkpoints: [GeoPoint], distance: String, completed: Bool, active: Bool) {
  /*      let update = ["checkpoints": checkpoints, "title": title] as [String : Any]
        let childUpdate = ["\(session!.uid)": update]
        ref.updateChildValues(childUpdate)
         }*/
        let post = Challenge(id: id, user: user, title: title, checkpoints: checkpoints, distance: distance, completed: completed, active: active)
        let docPath = ref.document(id)
     //   docPath.setValue(checkpoints, forKey: "checkpoints")
    //    docPath.setValue(distance, forKey: "distance")
    //    docPath.setValue(completed, forKey: "completed")
    //    docPath.setValue(active, forKey: "active")
    }
}
