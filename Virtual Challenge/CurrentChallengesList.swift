//
//  CurrentChallengesList.swift
//  Virtual Challenge
//
//  Created by Mac on 08/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI

struct CurrentChallengesList: View {
    @EnvironmentObject var userInfo: UserInfo
    @ObservedObject var session = FirebaseSession()
    @State var menuOpen: Bool = false
//    @State var challenges: [Challenge] = []
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    HStack{
                        Text("Title").bold()
                        Spacer()
                        Text("Distance").bold()
                        Spacer()
                        Text("Progress").bold()
                    }.padding()
                    VStack{
                    List(getIncompletChallenges(), id: \.id) { challenge in
            
                        ChallengeRow(challenge: challenge)
                        }}}
                    .navigationBarTitle(Text("Current Challenges"), displayMode: .inline)
        .navigationBarItems(leading: Button("Menu") {
                                      self.openMenu()}
            , trailing: Button("Add"){})
                                  Spacer()
                
                SideMenu(width: 270,
                         isOpen: self.menuOpen,
                         menuClose: self.openMenu)
                          
                    }.onAppear(){
            self.session.getChallenges(user: self.userInfo.user.uid)
            }
          
        }
        
    }
    
        func getIncompletChallenges() -> [Challenge]{
            var array : [Challenge] = []
            for challenge in session.challenges {
                if challenge.completed == false{
                    array.append(challenge)
                }
            }
            return array
        }
    
    func openMenu() {
        self.menuOpen.toggle()
    }
}

struct CurrentChallengesList_Previews: PreviewProvider {
    static var previews: some View {
        CurrentChallengesList()
    }
}
