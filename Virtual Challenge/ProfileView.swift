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

struct ProfileView: View {
    @EnvironmentObject var userInfo: UserInfo
    @ObservedObject var session = FirebaseSession()
    @State var profileImage: WebImage = WebImage(url: URL(string: ""))
    @State var menuOpen: Bool = false
    @State var showScreen: Bool = false
    
    var body: some View {
        NavigationView {
        ZStack {
        
        VStack {
            UserImage(profilePicture: $profileImage)
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
          
        .navigationBarTitle(Text("Profile"), displayMode: .inline)
                          .navigationBarItems(leading:
                              Button("Menu") {
                                  self.openMenu()
                              }
                            , trailing: Button("Edit"){
                                
                          })
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

}

struct ChallengeRow: View {
   @State var challenge: Challenge
    @ObservedObject var session = FirebaseSession()
    
    var body: some View {
        NavigationLink(destination: ChallengeView(challenge: challenge)) {
      
                Text(challenge.title)
                Spacer()
                Text(challenge.distance)
                Spacer()
                Toggle(isOn: $challenge.active){
                
                EmptyView()
                
                    }.onReceive([self.challenge.active].publisher.first()) { (value) in
                 //   self.challenge.active.toggle()
                        
                        self.session.updateChallenge(challenge: self.challenge)
                
       //         }
            }
        }
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
