//
//  MapTracker.swift
//  Virtual Challenge
//
//  Created by Mac on 06/09/2020.
//  Copyright © 2020 Toni. All rights reserved.
//
//  Created by Nicola Grayson on 01/09/2020.
//  Copyright © 2020 Nicola Grayson. All rights reserved.
//
import SwiftUI
import MapKit
import Firebase

struct MapTracker: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userInfo : UserInfo
    @ObservedObject var session = FirebaseSession()
    @State private var centreCoordinate = CLLocationCoordinate2D()
    @State private var locationManager = CLLocationManager()
    @State private var showAlert = false
    @State private var update = false
    @State var challenge: Challenge = Challenge(id: "", user: "", title: "", checkpoints: [], distance: "", completed: false, active: true)
    
    var body: some View {
        ZStack {
        Color.black
            .edgesIgnoringSafeArea(.all)
        VStack(alignment: .center) {
        //    if new == true {
            TextField("Enter a title for your challenge", text: $challenge.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .border(Color.purple)
                .autocapitalization(.sentences)
         //   }
       
            mapView( challenge: $challenge, update: $update)
                  //  .edgesIgnoringSafeArea(.top)
            

            Text(challenge.distance)
                    .font(.headline)
                    .foregroundColor(Color.white)
                    
            HStack(alignment: .center) {
                   
                    VStack(alignment: .center) {
               /*         Button(action: {self.addPin()}) {
                            Image(systemName: "plus")
                            Text("Add Pin")
                        }*/
                        Button(action: {
                            self.showAlert = true
                            }) {
                           
                            Text("Save Challenge")
                        }.buttonStyle(makeButtonStyle())
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Saving Challenge"), message: Text("Have you finshed editing your challenge route?"), primaryButton: .default(Text("Save").bold(), action: self.save), secondaryButton: .cancel())
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Button(action: {self.removeLast()}) {
                            Text("Remove last Pin")
                            Image(systemName: "minus")
                            
                        }
                        Button(action: {self.removeAll()}) {
                            Text("Remove All Pins")
                            Image(systemName: "trash")
                        
                        }
                    }
                }
                .padding()
                Spacer()

        }
        }
  
        .background(Color.black)
        
    }
   
    
    func save() {
        print("saving...")
  /*      var getCoord: [GeoPoint] = []
        for anno in challenge.annotations {
            let coordinate = anno.coordinate
            getCoord.append(GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }*/
        
        session.uploadChallenge(id: "", user: self.userInfo.user.uid, title: challenge.title, checkpoints: challenge.checkpoints, distance: challenge.distance, completed: false, active: true)
        self.presentationMode.wrappedValue.dismiss()
        
    }
    
    func removeAll() {
        self.challenge.distance = "Tap map to plot route"
        self.challenge.checkpoints.removeAll()
  //      self.polylines.removeAll()
        
    }
    func removeLast() {
        
        if self.challenge.checkpoints.count > 2 {
            self.challenge.checkpoints.removeLast()
            
        }
        else if self.challenge.checkpoints.count > 0 {
            self.challenge.checkpoints.removeLast()
            self.challenge.distance = "Tap map to plot route"
        }
        else {
            self.challenge.distance = "Tap map to plot route"
        }
    }
}
struct makeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.blue)
            .font(.headline)
            .padding(5)
            .background(Color(.green))
            .cornerRadius(10.0)
          
    }
}

struct MapTracker_Previews: PreviewProvider {
    
    static var previews: some View {
        MapTracker()
    }
}

