//
//  SubmitProgress.swift
//  Virtual Challenge
//
//  Created by Mac on 08/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI
import MapKit

struct SubmitProgress: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userInfo : UserInfo
    @State var input: String = ""
    @ObservedObject var session = FirebaseSession()
    @Binding var challenge: Challenge
    @State private var showingAlert = false
    //var constant = "text"
    
    var body: some View {
        VStack {
        Text("Input New Distance:")
            HStack {
                TextField("Input Distance", text: $input)
            .frame(height:50)
                Text("unit")
            }
        .padding()
            Text("How was this achieved?")
            Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: Text("Activity")) {
                Text("Walk (indoors)").tag(1)
                Text("Walk (outdoors").tag(2)
                Text("Run (indoors)").tag(3)
                Text("Run (outdoors)").tag(4)
                Text("Bike (static)").tag(5)
                Text("Bike (outdoors)").tag(6)
                Text("Row (indoors)").tag(7)
                Text("Row (outdoors)").tag(8)
                
            }
            Button(action: self.save) {
                Text("Submit")
            }

        }.alert(isPresented: $showingAlert) { () -> Alert in
            let primaryButton = Alert.Button.default(Text("Share").bold()) {
                actionSheet()
            }
            let secondaryButton = Alert.Button.default(Text("Dismiss")) {
            
            }
            return Alert(title: Text("Congratulations"), message: Text("You have now completed this challenge!"), primaryButton: primaryButton, secondaryButton: secondaryButton)
        }
        
    }
    func actionSheet() {
        let data = [challenge.title, challenge.distance]
            let av = UIActivityViewController(activityItems: data, applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        }
    func save() {
        var total: Double = 0.0
        let formatter = MKDistanceFormatter()
                  formatter.units = .imperial
        let input = formatter.distance(from: self.input)
        let milage = CLLocationDistance(self.challenge.progress)
        total = Double(Float(milage)+Float(input))
        self.challenge.progress = total
        var distance: CLLocationDistance = 0
        if self.challenge.distance != "" {
            let string = self.challenge.distance.components(separatedBy: ",").joined()
            distance = formatter.distance(from: string)
          
        }
        if Float(CLLocationDistance(total)) >= Float(distance) {
            self.showingAlert = true
            challenge.completed = true
        }
        session.updateChallenge(challenge: challenge.id, user: challenge.user, title: challenge.title, checkpoints: challenge.checkpoints, distance: challenge.distance, active: challenge.active, completed: challenge.completed, progress: total)
        print(total)
self.presentationMode.wrappedValue.dismiss()
    }
}

/*struct SubmitProgress_Previews: PreviewProvider {
    static var previews: some View {
        SubmitProgress(challenge: Challenge(id: "", user: "", title: "", checkpoints: [], distance: "", completed: false, active: true, progress: 0.0))
    }
}*/
