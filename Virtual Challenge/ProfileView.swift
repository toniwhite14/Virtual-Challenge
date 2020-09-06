//
//  ProfileView.swift
//  Virtual Challenge
//
//  Created by Mac on 08/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var userInfo: UserInfo
    
    var body: some View {
        VStack {
        
        VStack {
            UserImage()
                //would like to rezize to ?300 squared
            
            Text(userInfo.user.name)
                .font(.title)
                .fontWeight(.heavy)
            Text("Challenges currently completing:")
            //Add list
            Text("Chalenges completed:")
            //Add list
            Text("Total Mileage completed:")
            //Add Total of all challenges combined
            //?add badges for 1/3/5/10/15/20 challenges
            }
        }
    }
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}