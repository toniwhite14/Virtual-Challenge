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
    @State var update = true
    @State var preview = false
    @State var annotations = [MKPointAnnotation]()
    @Binding var challenge : Challenge
    
    var body: some View {
        ZStack {
     //   Color.black
       //     .edgesIgnoringSafeArea(.all)
        VStack(alignment: .center) {
       
       
            mapView( challenge: $challenge, update: $update, preview: $preview, annotations: $annotations)
                    .edgesIgnoringSafeArea(.top)
            

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
                           
                            Text("Save Route")
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
     //   var getCoord: [GeoPoint] = []
        challenge.checkpoints.removeAll()
        for anno in annotations {
            let coordinate = anno.coordinate
            challenge.checkpoints.append(GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        
    //    session.uploadChallenge(id: "", user: self.userInfo.user.uid, title: challenge.title, checkpoints: getCoord, distance: challenge.distance, completed: false, active: true)
        self.presentationMode.wrappedValue.dismiss()
        
    }
    
    func removeAll() {
        self.challenge.distance = "Tap map to plot route"
        self.annotations.removeAll()
  //      self.polylines.removeAll()
        
    }
    func removeLast() {
        
        if self.annotations.count > 2 {
            self.annotations.removeLast()
            
        }
        else if self.annotations.count > 0 {
            self.annotations.removeLast()
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

/*struct MapTracker_Previews: PreviewProvider {
@State var challenge = Challenge(id: "", user: "", title: "", checkpoints: [], distance: "", completed: false, active: true)
    
    static var previews: some View {
        MapTracker(challenge: $challenge)
    }
}*/

