//
//  ContentView.swift
//  Virtual Challenge
//
//  Created by Mac on 05/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI

struct ContentView: View {
   /* @State var menuOpen: Bool = false
        
        var body: some View {
            ZStack {
                if !self.menuOpen {
                    Button(action: {
                        self.openMenu()
                    }, label: {
                        Text("Open")
                    })
                }
                
                SideMenu(width: 270,
                         isOpen: self.menuOpen,
                         menuClose: self.openMenu)
            }
        }
        
        func openMenu() {
            self.menuOpen.toggle()
        }
    } */

    var body: some View {
        NavigationView {
            VStack{
                MapPage()
                    .frame(height:500)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
             //   Spacer()  ?needed
                
                VStack(alignment: .center) {
                Text("Summary")
                HStack(alignment: .top) {
                    Text("%")
                    Text("Mileage")
                }
                Text("Progress Charts")
                    
            }
                .padding()
                .offset(y: -70) //sets height for bottom VStack.
                    

        
        .navigationBarTitle(Text("Challenge Name"), displayMode: .inline)
    .navigationBarItems(leading: Text("List"),
                        trailing: Text("View"))
                    
                }
            
        }
        
        }
} //delete if putting in sidemenu code



   
        


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

