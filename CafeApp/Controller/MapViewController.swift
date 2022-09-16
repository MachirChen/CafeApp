//
//  MapViewController.swift
//  CafeApp
//
//  Created by Machir on 2022/8/9.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let urlStr = "https://cafenomad.tw/api/v1.2/cafes"
    var cafeAnnotations: [MKPointAnnotation] = []
    var myLocationManager: CLLocationManager!
    var cafe = [Cafe]()
    var button = MKUserTrackingButton()
    
    var targetCoordinate = CLLocationCoordinate2D()
    @IBOutlet weak var mapViewMKMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setupManager()
        setupLocationButton()
        
        mapViewMKMapView.delegate = self
        
        MenuController.shared.fetchData(urlStr: urlStr) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cafe):
                    print("成功---")
                    self.cafe = cafe
                    for i in 0...(cafe.count - 1) {
                        let pointAnnotation = MKPointAnnotation()
                        
                        pointAnnotation.title = cafe[i].name
                        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: Double(cafe[i].latitude)!, longitude: Double(cafe[i].longitude)!)
                        pointAnnotation.subtitle = cafe[i].address
                        
                        self.cafeAnnotations.append(pointAnnotation)
                    }
                    
                    self.mapViewMKMapView.addAnnotations(self.cafeAnnotations)
                case .failure(let error):
                    print("失敗---\(error)")
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if CLLocationManager.authorizationStatus() == .notDetermined {
//            myLocationManager.requestWhenInUseAuthorization()
//            myLocationManager.startUpdatingLocation()
//        } else if CLLocationManager.authorizationStatus() == .denied {
//            let alertController = UIAlertController(title: "定位權限已關閉", message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
//            alertController.addAction(okAction)
//            present(alertController, animated: true)
//        } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//            myLocationManager.startUpdatingLocation()
//        }
        
        if myLocationManager.authorizationStatus == .authorizedWhenInUse {
            myLocationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //停止定位
        myLocationManager.stopUpdatingLocation()
    }
    
    //定位button
    func setupLocationButton() {
        let fullScreenSize = UIScreen.main.bounds
        button.mapView = mapViewMKMapView
        button.backgroundColor = .white
        button.tintColor = .black
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.center = CGPoint(x: fullScreenSize.width * 0.9, y: fullScreenSize.height * 0.8)
        mapViewMKMapView.addSubview(button)
    }
    
    //定位功能
    func setupManager() {
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        myLocationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        switch myLocationManager.authorizationStatus {
        case .denied:
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "定位權限已關閉", message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
        case .authorizedWhenInUse:
            DispatchQueue.main.async {
                let currentRegion:MKCoordinateRegion =
                MKCoordinateRegion(center: self.myLocationManager.location!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                self.mapViewMKMapView.setRegion(currentRegion, animated: true)
            }
        default:
            break
        }
    }
    
    //修改定位權限會跳出警告
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch myLocationManager.authorizationStatus {
        case .denied:
            let alertController = UIAlertController(title: "定位權限已關閉", message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        case .authorizedWhenInUse:
            myLocationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    //移動TenMeters將觸發func重新定位
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation: CLLocation = locations[locations.count - 1] as CLLocation
        
        if currentLocation.horizontalAccuracy > 0 {
            myLocationManager.stopUpdatingLocation()
            print("\(currentLocation.coordinate.latitude)")
            print(", \(currentLocation.coordinate.longitude)")
        }
    }
    
    //定位錯誤處理
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    //設定大頭針
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }

        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        let button = UIButton(type: .detailDisclosure)
        button.addTarget(self, action: #selector(checkDetail), for: .touchUpInside)
        
        annotationView?.canShowCallout = true
        annotationView?.titleVisibility = .adaptive
        annotationView?.subtitleVisibility = .visible
        annotationView?.markerTintColor = .orange
        annotationView?.rightCalloutAccessoryView = button
        
        //let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
        //leftIconView.image = UIImage(named: "car.fill")
        //annotationView?.leftCalloutAccessoryView = leftIconView
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            self.targetCoordinate = view.annotation!.coordinate
        }
    }
    
    func navigation() {
        let targetPlacemark = MKPlacemark(coordinate: targetCoordinate)
        let targetItem = MKMapItem(placemark: targetPlacemark)
        let userMapItem = MKMapItem.forCurrentLocation()
        let routes = [userMapItem, targetItem]
        
        MKMapItem.openMaps(with: routes, launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    @objc func checkDetail() {
        let alert = UIAlertController(title: "選擇功能", message: nil, preferredStyle: .actionSheet)

        let options = ["導航"]

        for title in options {
            let action = UIAlertAction(title: title, style: .default) { _ in
                switch title {
                case "導航":
                    self.navigation()
                default:
                    break
                }
            }
            alert.addAction(action)
        }
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
