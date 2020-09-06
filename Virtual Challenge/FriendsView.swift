//
//  FriendsView.swift
//  Virtual Challenge
//
//  Created by Mac on 08/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI

struct FriendsView: View {
    var body: some View {
        VStack {
            
            VStack {
                Text("Friends Image")
                    .frame(width:300, height:300)
                //.circle
                Text("Name")
                    .font(.title)
                    .fontWeight(.heavy)
                Text("Challenges currently completing together:")
                //Add list
                Text("Chalenges completed together")
                //Add list
                Text("Total Mileage completed together")
                //Add Total of all challenges combined
                Text("Number of challenges your friend has completed:")
                //Add number of friends challenges
                
            
            }
        }
        
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
