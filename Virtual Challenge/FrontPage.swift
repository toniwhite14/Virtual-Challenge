//
//  FrontPage.swift
//  Virtual Challenge
//
//  Created by Mac on 15/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI

struct FrontPage: View {
    @EnvironmentObject var userInfo: UserInfo
    var body: some View {
        Group {
        if userInfo.isUserAuthenticated == .undefined {
            Text("Loading...")
        } else if userInfo.isUserAuthenticated == .signedOut {
            LoginView2()
        } else {
            HomeView()
        }
    }
        .onAppear {
            self.userInfo.configureFirebaseStateDidChange()
        }
}
}

struct FrontPage_Previews: PreviewProvider {
    static var previews: some View {
        FrontPage()
    }
}
