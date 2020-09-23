//
//  ChallengeView.swift
//  Virtual Challenge
//
//  Created by Nicola Grayson on 20/09/2020.
//  Copyright © 2020 Toni. All rights reserved.
//


import SwiftUI
import MapKit

struct ChallengeView: View {
@EnvironmentObject var userInfo : UserInfo
@ObservedObject var session = FirebaseSession()
@State var menuOpen: Bool = false
@State private var showScreen: Bool = false
@State var challenge: Challenge 
@State private var update: Bool = false
@State private var preview: Bool = true
@State var annotations = [MKPointAnnotation]()

    
    var body: some View {
    //    NavigationView {
            ZStack{
                VStack {
                //    Text(challenge.title)
                //    .bold()
                //    .padding()
                    mapView( challenge: $challenge, update: $update, preview: $preview, annotations: $annotations)
                    HStack{
                        Button (action: {
                                   self.showScreen.toggle()
                                   }){
                                   Text("Edit Route")
                                   .buttonStyle(makeButtonStyle())
                                   .sheet(isPresented: self.$showScreen) {
                                    MapTracker(update: true, preview: false, challenge: self.$challenge ).environmentObject(self.userInfo)
                                    }}
                   
                        Spacer()
                        
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                                        Text("Invite Friends")
                        }
                    }.padding()
                    Toggle("Active", isOn: $challenge.active).onTapGesture {
                         self.challenge.active.toggle()
                                               
                            self.session.updateChallenge(challenge: self.challenge.id, user: self.challenge.user, title: self.challenge.title, checkpoints: self.challenge.checkpoints, distance: self.challenge.distance, active: self.challenge.active, completed: self.challenge.completed)
                    }.padding()
                
                    Text("Insert Challenge Picture")
                .frame(height:200)
            Text("To be completed by:")
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Goal Date").bold()
      /*          DatePicker(
                    "Goal Date",
                    selection: $profile.goalDate,
                    in: dateRange,
                    displayedComponents: .date)
            }
        */
       //         Button(action: {self.save()}) {
       //             Text("Save Challenge")
       //         }.buttonStyle(makeButtonStyle())
                    }
                }  .navigationBarTitle(Text(challenge.title), displayMode: .inline)
                      .navigationBarItems(leading:
                      Button("") {
                      }
                        , trailing: Button("Edit"){self.edit()})
   //    SideMenu(width: 270,
    //                          isOpen: self.menuOpen,
   //                           menuClose: self.openMenu)
            }.onAppear() {
                
     //       }
    }
}
    func edit() {
 
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: SetNewChallenge(challenge: challenge, update: true).environmentObject(userInfo))
             window.makeKeyAndVisible()
         }
        
    }
    
    func openMenu() {
        self.menuOpen.toggle()
    }
    
}

struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView(challenge: Challenge(id: "", user: "", title: "", checkpoints: [], distance: "", completed: false, active: true))
    }
}
