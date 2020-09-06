//
//  SubmitProgress.swift
//  Virtual Challenge
//
//  Created by Mac on 08/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI

struct SubmitProgress: View {
    
    //var constant = "text"
    
    var body: some View {
        VStack {
        Text("Input New Distance:")
            HStack {
                TextField("Input Distance", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
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
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Submit")
            }

        }
    }
}

struct SubmitProgress_Previews: PreviewProvider {
    static var previews: some View {
        SubmitProgress()
    }
}
