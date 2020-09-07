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
    
    
    
    var body: some View {
        HStack {
            
            NavigationView {
            List {
                
                Button(action: goMapTracker) {
                    Text("Set New Challenge")
                }

                Text("Current Challenges").onTapGesture {
                    print("Current Challenges")
                }
                
                Text("Challenge History").onTapGesture {
                    print("Challenge History")
                }
                
                Text("Friends").onTapGesture {
                    print("Friends")
                }
                
                Text("Profile").onTapGesture {
                    print("Profile")
                }
                
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
            
            
            }
        }
}
}

//TO MOVE TO MAPTRACKER
func goMapTracker() {
    if let window = UIApplication.shared.windows.first {
        window.rootViewController = UIHostingController(rootView: MapTracker())
        window.makeKeyAndVisible()
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

