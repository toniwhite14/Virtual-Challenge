//
//  SetNewChallenge.swift
//  Virtual Challenge
//
//  Created by Mac on 08/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI

struct SetNewChallenge: View {
@State var menuOpen: Bool = false
    
  /*  var dateRange: ClosedRange<Date> {
        //NEED TO SET UP PROFILE
           let min = Calendar.current.date(byAdding: .year, value: -1, to: profile.goalDate)!
           let max = Calendar.current.date(byAdding: .year, value: 1, to: profile.goalDate)!
           return min...max
       }
    */
    
    var body: some View {
        
        ZStack{
            VStack {
            Text("Set New Challenge")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Insert Challenge Picture")
                .frame(height:200)
            Text("Challenge Name")
            TextField("Type Challenge Name", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
            Text("Distance / Or plot on map")
            Text("To be completed by:")
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Goal Date").bold()
      /*          DatePicker(
                    "Goal Date",
                    selection: $profile.goalDate,
                    in: dateRange,
                    displayedComponents: .date)
            }
        */    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Invite Friends")
            }
    }
    }  .navigationBarTitle(Text("New Challenge"), displayMode: .inline)
                      .navigationBarItems(leading:
                      Button("Menu") {
                          self.openMenu()
                      }
                      , trailing: Text("View"))
       SideMenu(width: 270,
                              isOpen: self.menuOpen,
                              menuClose: self.openMenu)
        }
}
    func openMenu() {
        self.menuOpen.toggle()
    }
}

struct SetNewChallenge_Previews: PreviewProvider {
    static var previews: some View {
        SetNewChallenge()
    }
}
