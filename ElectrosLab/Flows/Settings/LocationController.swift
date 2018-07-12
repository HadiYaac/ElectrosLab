//
//  LocationController.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 21/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class LocationController: UIViewController {
    var mapView: GMSMapView?
    let locationString = "comgooglemaps://?daddr=33.8505170,35.5141070&zoom=12&views=traffic"
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Our Location"
        addMapView()
        addNavigationBarButton()
    }
    
    func addMapView() {
        mapView = view as? GMSMapView
        let location = CLLocationCoordinate2D(latitude: 33.8505170, longitude: 35.5141070)
        let marker = GMSMarker(position: location)
        marker.snippet = "ElectroSLab"
        marker.map = mapView
        mapView?.camera = GMSCameraPosition(target: location, zoom: 12.0, bearing: 0, viewingAngle: 0)
    }
    
    func addNavigationBarButton() {
        let navBarBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMapLocation))
        navigationItem.rightBarButtonItem = navBarBtn
    }
    
    @objc func shareMapLocation() {
        let actionSheet = UIAlertController(title: "", message: "Select Map", preferredStyle: .actionSheet)
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            let googleMapsAction = UIAlertAction(title: "Google Maps", style: .default, handler: { (action) in
                UIApplication.shared.open(URL(string: self.locationString)!, options: [:], completionHandler: { (didOpen) in
                    
                })
            })
            actionSheet.addAction(googleMapsAction)
        }
        
        let appleMapsAction = UIAlertAction(title: "Apple Maps", style: .default) { (action) in
            self.openAppleMaps()
        }
        actionSheet.addAction(appleMapsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    func openAppleMaps() {
        
        let latitude: CLLocationDegrees = 33.8499340
        let longitude: CLLocationDegrees = 35.5140190
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "ElectroSLab"
        mapItem.openInMaps(launchOptions: options)
        
    }
}
