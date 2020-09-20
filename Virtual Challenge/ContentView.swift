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
    @State private var distance = ""
    @State private var update = true
    @State private var preview = true
    @State private var annotations = [MKPointAnnotation]()

    var body: some View {
    
        ZStack {
      
            VStack(alignment: .center){
                
                 
             
                mapView(challenge: $challenge, update: $update, preview: $preview, annotations: $annotations)
           
                Text(challenge.distance)
                    HStack(alignment: .top) {
                        Text("%")
                        Text("Mileage")
                    }
                    Text("Progress Charts")
        

                    .navigationBarTitle(Text(challenge.title), displayMode: .inline)
                    .navigationBarItems(leading:
                        EmptyView()
                        , trailing: Button("Edit"){
                    })
                    Spacer()
                    
                }     .frame(height:500)
                      .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
            SideMenu(width: 270,
                         isOpen: self.menuOpen,
                         menuClose: self.openMenu)
        }.onAppear(){
          
        }
            
        
            
        }
        
        
        
    

 // } delete if putting in sidemenu code
    func openMenu() {
        self.menuOpen.toggle()
    }

}

   
        struct ContentView_Previews: PreviewProvider {
            
            static var previews: some View {
                ContentView(challenge: Challenge(id: "", user: "", title: "", checkpoints: [], distance: "", completed: false, active: true))
            }
        }


