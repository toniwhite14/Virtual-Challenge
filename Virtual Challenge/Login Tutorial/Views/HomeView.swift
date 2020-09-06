//
//  HomeView.swift
//  Virtual Challenge
//
//  Created by Mac on 15/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var userInfo: UserInfo
    @State var menuOpen: Bool = false
        
        
    var body: some View {
        NavigationView {
            ZStack {
          
                VStack {
        UserImage()
        Text("Logged in as \(userInfo.user.name)")
            .navigationBarTitle("Virtual Challenge")
            .navigationBarItems(leading:
                Button("List") {
                    self.openMenu()
                }
                  /* NEED TO SORT IMAGE
                    Image("List")
                    .resizable()
                    .frame(width: 10)
                } */
               
                
                
                
            , trailing:
                     Button("Log out") {
                FBAuth.logout { (result) in
                    print("Logged out")
                }
            
                //self.userInfo.isUserAuthenticated = .signedOut
                    }
                )
                
            }
                    SideMenu(width: 270,
                                 isOpen: self.menuOpen,
                                 menuClose: self.openMenu)
                    }
                
                
                    
            .onAppear {
                guard let uid = Auth.auth().currentUser?.uid else {
                    return
                }
               FBFirestore.retrieveFBUser(uid: uid) { (result) in
                    switch result {
                    case.failure(let error):
                        print(error.localizedDescription)
                        //Display some kind of alert to your user here. (it shouldn't happen but it might be worth making!)
                    case.success(let user):
                        self.userInfo.user = user
                    }
                }
            }
        }
        
}
    func openMenu() {
        self.menuOpen.toggle()
    }
}



//NEED TO RETRIVE PICTURE FROM USER
struct UserImage : View {
    var body: some View {
        return Image("Face")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .overlay(Circle().stroke(Color.gray, lineWidth: 4))
            .shadow(radius: 10)
            .padding(.bottom, 75)
    }
}

  

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
