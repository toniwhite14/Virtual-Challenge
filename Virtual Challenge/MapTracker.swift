//
//  MapTracker.swift
//  Virtual Challenge
//
//  Created by Mac on 06/09/2020.
//  Copyright © 2020 Toni. All rights reserved.
//
//  Created by Nicola Grayson on 01/09/2020.
//  Copyright © 2020 Nicola Grayson. All rights reserved.
//
import SwiftUI
import MapKit
import Firebase

struct MapTracker: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userInfo : UserInfo
    @ObservedObject var session = FirebaseSession()
 //   @State var uid: String
//    @State private var checkpoints = [GeoPoint]()
    @State private var annotations = [MKPointAnnotation]()
    @State private var centreCoordinate = CLLocationCoordinate2D()
    @State private var locationManager = CLLocationManager()
  //  @State private var theDistance = "Tap map to plot route"
  //  @State private var title = ""
    @State private var showAlert = false
    @State private var update = false
    @State var challenge: Challenge = Challenge(id: "", user: "", title: "", checkpoints: [], annotations: [], distance: "", completed: false, active: true)
  //  @State var id: String = ""
 //   @State var challengeForUpdate = Challenge(id: "", user: "", title: "", checkpoints: [], distance: "", completed: false, active: false)
    //var new : Bool = true
    
    var body: some View {
        ZStack {
        Color.black
            .edgesIgnoringSafeArea(.all)
        VStack(alignment: .center) {
        //    if new == true {
            TextField("Enter a title for your challenge", text: $challenge.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .border(Color.purple)
                .autocapitalization(.sentences)
         //   }
       
            mapView( challenge: $challenge, update: $update)
                  //  .edgesIgnoringSafeArea(.top)
            

            Text(challenge.distance)
                    .font(.headline)
                    .foregroundColor(Color.white)
                    
            HStack(alignment: .center) {
                   
                    VStack(alignment: .center) {
               /*         Button(action: {self.addPin()}) {
                            Image(systemName: "plus")
                            Text("Add Pin")
                        }*/
                        Button(action: {
                            self.showAlert = true
                            }) {
                           
                            Text("Save Challenge")
                        }.buttonStyle(makeButtonStyle())
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Saving Challenge"), message: Text("Have you finshed editing your challenge route?"), primaryButton: .default(Text("Save").bold(), action: self.save), secondaryButton: .cancel())
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Button(action: {self.removeLast()}) {
                            Text("Remove last Pin")
                            Image(systemName: "minus")
                            
                        }
                        Button(action: {self.removeAll()}) {
                            Text("Remove All Pins")
                            Image(systemName: "trash")
                        
                        }
                    }
                }
                .padding()
                Spacer()

        }
        }
  
        .background(Color.black)
        
    }
   
    
    func save() {
        print("saving...")
        var getCoord: [GeoPoint] = []
        for anno in challenge.annotations {
            let coordinate = anno.coordinate
            getCoord.append(GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        
        session.uploadChallenge(id: "", user: self.userInfo.user.uid, title: challenge.title, checkpoints: getCoord, annotations: [], distance: challenge.distance, completed: false, active: true)
        self.presentationMode.wrappedValue.dismiss()
        
    }
    
    func removeAll() {
        self.challenge.distance = "Tap map to plot route"
        self.challenge.annotations.removeAll()
  //      self.polylines.removeAll()
        
    }
    func removeLast() {
        
        if self.challenge.annotations.count > 2 {
            self.challenge.annotations.removeLast()
            
        }
        else if self.challenge.annotations.count > 0 {
            self.challenge.annotations.removeLast()
            self.challenge.distance = "Tap map to plot route"
        }
        else {
            self.challenge.distance = "Tap map to plot route"
        }
    }
}
struct makeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.blue)
            .font(.headline)
            .padding(5)
            .background(Color(.green))
            .cornerRadius(10.0)
          
    }
}

struct MapTracker_Previews: PreviewProvider {
    
    static var previews: some View {
        MapTracker()
    }
}

struct mapView: UIViewRepresentable {
  //  @State var checkpoints : [GeoPoint] = []
//    @State var annotations : [MKPointAnnotation]

//    @Binding var centreCoordinate: CLLocationCoordinate2D
    var locationManager = CLLocationManager()
 //   @Binding var distance : CLLocationDistance
 //   @Binding var id : String
    @Binding var challenge: Challenge
//    @Binding var theDistance : String
    @ObservedObject var session = FirebaseSession()
    @Binding var update : Bool
    
    func setupManager() {
        
     //    locationManager.desiredAccuracy = kCLLocationAccuracyBest
         locationManager.requestWhenInUseAuthorization()
         locationManager.requestAlwaysAuthorization()
      //  self.session.getChallengeForUpdate(id: id)
     //   if update{
     //            self.annotations = self.session.challengeForUpdate.annotations
     //        }
        
     }
    
