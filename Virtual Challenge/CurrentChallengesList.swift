//
//  CurrentChallengesList.swift
//  Virtual Challenge
//
//  Created by Mac on 08/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI

struct CurrentChallengesList: View {
    var body: some View {
        NavigationView {
        List {
            HStack{
            Text("Challenge.image")
           // .resizable()
                .frame(width: 50, height: 50)
                VStack {
                    Text("challenge.name")
                    
                   
            Spacer()
                }
        }
        .navigationBarTitle(Text("Current Challenges"))
        }
        }
    }
}

struct CurrentChallengesList_Previews: PreviewProvider {
    static var previews: some View {
        CurrentChallengesList()
    }
}
