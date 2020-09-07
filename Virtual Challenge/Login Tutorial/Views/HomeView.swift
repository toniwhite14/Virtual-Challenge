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

struct HomeView: View {
    @EnvironmentObject var userInfo: UserInfo
    @State var menuOpen: Bool = false
    @State var shown: Bool = false
   // @State private var showScreen: Bool = false
        
        
    var body: some View {
        NavigationView {
            ZStack {
          
                VStack {
                    //UserImage()
                    Button(action: {goContentView()}) {
                       
                        UserImage()
                        
                    }
                    Button(action: {
                        self.shown.toggle()}) {
                        Text("Upload Profile Picture")
                    }.sheet(isPresented: $shown) {
                        ImagePicker(Shown: self.$shown)
                    }
                    

           
        Text("Logged in as \(userInfo.user.name)")
           
            .navigationBarTitle("Virtual Challenge")
            .navigationBarItems(leading:
                Button("List") {
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
                guard let uid = Auth.auth().currentUser?.uid else {
                    return
                }
               FBFirestore.retrieveFBUser(uid: uid) { (result) in
                    switch result {
                    case.failure(let error):
                        print(error.localizedDescription)
                        //Display some kind of alert to your user here. (it shouldn't happen but it might be worth making!)
                    case.success(let user):
                        self.userInfo.user = user
                    }
                }
            }
        }
        
}
    func openMenu() {
        self.menuOpen.toggle()
    }
}



//NEED TO RETRIVE PICTURE FROM USER
struct UserImage : View {
    var body: some View {
        return Image("Face")
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .overlay(Circle().stroke(Color.gray, lineWidth: 4))
            .shadow(radius: 10)
            .padding(.bottom, 75)
    }
}
//TO MOVE TO CONTENTVIEW
func goContentView() {
    if let window = UIApplication.shared.windows.first {
        window.rootViewController = UIHostingController(rootView: ContentView())
        window.makeKeyAndVisible()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
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
         //   let user = UserInfo()
            let userID = "exampleID"
            storage.reference().child(userID).putData(image.jpegData(compressionQuality: 0.35)!, metadata: nil) {(_, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
                }
                print("success")
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
