//
//  FriendsViewRow.swift
//  Virtual Challenge
//
//  Created by Mac on 08/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI

struct FriendsViewRow: View {
    
  //  var friend: FriendsView
    
    var body: some View {
       // Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        NavigationView {
        List {
            HStack{
            Text("friend.image")
           // .resizable()
                .frame(width: 50, height: 50)
                VStack {
                    Text("friend.name")
                        .font(.headline)
                        .bold()
                    Text("friend.completed")
                        .font(.subheadline)
            Spacer()
                }
        }
        .navigationBarTitle(Text("Friends"))
        }
        }
    }
}

struct FriendsViewRow_Previews: PreviewProvider {
    static var previews: some View {
        FriendsViewRow()
    }
}
