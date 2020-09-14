//
//  ContentView.swift
//  Virtual Challenge
//
//  Created by Mac on 05/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI
import MapKit
import Firebase

struct ContentView: View {
    @ObservedObject var session = FirebaseSession()
    @EnvironmentObject var userInfo : UserInfo
    @State var menuOpen: Bool = false
    @State var challenge: Challenge
 //   @State var checkpoints : [GeoPoint] = []
  //  @State var annotations : [MKPointAnnotation]
    @State private var distance = ""
    @State private var update = true

    var body: some View {
    
        ZStack {
      
            VStack(alignment: .center){
                
                  //  mapView(checkpoints: session.challengeForUpdate.checkpoints, theDistance: session.challengeForUpdate.distance)
               // MapTracker()
             
                mapView(challenge: $challenge, update: $update)
             //   Spacer()  ?needed
                
            //    VStack(alignment: .center) {
                    Text("Summary")
                    HStack(alignment: .top) {
                        Text("%")
                        Text("Mileage")
                    }
                    Text("Progress Charts")
            //        }
            
           //     .padding()
          //      .offset(y: -70) //sets height for bottom VStack.

                    .navigationBarTitle(Text(challenge.title), displayMode: .inline)
                    .navigationBarItems(leading:
                    Button("Menu") {
                        self.openMenu()
                    }
                    , trailing: Text("View"))
                    Spacer()
                    
                }     .frame(height:500)
                      .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
            SideMenu(width: 270,
                         isOpen: self.menuOpen,
                         menuClose: self.openMenu)
        }.onAppear(){
          
           // print("annotations: \(self.challenge.annotations)")
        }
            
        
            
        }
        
        
        
    

 // } delete if putting in sidemenu code
    func openMenu() {
        self.menuOpen.toggle()
    }

}

   
        


