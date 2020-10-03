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

        }
    }
    func save() {
        var total: Double = 0.0
        let formatter = MKDistanceFormatter()
                  formatter.units = .imperial
        let input = formatter.distance(from: self.input)
        let milage = CLLocationDistance(self.challenge.progress)
        total = Double(Float(milage)+Float(input))
        self.challenge.progress = total
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
