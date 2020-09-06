//
//  MapPage.swift
//  Virtual Challenge
//
//  Created by Mac on 05/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//

import SwiftUI
import MapKit


struct MapPage: UIViewRepresentable {
    
    
    //from new tutorial
    var locationManager = CLLocationManager()
    func setupManager() {
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestWhenInUseAuthorization()
      locationManager.requestAlwaysAuthorization()
    }
    
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: 34.011286, longitude: -116.166868)
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
    }
}

struct MapPage_Previews: PreviewProvider {
    static var previews: some View {
        MapPage()
    }
}
