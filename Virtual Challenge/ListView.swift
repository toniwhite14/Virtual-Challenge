//
//  ListView.swift
//  Virtual Challenge
//
//  Created by Mac on 08/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI

struct ListView: View {
   
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    @EnvironmentObject var userInfo : UserInfo
    
    
    var body: some View {
        HStack {
            
            NavigationView {
            List {
                
                Button(action: goMapTracker) {
                    Text("Set New Challenge")
                }
                
                Button(action: goCurrentChallengesList) {
                    Text("Current Challenges")
                }
                
                Button(action: goCompletedChallengesList) {
                    Text("Completed Challenges")
                }
                
                Button(action: goFriendsView) {
                    Text("Friends")
                }
                
                Button(action: goProfileView) {
                    Text("Profile")
                }
/*
              //  Text("Current Challenges").onTapGesture {
                //    print("Current Challenges")
                //}
                
                Text("Challenge History").onTapGesture {
                    print("Challenge History")
                }
                
                Text("Friends").onTapGesture {
                    print("Friends")
                }
                
                Text("Profile").onTapGesture {
                    print("Profile")
                } */
                
                Text("Log Out").onTapGesture {
                    print("Log Out")
                }
                
               
                /* Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Current Challenges")
                }
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Challenge History")
                }
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Friends")
                }
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Profile")
                }
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Log Out")
                } */
            }
            .navigationBarTitle(Text("Tracker Menu"))
            .frame(height:200)
            .multilineTextAlignment(.leading)
                
           /* .navigationBarItems(trailing: Button(action: {
               // self.presentationMode.wrappedValue.dismiss()
                //self.menuClose()
            }) {
                Image(systemName: "xmark.circle")
                
               // Text("Close")
                //Image("Close") APPEARS AS BLUE CIRCLE
                
            }) */
            
            
            } //NAVIGATION VIEW
        } //HSTACK
    } //BODYVIEW
 //VIEW


//TO MOVE TO MAPTRACKER
func goMapTracker() {
    if let window = UIApplication.shared.windows.first {
        window.rootViewController = UIHostingController(rootView: MapTracker().environmentObject(userInfo))
        window.makeKeyAndVisible()
    }
}

//TO MOVE TO CURRENT CHALLENGES
func goCurrentChallengesList() {
    if let window = UIApplication.shared.windows.first {
        window.rootViewController = UIHostingController(rootView: CurrentChallengesList().environmentObject(userInfo))
        window.makeKeyAndVisible()
    }
}

//TO MOVE TO COMPLETED CHALLENGES
    func goCompletedChallengesList() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: CompletedChallengesList())
        }
    }

//TO MOVE TO FRIENDSVIEW
func goFriendsView() {
    if let window = UIApplication.shared.windows.first {
        window.rootViewController = UIHostingController(rootView: FriendsView())
    }
}

//TO MOVE TO PROFILEVIEW
func goProfileView() {
    if let window = UIApplication.shared.windows.first {
        window.rootViewController = UIHostingController(rootView: ProfileView().environmentObject(userInfo))
    }
}
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

