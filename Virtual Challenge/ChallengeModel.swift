//
//  ChallengeModel.swift
//  Virtual Challenge
//
//  Created by Nicola Grayson on 10/09/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAnalytics
import FirebaseDatabase
import MapKit



struct Challenge: Identifiable {
    @EnvironmentObject var userInfo: UserInfo
 //   var ref: DatabaseReference?
    var id: String
    var user: String
    var title: String
    var checkpoints: [GeoPoint]
    var distance: String
    var completed: Bool
    var active: Bool
    var progress: Double
    
    init(id: String, user: String, title: String, checkpoints: [GeoPoint], distance: String, completed: Bool, active: Bool, progress: Double) {
        self.id = id
     //   self.ref = nil
        self.user = user
        self.title = title
        self.checkpoints = checkpoints
        self.distance = distance
        self.completed = completed
        self.active = active
        self.progress = progress
    }
    
    init?(snapshot: [String: Any], id: String){
        
  //      guard
      //  let id = id
        var user = ""
        var title = ""
        var checkpoints : [GeoPoint] = []
   
        var distance = ""
        var completed = false
        var active = true
        var progress = 0.0
        
        for s in snapshot {
            if s.key == "user" {
                user = s.value as! String
             
            }
            if s.key == "title" {
                title = s.value as! String
               
            }
            if s.key == "checkpoints" {
                checkpoints = s.value as! [GeoPoint]
                
            }
            if s.key == "distance" {
                distance = s.value as! String
                
            }
            if s.key == "completed" {
                completed = s.value as! Bool
                
            }
            if s.key == "active" {
                active = s.value as! Bool
               
            }
            if s.key == "progress" {
                progress = s.value as! Double
               
            }
        }

      //  print("annotations: \(self.annotations)")
        //        else {
        //            return nil
        //        }
      //      self.ref = snapshot.ref
        self.id = id
        self.user = user
        self.title = title
        self.checkpoints = checkpoints
        self.distance = distance
        self.completed = completed
        self.active = active
        self.progress = progress
         //   self.id = snapshot.key
        
    }
    func toAnyObject() -> Any {
        return [
          //  "id": id,
            "user": user,
            "title": title,
            "checkpoints": checkpoints,
            "distance": distance,
            "completed": completed,
            "active": active,
            "progress": progress
        ]
    }

}
