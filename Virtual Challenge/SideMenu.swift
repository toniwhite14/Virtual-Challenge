//
//  SideMenu.swift
//  abseil
//
//  Created by Mac on 18/07/2020.
//

import SwiftUI

struct SideMenu: View {
        let width: CGFloat
        let isOpen: Bool
        let menuClose: () -> Void
        
        var body: some View {
             ZStack {
                        GeometryReader { _ in
                            EmptyView()
                        }
                        .background(Color.gray.opacity(0.3))
                        .opacity(self.isOpen ? 1.0 : 0.0)
                        .animation(Animation.easeIn.delay(0.25))
                        .onTapGesture {
                            self.menuClose()
                                 Button(action: {
                                    // self.presentationMode.wrappedValue.dismiss()
                                    self.menuClose()
                                }) {
                                    Image(systemName: "xmark.circle")
                                    
                                    }
                            //)
                        }
                        
                        HStack {
                            ListView()
                                .frame(width: self.width)
                                .background(Color.white)
                                .offset(x: self.isOpen ? 0 : -self.width)
                                .animation(.default)
                            
                            Spacer()
                            
                              }
                }
            }
}

/*
struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        SideMenu()
    }
}
*/
