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


struct mapView: UIViewRepresentable {

    var locationManager = CLLocationManager()

    @Binding var challenge: Challenge
    @ObservedObject var session = FirebaseSession()
    @Binding var update : Bool
    @Binding var preview : Bool
    @Binding var annotations : [MKPointAnnotation]
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
        distanceFormat.units = .default
        let req = MKDirections.Request()
     //   print(self.annotations)
        if preview {
            if self.challenge.checkpoints != [] {
             //   uiView.removeOverlays(uiView.overlays)
            
                if self.challenge.checkpoints.count >= 1 {
                    
                        for (k, item) in self.challenge.checkpoints.enumerated() {
                    
                            if k < (self.challenge.checkpoints.count-1) {
                        
                                req.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)))
                                req.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.challenge.checkpoints[k+1].latitude, longitude: self.challenge.checkpoints[k+1].longitude)))
                    
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
               
                                 //       self.challenge.distance = distanceFormat.string(fromDistance: theDistance)
                      
                                    }
                                }
                       
                            }
                        }
                    uiView.showAnnotations(uiView.annotations, animated: true)
                    }
            
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

        }

    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if update {
            DispatchQueue.main.async {
                
                if self.challenge.checkpoints.count != uiView.annotations.count {
                  //  uiView.removeAnnotations(uiView.annotations)
                    for check in self.challenge.checkpoints {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: check.latitude, longitude: check.longitude)
                        self.annotations.append(annotation)
                        uiView.addAnnotation(annotation)
                    }
                    self.update = false
                    self.getDirctions(uiView)
            }
        }
        }
        if preview {
            if challenge.checkpoints.count != uiView.annotations.count {
                uiView.removeAnnotations(uiView.annotations)
                for check in challenge.checkpoints {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: check.latitude, longitude: check.longitude)
                    uiView.addAnnotation(annotation)
            }
                uiView.removeOverlays(uiView.overlays)
                       getDirctions(uiView)
        }
    }
        else if annotations.count != uiView.annotations.count {
             
            uiView.removeAnnotations(uiView.annotations)
            for annotation in annotations {
                uiView.addAnnotation(annotation)
            }
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
            if parent.preview {
                pin.isDraggable = false
            }
            else {
                pin.isDraggable = true
            }
            pin.pinTintColor = .blue
            pin.animatesDrop = false
            return pin
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
}


