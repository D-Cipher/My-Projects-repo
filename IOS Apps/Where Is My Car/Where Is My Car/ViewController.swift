//
//  ViewController.swift
//  Where Is My Car
//
//  Created by Tingbo Chen on 1/14/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/*
To Set Up User location:
-Build Phases > Link Binary With Libraries > + > CoreLocation.framework
-In "Info.plist" add:
-NSLocationWhenInUseUsageDescription  Type: String, Value: Would you like to share your location?
-NSLocationAlwaysUsageDescription  Type: String, Value: Are you allowing app to access your location?
*/

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate{

    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var saveButtonOutlet: UIBarButtonItem!
    
    @IBOutlet var statusOutlet: UILabel!
    
    let locationManager = CLLocationManager()
    
    //var places_dict = Dictionary<String,Array<String>>()
    var places_dict = Dictionary<String,String>()
    
    var savedArray: [AnyObject] = []
    
    @IBAction func saveButtonAction(sender: AnyObject) {
        
        if self.places_dict["name"] != nil {
            self.savedArray.append(self.places_dict)
            //self.savedArray = [] //for clearing saved object
            
            NSUserDefaults.standardUserDefaults().setObject(self.savedArray, forKey: "savedArray")
            
            let temptext = self.statusOutlet.text
            
            self.statusOutlet.text = ("Saved: " + temptext!)
            
            //print(self.savedArray) //for testing
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gets the Saved Data
        if NSUserDefaults().objectForKey("savedArray") != nil {
            self.savedArray = NSUserDefaults().objectForKey("savedArray")! as! NSArray as [AnyObject] //Converting back to Array
        }
        
        //Create Map
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.Standard
        
        if activePlace_GLOBAL == -1 { //If user is adding a new place
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
        
        } else { //If user is viewing a saved place
            
            self.statusOutlet.text = String(self.savedArray[activePlace_GLOBAL]["name"]!!)
            
            //Get selected latitude and longitude
            let latitude = NSString(string: String(self.savedArray[activePlace_GLOBAL]["lat"]!!)).doubleValue
            let longitude = NSString(string: String(self.savedArray[activePlace_GLOBAL]["long"]!!)).doubleValue
            //print(latitude) // for testing
            
            //Centralize the view
            let place_location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: place_location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            
            //Remove existing Annotations
            let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
            mapView.removeAnnotations(annotationsToRemove)
            
            //Adds an Annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = place_location
            self.mapView.addAnnotation(annotation)
            
            
        }
        
        /*
        //Allowing User to add Annotation
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 1.5
        self.mapView.addGestureRecognizer(uilpgr)
        */
        
    }
    
    /*
    override func viewDidAppear(animated: Bool) {
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        
        mapView.removeAnnotations(annotationsToRemove)
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Functions allow User to drag annotation:
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.draggable = true
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        //Date Extraction
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Day , .Month , .Year, .Hour, .Minute], fromDate: date)
        
        if newState == MKAnnotationViewDragState.Ending {
            let droppedAt = view.annotation?.coordinate
            
            //print(droppedAt!.latitude)
            //print(droppedAt!.longitude)
            
            //Reverse Geocoder to get the address:
            let location_lookup = CLLocation(latitude: droppedAt!.latitude, longitude: droppedAt!.longitude)
            CLGeocoder().reverseGeocodeLocation(location_lookup) { (placemarks, error) -> Void in
                var title = ""
                
                if(error == nil) {
                    if let p = placemarks?[0] {
                        var subThoroughfare: String = ""
                        var thoroughfare: String = ""
                        
                        if p.subThoroughfare != nil {
                            subThoroughfare = p.subThoroughfare!
                        }
                        if p.thoroughfare != nil {
                            thoroughfare = p.thoroughfare!
                        }
                        
                        title = "\(subThoroughfare) \(thoroughfare)"
                    }
                }
                if title == "" || title == " " {
                    title = "Unknown Address"
                    
                }
                
                self.places_dict = ["name":String(dateComponents.month)+"/"+String(dateComponents.day)+" "+String(dateComponents.hour)+":"+String(dateComponents.minute)+", "+title,"lat":String(droppedAt!.latitude),"long":String(droppedAt!.longitude)]
                
                self.statusOutlet.text = title

                //print(self.places_dict) //for testing
                //print(self.places_dict["name"]!)
            }
        }
    }

    //Function for Updating User location to center on User:
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Location Zoom
        let location = locations.last
        let user_location = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: user_location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        
        //Stops updating
        self.locationManager.stopUpdatingLocation()
        
        //Remove existing Annotations
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations(annotationsToRemove)
        
        //Adds an Annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = user_location
        //annotation.title = "New Place"
        //annotation.subtitle = "One day I'll own here..."
        self.mapView.addAnnotation(annotation)
        
        //Date Extraction
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Day , .Month , .Year, .Hour, .Minute], fromDate: date)
        
        //Reverse Geocoder to get the address:
        let location_lookup = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location_lookup) { (placemarks, error) -> Void in
            var title = ""
            
            if(error == nil) {
                if let p = placemarks?[0] {
                    var subThoroughfare: String = ""
                    var thoroughfare: String = ""
                    
                    if p.subThoroughfare != nil {
                        subThoroughfare = p.subThoroughfare!
                    }
                    if p.thoroughfare != nil {
                        thoroughfare = p.thoroughfare!
                    }
                    
                    title = "\(subThoroughfare) \(thoroughfare)"
                }
            }
            if title == "" || title == " " {
                title = "Unknown Address"
                
            }
            
            self.places_dict = ["name":String(dateComponents.month)+"/"+String(dateComponents.day)+" "+String(dateComponents.hour)+":"+String(dateComponents.minute)+", "+title,"lat":String(annotation.coordinate.latitude),"long":String(annotation.coordinate.longitude)]
            
            self.statusOutlet.text = title
            
            //print(self.places_dict) //for testing
            //print(self.places_dict["name"]!)
            
        }
    }
    
}