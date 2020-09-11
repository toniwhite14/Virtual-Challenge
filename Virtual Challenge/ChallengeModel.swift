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

/*class ChallengeModel: ObservableObject {
    
    @Published var challenge: Challenge
    @Published var challenges: [Challenge]
    @Published var modified = false
    private var cancellables = Set<AnyCancellable>()
    
    init(challenge: Challenge = Challenge(user: "", title: "", checkpoints: [])) {
        self.challenge = challenge
        
        self.$challenge
        .dropFirst()
            .sink { [weak self] challenge in
                self?.modified = true
        }
        .store(in: &self.cancellables)
    }
    
    private var db = Firestore.firestore()
    func fetchData() {
        db.collection("Challenges").addSnapshotListener{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.challenges = documents.compactMap {queryDocumentSnapshot -> Challenge in
                let data = queryDocumentSnapshot.data()
                let user = data["user"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let checkpoints = data["checkpoints"] as? [CLLocationCoordinate2D] ?? []
                return Challenge(user: user, title: title, checkpoints: checkpoints)
            
            }
        }
    }
    func addChallenge(_ challenge: Challenge) {
        do {
            
            let _ = try db.collection("Challenges").addDocument(data: challenge)
        }
        catch {
            print(error)
        }
    }
    
}*/


struct Challenge: Identifiable {
    @EnvironmentObject var userInfo: UserInfo
    var ref: DatabaseReference?
    var id: String
  //  var user: String
    var title: String
    var checkpoints: [GeoPoint]
    
    init(user: String, title: String, checkpoints: [GeoPoint]) {
        self.id = user
        self.ref = nil
      //  self.user = user
        self.title = title
        self.checkpoints = checkpoints
    }
    
    init?(snapshot: DataSnapshot){
        
        guard
                let value = snapshot.value as? [String: AnyObject],
                let title = value["title"] as? String,
                let id = value["user"] as? String,
                let checkpoints = value["checkpoints"] as? [GeoPoint]
                else {
                    return nil
                }
            self.ref = snapshot.ref
            self.id = id
            self.title = title
            self.checkpoints = checkpoints
         //   self.id = snapshot.key
        
    }
    func toAnyObject() -> Any {
        return [
            "user": id,
            "title": title,
            "checkpoints": checkpoints,
        ]
    }

}
