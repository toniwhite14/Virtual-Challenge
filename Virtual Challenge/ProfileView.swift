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
import FirebaseStorage
import MapKit

struct ProfileView: View {
    @EnvironmentObject var userInfo: UserInfo
    @ObservedObject var session = FirebaseSession()
    @State var profileImage: WebImage = WebImage(url: URL(string: ""))
    @State var menuOpen: Bool = false
    @State var showScreen: Bool = false
//    @State var totalDistance = ""
    
    var body: some View {
        NavigationView {
        ZStack {
        
        VStack {
            UserImage(profilePicture: $profileImage)
                //would like to rezize to ?300 squared
            
            Text(userInfo.user.name)
                .font(.title)
                .fontWeight(.heavy)
            
            //Add list
            Text("Total distance completed:")
            Text(getDistance())
            //Add Total of all challenges combined
            //?add badges for 1/3/5/10/15/20 challenges
        /*    Button (action: {
                self.showScreen.toggle()
                }){
                Text("Create New Challenge")
                .buttonStyle(makeButtonStyle())
                .sheet(isPresented: self.$showScreen) {
                    MapTracker()
                }
            }*/
            Spacer()
            VStack{
                 HStack{
                    Spacer()
                    Text("Current Challenges:").bold()
                    Spacer()
                    
                    }.padding()
                    .background(Color(.black))
                    .foregroundColor(.white)
               
                List(getActiveChallanges(), id: \.id) { challenge in
                    
                        ChallengeRow(challenge: challenge)
                    }
                HStack{
                    Spacer()
                    Text("Completed Challanges")
                    Spacer()
               /*  Text("Title")
                 Spacer()
                 Text("Distance")
                 Spacer()
                 Text("Active")*/
                }.padding()
                .background(Color(.black))
                .foregroundColor(.white)
                List(getCompletedChallenges(), id: \.id) { challenge in
                        ChallengeRow(challenge: challenge)
                    }
                }
            }
          
        .navigationBarTitle(Text("Profile"), displayMode: .inline)
                          .navigationBarItems(leading:
                              Button("Menu") {
                                  self.openMenu()
                              }
                            , trailing: Button(action: {
                                
                            },label: {
                                Image(systemName: "gear")
                                .imageScale(.large)
                                .frame(width: 44, height: 44, alignment: .trailing)
                                
                            }))
                              Spacer()
            
                          
                      SideMenu(width: 270,
                                   isOpen: self.menuOpen,
                                   menuClose: self.openMenu)
            }.onAppear(){
                self.image()
                self.session.getChallenges(user: self.userInfo.user.uid)
            
            }}
        }

    
    func openMenu() {
        self.menuOpen.toggle()
    }
    
    func getDistance() -> String {
        let formatter = MKDistanceFormatter()
        formatter.units = .imperial
        formatter.unitStyle = .full
        var progress = 0.0
        for challenge in session.challenges {
            progress += challenge.progress
        }
        
        return formatter.string(fromDistance: progress)
    }
    func image() {
         guard let uid = Auth.auth().currentUser?.uid else {
             return
         }
         let image = "\(uid)"
         let storage = Storage.storage().reference(withPath: image)
         storage.downloadURL{(url, err) in
                if err != nil {
                    print(err?.localizedDescription as Any)
                    let noImage = "NoUserImage2.png"
                    let storage2 = Storage.storage().reference(withPath: noImage)
                    storage2.downloadURL{(url, err) in
                        if err != nil {
                            print(err?.localizedDescription as Any)
                            return
                        }
                        let theurl = url
                        self.profileImage = WebImage(url: theurl)
                    return
                    }}
                else {
                    let theurl = url
                    self.profileImage = WebImage(url: theurl)
                    
                }
         }
     
     }
    func getActiveChallanges() -> [Challenge]{
        var array : [Challenge] = []
        for challenge in session.challenges {
            if challenge.completed == false {
                array.append(challenge)
            }
        }
        return array
        
    }
    func getCompletedChallenges() -> [Challenge]{
        var array : [Challenge] = []
        for challenge in session.challenges {
            if challenge.completed{
                array.append(challenge)
            }
        }
        return array
    }
}

struct ChallengeRow: View {
   @State var challenge: Challenge
    @ObservedObject var session = FirebaseSession()
    
    var body: some View {
        NavigationLink(destination: ChallengeView(challenge: $challenge)) {
      
                Text(challenge.title)
                Spacer()
                Text(challenge.distance)
                Spacer()
                ProgressBar(challenge: $challenge)
            .frame(width: 50, height: 50)
     /*           Toggle(isOn: $challenge.active){
                
                EmptyView()
                
                }.onTapGesture {
                    
                //.onReceive([self.challenge.active].publisher.first()) { (value) in
                    self.challenge.active.toggle()
                        
                    self.session.updateChallenge(challenge: self.challenge.id, user: self.challenge.user, title: self.challenge.title, checkpoints: self.challenge.checkpoints, distance: self.challenge.distance, active: self.challenge.active, completed: self.challenge.completed, progress: self.challenge.progress)
            
       //         }
            }*/
        }
    }
    
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
