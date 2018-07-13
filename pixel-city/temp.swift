//
//  MapVC.swift
//  pixel-city
//
//  Created by Gurpreet Bhoot on 7/12/18.
//  Copyright © 2018 Gurpal Bhoot. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, UIGestureRecognizerDelegate {

    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLbl: UIView!
    @IBOutlet weak var currentLocationBtn: UIButton!
    @IBOutlet weak var pullUpViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pullUpView: UIView!

    // Managers
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000

    var spinner: UIActivityIndicatorView?
    var progressLbl: UILabel?

    // When you do this programmatically, you need programmatically provide a UI collection view flow layout as well
    var flowLayout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Delegats
        mapView.delegate = self
        locationManager.delegate = self
        configureLocationServices()

        addDoubleTap()

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)

//        pullUpView.addSubview(collectionView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(MapVC.dropPin(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
    }

    func addSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(MapVC.animateViewDown))
        swipe.direction = .down
        pullUpView.addGestureRecognizer(swipe)
    }

    func animateViewUp() {
        pullUpViewHeight.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func addSpinner() {
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: ((collectionView?.layer.bounds.width)! / 2) - ((spinner?.frame.width)! / 2), y: ((collectionView?.layer.bounds.height)! / 2) - ((spinner?.frame.height)! / 2))
        spinner?.activityIndicatorViewStyle = .whiteLarge
        spinner?.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        spinner?.startAnimating()
        pullUpView.addSubview(spinner!)
    }

    func removeSpinner() {
        if spinner != nil {
//            spinner?.stopAnimating()
            spinner?.removeFromSuperview()
        }
    }

    func addProgressLbl() {
        progressLbl = UILabel()
        progressLbl?.frame = CGRect(x: ((view.layer.bounds.width) / 2) - CGFloat(PULL_UP_VIEW_LBL_WIDTH / 2), y: (spinner?.layer.bounds.origin.y)!, width: CGFloat(PULL_UP_VIEW_LBL_WIDTH), height: CGFloat(PULL_UP_VIEW_LBL_HEIGHT))
        progressLbl?.font = UIFont(name: "Avenir", size: 18)
        progressLbl?.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        progressLbl?.textAlignment = .center
        progressLbl?.text = "12/40 PHOTOS LOADED..."
        pullUpView.addSubview(progressLbl!)
    }

    func removeProgressLbl() {
        if progressLbl != nil {
            progressLbl?.removeFromSuperview()
        }
    }

    @objc func animateViewDown() {
        removeOutletInstances()
        pullUpViewHeight.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

    }

    // IBActions
    @IBAction func currentLocationBtnPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
}

// Does the same thing as inheriting the MKMapViewDelegate at the top in Class instance
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 0.9647058824, green: 0.6509803922, blue: 0.137254902, alpha: 1)
        pinAnnotation.animatesDrop = true

        return pinAnnotation
    }

    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        setRegion(coordinate: coordinate)
    }

    @objc func dropPin(sender: UITapGestureRecognizer) {
        removeOutletInstances()

        animateViewUp()
        addOutletInstances()

        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation)

        setRegion(coordinate: touchCoordinate)
    }

    func removePin() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    }

    func setRegion(coordinate: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)

        mapView.setRegion(coordinateRegion, animated: true)
    }

    func addOutletInstances() {
        addSwipe()
        addSpinner()
        addProgressLbl()
    }

    func removeOutletInstances() {
        removePin()
//        removeSpinner()
        removeProgressLbl()
    }
}

extension MapVC: CLLocationManagerDelegate {
    func configureLocationServices()  {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
}

extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // number of items (photos)
        return 4
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell
        return cell!
    }
}
