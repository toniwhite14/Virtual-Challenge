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
    @State var profilePicture: WebImage = WebImage(url: URL(string: ""))
    @State var menuOpen: Bool = false
    @State var showScreen: Bool = false
    
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
                    MapTracker()
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
            }
        }
    }
    func openMenu() {
        self.menuOpen.toggle()
    }
}




struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
