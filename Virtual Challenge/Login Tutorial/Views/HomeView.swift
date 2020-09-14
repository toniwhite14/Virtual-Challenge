//
//  HomeView.swift
//  Virtual Challenge
//
//  Created by Mac on 15/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import SDWebImageSwiftUI

struct HomeView: View {
    @EnvironmentObject var userInfo: UserInfo
    @State var menuOpen: Bool = false
    @State var shown: Bool = false
    @State var userID: String = ""
    @State var profileImage = WebImage(url: URL(string: "NoUserImage2"))
   // @State private var showScreen: Bool = false
        
        
    var body: some View {
        NavigationView {
            ZStack {
          
                VStack {
                        
                    Button(action: {self.goContentView()}) {
                               
                              //  profileImage
                            UserImage(profilePicture: $profileImage)
                               
                        }
            
          
                    Button(action: {
                        self.shown.toggle()}) {
                        Text("Upload Profile Picture")
                    }.sheet(isPresented: $shown) {
                        ImagePicker(profileImage: self.$profileImage, Shown: self.$shown).environmentObject(self.userInfo)
                    }
                    
                    Spacer()
           
                    Text("Logged in as \(userInfo.user.name)")
                    Spacer()
           
                    .navigationBarTitle("Virtual Challenge")
                    .navigationBarItems(leading: Button("List") {
                    self.openMenu()
                }
                  /* NEED TO SORT IMAGE
                    Image("List")
                    .resizable()
                    .frame(width: 10)
                } */
               
            , trailing:
                     Button("Log out") {
                        FBAuth.logout { (result) in
                        print("Logged out")
                        }
            
                //self.userInfo.isUserAuthenticated = .signedOut
                    }
                )
                
            }
                
                    SideMenu(width: 270,
                                 isOpen: self.menuOpen,
                                 menuClose: self.openMenu)
                    }
                
                .onAppear {
                    self.image()
                    
            }
        }
    }
    func image() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let image = "\(uid)"
        let storage = Storage.storage().reference(withPath: image)
        storage.downloadURL{(url, err) in
               if err != nil {
                   print(err?.localizedDescription as Any)
                   let noImage = "NoUserImage2.png"
                   let storage2 = Storage.storage().reference(withPath: noImage)
                   storage2.downloadURL{(url, err) in
                       if err != nil {
                           print(err?.localizedDescription as Any)
                           return
                       }
                       let theurl = url
                       self.profileImage = WebImage(url: theurl)
                   return
                   }}
               else {
                   let theurl = url
                   self.profileImage = WebImage(url: theurl)
                   
               }
        }
    
    }
    
    func openMenu() {
        self.menuOpen.toggle()
    }
    
    
    //TO MOVE TO CONTENTVIEW
    func goContentView() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: ProfileView(userInfo: _userInfo).environmentObject(userInfo))
            window.makeKeyAndVisible()
        }
    }

    
}

struct Loader : UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<Loader>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Loader>) {
      
    }
}


//NEED TO RETRIVE PICTURE FROM USER
struct UserImage : View  {
    @Binding var profilePicture: WebImage
    var body: some View {
        
        return profilePicture
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .overlay(Circle().stroke(Color.gray, lineWidth: 4))
            .shadow(radius: 10)
        //    .padding(.bottom, 75)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @EnvironmentObject var userInfo: UserInfo
    @Binding var profileImage: WebImage
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(parent1: self)
    }
    
    @Binding var Shown: Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController{
        
        let imagePic = UIImagePickerController()
        imagePic.sourceType = .photoLibrary
        imagePic.delegate = context.coordinator
        return imagePic
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent : ImagePicker!
        init(parent1: ImagePicker){
            parent = parent1
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.Shown.toggle()
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let image = info[.originalImage] as! UIImage
            let storage = Storage.storage()
            let userID = parent.userInfo.user.uid
            storage.reference().child(userID).putData(image.jpegData(compressionQuality: 0.35)!, metadata: nil) {(_, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
                }
                print("success")
            let image = "\(userID)"
                 print(image)
                 let storeage = Storage.storage().reference(withPath: image)
                 storeage.downloadURL{(url, err) in
                     if err != nil {
                        print(err?.localizedDescription as Any)
                         return
                     }
                    self.parent.profileImage = WebImage(url: url!)
                }
            }
            parent.Shown.toggle()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
