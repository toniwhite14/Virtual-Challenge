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

struct MapTracker: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var checkpoints = [MKPointAnnotation]()
    @State private var centreCoordinate = CLLocationCoordinate2D()
    @State private var locationManager = CLLocationManager()
    @State private var theDistance = "Tap map to plot route"
    @State private var title = ""
    @State private var showAlert = false
    //var new : Bool = true
    
    var body: some View {
        ZStack {
        Color.black
            .edgesIgnoringSafeArea(.all)
        VStack(alignment: .center) {
        //    if new == true {
            TextField("Enter a title for your challenge", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .border(Color.purple)
                .autocapitalization(.sentences)
         //   }
       
            mapView(checkpoints: self.$checkpoints, centreCoordinate: $centreCoordinate, locationManager: $locationManager, theDistance: $theDistance)
                  //  .edgesIgnoringSafeArea(.top)
            

                Text(theDistance)
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
        .background(Color.black)
        }
    }
    func save() {
        print("saving...")
        
        self.presentationMode.wrappedValue.dismiss()
        
    }
    
    func removeAll() {
        self.theDistance = "Tap map to plot route"
        self.checkpoints.removeAll()
  //      self.polylines.removeAll()
        
    }
    func removeLast() {
        
        if checkpoints.count > 2 {
            self.checkpoints.removeLast()
            
        }
        else if checkpoints.count > 0 {
            self.checkpoints.removeLast()
            theDistance = "Tap map to plot route"
        }
        else {
            theDistance = "Tap map to plot route"
        }
    }
    
    func addPin() {
        
        let newPin = MKPointAnnotation()
        newPin.coordinate = self.centreCoordinate
        self.checkpoints.append(newPin)
        
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
        ContentView()
    }
}

struct mapView: UIViewRepresentable {
    @Binding var checkpoints : [MKPointAnnotation]
 //   @Binding var polylines : [MKOverlay]
    @Binding var centreCoordinate: CLLocationCoordinate2D
    @Binding var locationManager : CLLocationManager
 //   @Binding var distance : CLLocationDistance
    @Binding var theDistance : String
    
    func setupManager() {
        
     //    locationManager.desiredAccuracy = kCLLocationAccuracyBest
         locationManager.requestWhenInUseAuthorization()
         locationManager.requestAlwaysAuthorization()
       
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
                   let coordinate = CLLocationCoordinate2D(
                       latitude: locValue.latitude, longitude: locValue.longitude)
             //   self.centreCoordinate = coordinate
                

                let span = MKCoordinateSpan(latitudeDelta: 1.000, longitudeDelta: 1.000)
                   let region = MKCoordinateRegion(center: coordinate, span: span)
                   map.setRegion(region, animated: true)
                   

            
        }
        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.addPin(gesture:)))
        
        map.addGestureRecognizer(tap)
        map.delegate = context.coordinator
        locationManager.delegate = context.coordinator

        return map
    }
    

    func getDirctions(_ uiView: MKMapView) {
     //   let map = uiView
        var theDistance : CLLocationDistance = 0
        let distanceFormat = MKDistanceFormatter()
        distanceFormat.units = .default
 
        if checkpoints != [] {
            uiView.removeOverlays(uiView.overlays)
            
            if checkpoints.count >= 1 {
             //   var lines: [MKOverlay] = []
                let req = MKDirections.Request()
                
                for (k, item) in checkpoints.enumerated() {
                    
                    if k < (checkpoints.count-1) {
                        
                        req.source = MKMapItem(placemark: MKPlacemark(coordinate: item.coordinate))
                        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: checkpoints[k+1].coordinate))
                    
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
               
                            self.theDistance = distanceFormat.string(fromDistance: theDistance)
                            
                            }
                        }
                        
                    }
            
                }
            
            }

        
        }
  
    }

    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        if checkpoints.count != uiView.annotations.count {
            
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(checkpoints)
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
                    parent.checkpoints.append(annotation)
              //  mapView.addAnnotation(annotation)
                    
                }
            }
            
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pin.isDraggable = true
            pin.pinTintColor = .red
            pin.animatesDrop = false
            return pin
        }
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            
         //   mapView.removeOverlays(mapView.overlays)
            if newState == .ending {
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
            parent.centreCoordinate = mapView.centerCoordinate
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