    func makeCoordinator() -> Coordinator {
        return mapView.Coordinator(parent1: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
  
        setupManager()

    
        let map = MKMapView()
      //  map.showsUserLocation = true
 
           if CLLocationManager.locationServicesEnabled() {
               locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
           //    locationManager.startUpdatingLocation()

                   var locValue:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 51.5634, longitude: 0.6939)
                   if self.locationManager.location?.coordinate != nil {
                       locValue = self.locationManager.location!.coordinate

                   }
                   let coordinate =  CLLocationCoordinate2D(
                       latitude: locValue.latitude, longitude: locValue.longitude)
             //   self.centreCoordinate = coordinate
                

                let span = MKCoordinateSpan(latitudeDelta: 1.000, longitudeDelta: 1.000)
                   let region = MKCoordinateRegion(center: coordinate, span: span)
                   map.setRegion(region, animated: true)
                   

            
        }
        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.addPin(gesture:)))
        
        map.addGestureRecognizer(tap)
        map.delegate = context.coordinator
      //  map.addAnnotations(challenge.annotations)
        locationManager.delegate = context.coordinator
     //   self.getDirctions(map)
        return map
    }
    

    func getDirctions(_ uiView: MKMapView) {
     //   let map = uiView
        var theDistance : CLLocationDistance = 0
        let distanceFormat = MKDistanceFormatter()
        distanceFormat.units = .default
 
     //   print(self.annotations)
        if self.challenge.annotations != [] {
                uiView.removeOverlays(uiView.overlays)
            
            if self.challenge.annotations.count >= 1 {
             //   var lines: [MKOverlay] = []
                    let req = MKDirections.Request()
                
                    for (k, item) in self.challenge.annotations.enumerated() {
                    
                        if k < (self.challenge.annotations.count-1) {
                        
                            req.source = MKMapItem(placemark: MKPlacemark(coordinate: item.coordinate))
                            req.destination = MKMapItem(placemark: MKPlacemark(coordinate: self.challenge.annotations[k+1].coordinate))
                    
                            let directions = MKDirections(request: req)
                    
                            directions.calculate {(direct, err) in
                                if err != nil {
                                    print((err?.localizedDescription)!)
                                    return
                                }
                                if direct?.routes.first?.polyline != nil {
                                
                                    let polyline = direct?.routes.first?.polyline
                       
                                    uiView.addOverlay(polyline!)
                                    theDistance = theDistance +   (direct?.routes.first!.distance)!
               
                                    self.challenge.distance = distanceFormat.string(fromDistance: theDistance)
                      
                                }
                            }
                       

                    }
            
                }

            }
        }

    }

    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
      
     
        if challenge.annotations.count != uiView.annotations.count {
            
            uiView.removeAnnotations(uiView.annotations)
       
            uiView.addAnnotations(challenge.annotations)
        
            uiView.removeOverlays(uiView.overlays)
            
            getDirctions(uiView)
        }
     
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent : mapView
        init(parent1 : mapView) {
            parent = parent1
        }
        @objc func addPin(gesture: UIGestureRecognizer) {
            
            if gesture.state == .ended {

                if let mapView = gesture.view as? MKMapView {
                    let point = gesture.location(in: mapView)
                    let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
               //     parent.checkpoints.append(GeoPoint(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude))
                    parent.challenge.annotations.append(annotation)
            //        mapView.addAnnotation(annotation)
                    
                }
            }
            
        }
      
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pin.isDraggable = true
            pin.pinTintColor = .blue
            pin.animatesDrop = false
            return pin
        }
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            
         //   mapView.removeOverlays(mapView.overlays)
            if newState == .ending {
              //  mapView.removeOverlays(mapView.overlays)
    
                parent.getDirctions(mapView)
            }
        }
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let render = MKPolylineRenderer(overlay: overlay)
            render.strokeColor = .purple
            render.lineWidth = 3
            return render
        }
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
           // parent.centreCoordinate = mapView.centerCoordinate
        }
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            
            switch status {
            case .restricted:
              break
            case .denied:
           //   mapView.showMapAlert.toggle()
              return
            case .notDetermined:
                
              parent.locationManager.requestWhenInUseAuthorization()
              return
            case .authorizedWhenInUse:
              return
            case .authorizedAlways:
        //      parent.locationManager//.allowsBackgroundLocationUpdates = true
      //        parent.locationManager//.pausesLocationUpdatesAutomatically = false
              return
            @unknown default:
              break
            }
        //    parent.locationManager.startUpdatingLocation()

        }
    }
}
