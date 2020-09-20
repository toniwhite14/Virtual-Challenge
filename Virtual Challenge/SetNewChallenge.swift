//
//  SetNewChallenge.swift
//  Virtual Challenge
//
//  Created by Mac on 08/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI
import MapKit

struct SetNewChallenge: View {
@EnvironmentObject var userInfo : UserInfo
@ObservedObject var session = FirebaseSession()
@State var menuOpen: Bool = false
@State private var showScreen: Bool = false
@State var challenge: Challenge = Challenge(id: "", user: "", title: "", checkpoints: [], distance: "", completed: false, active: true)
@State private var update: Bool = false
@State private var preview: Bool = true
@State var annotations = [MKPointAnnotation]()
  /*  var dateRange: ClosedRange<Date> {
        //NEED TO SET UP PROFILE
           let min = Calendar.current.date(byAdding: .year, value: -1, to: profile.goalDate)!
           let max = Calendar.current.date(byAdding: .year, value: 1, to: profile.goalDate)!
           return min...max
       }
    */
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack {
                    TextField("Enter a title for your challenge", text: $challenge.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                        .border(Color.red)
                        .autocapitalization(.sentences)
                    mapView( challenge: $challenge, update: $update, preview: $preview, annotations: $annotations)
                    Button (action: {
                                   self.showScreen.toggle()
                                   }){
                                   Text("Plot Route")
                                   .buttonStyle(makeButtonStyle())
                                   .sheet(isPresented: self.$showScreen) {
                                    MapTracker(update: true, preview: false, challenge: self.$challenge ).environmentObject(self.userInfo)
                                    }}
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
        */    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Invite Friends")
            }
                Button(action: {self.save()}) {
                    Text("Save Challenge")
                }.buttonStyle(makeButtonStyle())
                    }
    }  .navigationBarTitle(Text("New Challenge"), displayMode: .inline)
                      .navigationBarItems(leading:
                      Button("Menu") {
                          self.openMenu()
                      }
                        , trailing: Button("Edit"){})
       SideMenu(width: 270,
                              isOpen: self.menuOpen,
                              menuClose: self.openMenu)
        }
    }
}
    func save() {
        session.uploadChallenge(id: "", user: self.userInfo.user.uid, title: challenge.title, checkpoints: challenge.checkpoints, distance: challenge.distance, completed: false, active: true)
        print("saving")
    }
    
    func openMenu() {
        self.menuOpen.toggle()
    }
    
}

struct SetNewChallenge_Previews: PreviewProvider {
    static var previews: some View {
        SetNewChallenge()
    }
}
