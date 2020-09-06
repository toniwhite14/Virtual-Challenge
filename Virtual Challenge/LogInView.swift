//
//  LogInView.swift
//  Virtual Challenge
//
//  Created by Mac on 08/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI


let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

let storedUsername = "Jamie"
let storedPassword = "Jamie"


struct LogInView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    
    @State var authenticationDidFail: Bool = false
    @State var authenticationDidSucceed: Bool = false
    
    @ObservedObject var keyboardResponder = KeyboardResponder()
    
    var body: some View {
        ZStack {
        VStack {
            WelcomeText()
          //  UserImage()
            UsernameTextField(username: $username)
            PasswordTextField(password: $password)
            if authenticationDidFail {
                Text("Information not correct. Try again.")
                    .offset(y: -10)
                    .foregroundColor(.red)
                
            }
            Button(action: {
                if self.username == storedUsername && self.password == storedPassword {
                    self.authenticationDidSucceed = true
                    self.authenticationDidFail = false
                } else {
                    self.authenticationDidFail = true
                }
                }) {
                LoginButtonContent()
            }
        }
        .padding()
            if authenticationDidSucceed {
            Text("Login Succeeded!")
                .animation(Animation.default)
            }
        }
        .offset(y: -keyboardResponder.currentHeight*0.9)
    }
    
}



            
            
            /* VStack {
                VStack {
                Text("Log In")
                    Text("Enter Email Adress:")
                    TextField("Type Email Address", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    Text("Enter Password")
                    TextField("Type Password", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    
                }
                
            }
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Done")
            } */
        
#if DEBUG
struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}

#endif
struct WelcomeText : View {
    var body: some View{
        return Text("Welcome!")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}


/*struct UserImage : View {
    var body: some View {
        return Image("Face")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .overlay(Circle().stroke(Color.gray, lineWidth: 4))
            .shadow(radius: 10)
            .padding(.bottom, 75)
    }
} */


struct LoginButtonContent : View {
    var body: some View {
        return Text("LOGIN")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}

struct UsernameTextField: View {
    @Binding var username: String
    var body: some View {
        return TextField("Username", text: $username)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}

struct PasswordTextField: View {
    @Binding var password: String
    var body: some View {
        SecureField("Password", text: $password)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}
