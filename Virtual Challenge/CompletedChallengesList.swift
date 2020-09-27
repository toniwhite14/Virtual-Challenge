//
//  CompletedChallengesList.swift
//  Virtual Challenge
//
//  Created by Mac on 08/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI

struct CompletedChallengesList: View {
    @EnvironmentObject var userInfo: UserInfo
    @ObservedObject var session = FirebaseSession()
    @State var menuOpen: Bool = false
    
    var body: some View {
        NavigationView {
        ZStack{
            VStack{
                HStack{
                    Text("Title").bold()
                    Spacer()
                    Text("Distance").bold()
                    Spacer()
                    Text("Active").bold()
                }.padding()
                VStack{
                    List(getCompletedChallenges(), id: \.id) { challenge in
                   
                        ChallengeRow(challenge: challenge)
                        }
                    
                    }
                
                }
        
        .navigationBarTitle(Text("Current Challenges"), displayMode: .inline)
        .navigationBarItems(leading: Button("Menu") { self.openMenu()}
                   , trailing: Button("Add"){})
                    //Spacer()
                       SideMenu(width: 270,
                                isOpen: self.menuOpen,
                                menuClose: self.openMenu)
                                 
                           }.onAppear(){
                   self.session.getChallenges(user: self.userInfo.user.uid)
                   }
                }
        }
               
    func getCompletedChallenges() -> [Challenge]{
        var array : [Challenge] = []
        for challenge in session.challenges {
            if challenge.completed {
                array.append(challenge)
            }
        }
        return array
    }
    
    func openMenu() {
        self.menuOpen.toggle()
    }
}

struct CompletedChallengesList_Previews: PreviewProvider {
    static var previews: some View {
        CompletedChallengesList()
    }
}
