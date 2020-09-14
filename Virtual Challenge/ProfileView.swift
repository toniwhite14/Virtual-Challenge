//
//  ProfileView.swift
//  Virtual Challenge
//
//  Created by Mac on 08/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct ProfileView: View {
    @EnvironmentObject var userInfo: UserInfo
    @ObservedObject var session = FirebaseSession()
    @State var profilePicture: WebImage = WebImage(url: URL(string: ""))
    @State var menuOpen: Bool = false
    @State var showScreen: Bool = false
    @State var challenges: [Challenge] = []
    
    var body: some View {
        NavigationView {
        ZStack {
        
        VStack {
            UserImage(profilePicture: $profilePicture)
                //would like to rezize to ?300 squared
            
            Text(userInfo.user.name)
                .font(.title)
                .fontWeight(.heavy)
            Text("Challenges currently completing:")
            //Add list
            Text("Chalenges completed:")
            //Add list
            Text("Total Mileage completed:")
            //Add Total of all challenges combined
            //?add badges for 1/3/5/10/15/20 challenges
            Button (action: {
                self.showScreen.toggle()
                }){
                Text("Create New Challenge")
                .buttonStyle(makeButtonStyle())
                .sheet(isPresented: self.$showScreen) {
                    MapTracker().environmentObject(self.userInfo)
                }
            }
            Spacer()
            VStack{
                 HStack{
                     Text("Title")
                     Spacer()
                     Text("Distance")
                     Spacer()
                     Text("Active")
                    }.padding()
                    .background(Color(.black))
                    .foregroundColor(.white)
                List(session.challenges, id: \.id) { challenge in
                    
                        ChallengeRow(challenge: challenge)
                    }
                }
            }
          
        .navigationBarTitle(Text(userInfo.user.name), displayMode: .inline)
                          .navigationBarItems(leading:
                              Button("List") {
                                  self.openMenu()
                              }
                              , trailing: Text("View"))
                              Spacer()
            }
                          
                      SideMenu(width: 270,
                                   isOpen: self.menuOpen,
                                   menuClose: self.openMenu)
            }.onAppear(){
              //  self.getChallenges(user: self.userInfo.user.uid)
                self.session.getChallenges(user: self.userInfo.user.uid)
           
            }
        }
    
    func openMenu() {
        self.menuOpen.toggle()
    }
    
/*    func getChallenges(user: String)  {
     //   var challenges: [Challenge] = []
        
            session.ref.whereField("user", isEqualTo: user).getDocuments { (querySnapshot, error) in
            if let err = error {
                       print("Error getting documents: \(err)")
                   } else {
                       for document in querySnapshot!.documents {
                            let id = document.documentID
                            print(id)
                            let snapshot = document.data()
                        self.challenges.append(Challenge(snapshot: snapshot, id: id)!)
                        
                       }
             //   self.update()
            }
            
        }
            
       
    }*/

}

struct ChallengeRow: View {
   @State var challenge: Challenge
    @ObservedObject var session = FirebaseSession()
    
    var body: some View {
        NavigationLink(destination: ContentView(challenge: challenge)) {
            HStack {
                Text(challenge.title)
                Spacer()
                Text(challenge.distance)
                Spacer()
                Toggle(isOn: $challenge.active){
                
                EmptyView()
                }.onReceive([self.challenge.active].publisher.first()) { (value) in
                 //   self.challenge.active.toggle()
                    self.session.updateChallenge(id: self.challenge.id, user: self.challenge.user, title: self.challenge.title, checkpoints: self.challenge.checkpoints, annotations: self.challenge.annotations, distance: self.challenge.distance, completed: self.challenge.completed, active: self.challenge.active)
                
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
