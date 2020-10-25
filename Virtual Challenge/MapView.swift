//
//  MapView.swift
//  Virtual Challenge
//
//  Created by Nicola Grayson on 14/09/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit
import Firebase
import SDWebImageSwiftUI

struct mapView: UIViewRepresentable {

    var locationManager = CLLocationManager()

    @Binding var challenge: Challenge
    @ObservedObject var session = FirebaseSession()
    @Binding var update : Bool
    @Binding var preview : Bool
    @Binding var annotations : [MKPointAnnotation]
    @State private var setup = true
    @State var picture: WebImage = WebImage(url: URL(string: ""))
    func setupManager() {
        
     //    locationManager.desiredAccuracy = kCLLocationAccuracyBest
         locationManager.requestWhenInUseAuthorization()
         locationManager.requestAlwaysAuthorization()
    
     }
    
    func makeCoordinator() -> Coordinator {
        return mapView.Coordinator(parent1: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
  
        let map = MKMapView()
        setupManager()

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
        distanceFormat.units = .imperial
        let req = MKDirections.Request()
     //   print(self.annotations)
        if preview {
            var onerun = true
            if self.challenge.checkpoints != [] {
             //   uiView.removeOverlays(uiView.overlays)
            
                if self.challenge.checkpoints.count >= 1 {
                    var pointCount = 0
                    var points = [MKMapPoint]()
                    DispatchQueue.global().async {
                        let semaphore = DispatchSemaphore(value: 0)
                        for (k, item) in self.challenge.checkpoints.enumerated() {
                      
                            if k < (self.challenge.checkpoints.count-1) {
                        
                                req.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)))
                                req.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.challenge.checkpoints[k+1].latitude, longitude: self.challenge.checkpoints[k+1].longitude)))
                    
                                let directions = MKDirections(request: req)
                    
                                directions.calculate { direct, err in
                                    if err != nil {
                                        print((err?.localizedDescription)!)
                                        return
                                    }
                                    if direct?.routes.first?.polyline != nil {
                                
                                        let polyline = direct?.routes.first?.polyline
                                        pointCount += polyline!.pointCount
                                        theDistance = theDistance +   (direct?.routes.first!.distance)!
                                        
                                        for p in 0...polyline!.pointCount-1 {
                                            points.append((polyline?.points()[p])!)
                                        }
                                        print(k)
                                        print(pointCount)
                                        print(points.count)
                                 //       self.challenge.distance = distanceFormat.string(fromDistance: theDistance)
                                        uiView.addOverlay(polyline!)
                                        if onerun {
                                            if theDistance > self.challenge.progress {
                                                let point = LocationAnnotation(coordinate: self.addProgressPoint(theDistance: theDistance, pointCount: pointCount, points: points))
                                                uiView.addAnnotation(point)
                                                onerun = false
                                            }
                                    
                                    }
                                }
                          
                                semaphore.signal()
                                    
                                }
                                }
                           semaphore.wait()
                            
                        }
                      exit(0)
                        
                    }
                
                }
                    uiView.showAnnotations(uiView.annotations, animated: true)
     
                    }
            
                }
          
            
            else {
                for (k, item) in self.annotations.enumerated() {
                         
                    if k < (self.annotations.count-1) {
                             
                        req.source = MKMapItem(placemark: MKPlacemark(coordinate: item.coordinate))
                        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: self.annotations[k+1].coordinate))
                         
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
            if setup {
                setup = false
                if challenge.checkpoints != [] {
                    uiView.showAnnotations(uiView.annotations, animated: true)
                    
                }
            }
        }

    }
    func addProgressPoint(theDistance: CLLocationDistance, pointCount: Int, points: [MKMapPoint]) -> CLLocationCoordinate2D {
            
          
            var distance : CLLocationDistance = 0
            let formatter = MKDistanceFormatter()
            formatter.units = .imperial
            if self.challenge.distance != "" {
                let string = self.challenge.distance.components(separatedBy: ",").joined()
                distance = formatter.distance(from: string)
                 }
            let milage = CLLocationDistance(self.challenge.progress)
        if Float(milage) < Float(distance) {
            let progress = Float(milage)/(Float(distance))
            let progressPoint = Float(pointCount)*progress
            return CLLocationCoordinate2D(latitude: (points[Int(progressPoint)].coordinate.latitude), longitude: (points[Int(progressPoint)].coordinate.longitude))
        }
        else {
            return CLLocationCoordinate2D(latitude: challenge.checkpoints[challenge.checkpoints.count-1].latitude, longitude:  challenge.checkpoints[challenge.checkpoints.count-1].longitude)
        }
        
            
   
            
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
 
        DispatchQueue.main.async {
        
            if self.setup {
                if self.challenge.checkpoints.count != uiView.annotations.count {
                uiView.removeAnnotations(uiView.annotations)
                    for check in self.challenge.checkpoints {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: check.latitude, longitude: check.longitude)
                    self.annotations.append(annotation)
                    uiView.addAnnotation(annotation)
            }
                   
                //    self.setup = false
                
                uiView.removeOverlays(uiView.overlays)
                    self.getDirctions(uiView)
        }
            }}
         //   else {
            if self.preview == false {
                if self.annotations.count != uiView.annotations.count {
             
                    uiView.removeAnnotations(uiView.annotations)
                    for annotation in self.annotations {
                        uiView.addAnnotation(annotation)
                    }
                    uiView.removeOverlays(uiView.overlays)
                    self.getDirctions(uiView)
                }
            }
            
     //   }
    //    }
     
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
                        if parent.preview {
                  //          parent.challenge.checkpoints.append(GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
                        }
                
                        else {
                            parent.annotations.append(annotation)
                            
                        }
                }
            }
            
        }

      
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            let pic = MKAnnotationView(annotation: annotation, reuseIdentifier: "pic")
            
            if parent.preview {
                pin.isDraggable = false
                pic.isDraggable = false
            }
            else {
                pin.isDraggable = true
            }
            pin.pinTintColor = .blue
            pin.animatesDrop = false
            if let uid = Auth.auth().currentUser?.uid {
                let image = "\(uid)"
                var picture = UIImage()
                let storage = Storage.storage().reference(withPath: image)
                storage.downloadURL{(url, err) in
                    if err != nil {
                        print(err?.localizedDescription as Any)
                        picture = UIImage(named: "NoUserImage")!
                        let size = CGSize(width: 40, height: 40)
                        picture = UIGraphicsImageRenderer(size:size).image {
                             _ in picture.draw(in:CGRect(origin:.zero, size:size))
                        }
                        pic.image = picture
                    }
                    else {
                    let theurl = url
                    if let data = try? Data(contentsOf: theurl!) {
                        picture = UIImage(data: data)!
                        let size = CGSize(width: 40, height: 40)
                        picture = UIGraphicsImageRenderer(size:size).image {
                             _ in picture.draw(in:CGRect(origin:.zero, size:size))
                        }
                        pic.image = picture
                        }
                    }
                }
            }

            if annotation .isKind(of: MKPointAnnotation.self) {
                return pin
            }
            else {
                return pic
            }
        }

        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            
         //   mapView.removeOverlays(mapView.overlays)
            if newState == .ending {

                mapView.removeOverlays(mapView.overlays)
    
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
    class LocationAnnotation: NSObject, MKAnnotation {
      // 3
      let coordinate: CLLocationCoordinate2D
      
      // 4
      init(
        coordinate: CLLocationCoordinate2D
 
      ) {
        self.coordinate = coordinate

      }
    }
}


