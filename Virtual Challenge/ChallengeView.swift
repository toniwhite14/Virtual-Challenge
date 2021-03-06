//
//  ChallengeView.swift
//  Virtual Challenge
//
//  Created by Nicola Grayson on 20/09/2020.
//  Copyright © 2020 Toni. All rights reserved.
//


import SwiftUI
import MapKit

struct ChallengeView: View {
@EnvironmentObject var userInfo : UserInfo
@ObservedObject var session = FirebaseSession()
@State var menuOpen: Bool = false
@State private var showScreen: Bool = false
@Binding var challenge: Challenge
@State private var update: Bool = false
@State private var preview: Bool = true
@State var annotations = [MKPointAnnotation]()
@State var progressValue: Float = 0.0
    
    var body: some View {
    //    NavigationView {
            ZStack{
                VStack {
                //    Text(challenge.title)
                //    .bold()
                //    .padding()
                    mapView( challenge: $challenge, update: $update, preview: $preview, annotations: $annotations)
                    HStack{
                        VStack(alignment: .leading){
                        Text("Total Distance: \(challenge.distance)")
                            .font(.footnote)
                            Text("Progress: \(getMilage())")
                                .font(.footnote)
                        }
                        Spacer()
                        Text("Goal Date: ").bold()
                            .font(.caption)
                    }.padding(.horizontal)
                    VStack{
                        if challenge.completed == false {
                            NavigationLink(destination: SubmitProgress(challenge: $challenge)){
                                HStack{
                                    Spacer()
                                    Text("Add Progress")
                                        .font(.headline)
                                    Image(systemName: "plus")
                                    Spacer()
                                }.padding()
                                .background(Color.green)
                                .cornerRadius(25)
                            }
                        }
                        else {
                            HStack{
                                Spacer()
                                Text("Challenge Completed")
                                    .font(.headline)
                                Image(systemName: "tick")
                                Spacer()
                            }.padding()
                            .background(Color.green)
                            .cornerRadius(25)
                        }
           
                    }
                        .padding(.horizontal)
           
                    
                    HStack{
                        ProgressBar(challenge: $challenge)
                            .frame(width: 80.0, height: 80.0)
                            .padding(40.0)
                        MilageBar(challenge: $challenge)
                         //   .frame(width: 80.0, height: 160.0)
                            .padding(40.0)
                        }
                    Spacer()
            
                    
                }
                    .navigationBarTitle(Text(challenge.title), displayMode: .inline)
                      .navigationBarItems(leading:
                      Button("") {
                      }
                        , trailing: Button("Edit"){self.edit()})
   //    SideMenu(width: 270,
    //                          isOpen: self.menuOpen,
   //                           menuClose: self.openMenu)
            }.onAppear() {
                
    }
}
    func edit() {
 
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: SetNewChallenge(challenge: challenge, update: true).environmentObject(userInfo))
             window.makeKeyAndVisible()
         }
        
    }
    
    func openMenu() {
        self.menuOpen.toggle()
    }
    func getMilage() -> String {
        let formatter = MKDistanceFormatter()
        formatter.units = .imperial
        formatter.unitStyle = .full
     
        let progress = CLLocationDistance(self.challenge.progress)
       
        return formatter.string(fromDistance: progress)
    }
    
}

/*struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView(challenge: Challenge(id: "", user: "", title: "", checkpoints: [], distance: "", completed: false, active: true, progress: 0.0))
    }
}*/

struct ProgressBar: View {
    @State var progress: Float = 0.0
    @Binding var challenge: Challenge
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5.0)
                .opacity(0.3)
                .foregroundColor(Color.green)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.green)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
            .font(.callout)
            .bold()
        }.onAppear() {
            var distance : CLLocationDistance = 0
            let formatter = MKDistanceFormatter()
            formatter.units = .imperial
            if self.challenge.distance != "" {
                let string = self.challenge.distance.components(separatedBy: ",").joined()
                distance = formatter.distance(from: string)
              
            }
            let milage = CLLocationDistance(self.challenge.progress)
         //   let remaining = milage.distance(to: distance)
            self.progress = Float(milage)/(Float(distance))
        }
        
    }
}
struct MilageBar: View {
    @Binding var challenge: Challenge
    @State var remaining = ""
    let formatter = MKDistanceFormatter()
    var body: some View {
        
            VStack{

        
                    Text(remaining)
                        .bold()
                        .font(.headline)
                        .foregroundColor(Color.red)
                    Text("Remaining")
                    .bold()
                    .font(.headline)
                    .foregroundColor(Color.red)
                //    .font(.callout)
                //    .bold()
                
            }.onAppear(){
            self.formatter.units = .imperial
            self.formatter.unitStyle = .full
            var distance : CLLocationDistance = 0
            if self.challenge.distance != "" {
                let string = self.challenge.distance.components(separatedBy: ",").joined()
                distance = self.formatter.distance(from: string)
                }
              
                if challenge.completed {
                    self.remaining = self.formatter.string(fromDistance: CLLocationDistance(0))
                }
                else {
                    let progress = CLLocationDistance(self.challenge.progress)
                    self.remaining = self.formatter.string(fromDistance: progress.distance(to: distance))
                }
        }
        
    }
}
