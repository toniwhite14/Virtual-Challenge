//
//  LoginView2.swift
//  Virtual Challenge
//
//  Created by Mac on 15/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI

struct LoginView2: View {
    enum Action {
        case signUp, resetPW
    }
    
    @State private var showSheet = false
    @State private var action: Action?
    
    var body: some View {
        VStack {
            
        SignInWithEmailView(showSheet: $showSheet, action: $action)
            SignInWithAppleView().frame(width: 200, height: 50)
            Spacer()
        }
            .sheet(isPresented: $showSheet) {
            if self.action == .signUp {
                SignUpView()
            } else {
                ForgotPasswordView()
            }
        }
    }
}

struct LoginView2_Previews: PreviewProvider {
    static var previews: some View {
        LoginView2()
    }
}
