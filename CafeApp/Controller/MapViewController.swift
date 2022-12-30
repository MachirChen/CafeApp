//
//  MapViewController.swift
//  CafeApp
//
//  Created by Machir on 2022/8/9.
//

import UIKit
import MapKit
import CoreLocation
import FacebookLogin

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let urlStr = "https://cafenomad.tw/api/v1.2/cafes"
    var cafeAnnotations: [MyPointAnnotation] = []
    var myLocationManager: CLLocationManager!
    var cafe = [Cafe]()
    var button = MKUserTrackingButton()
    var selectAnnotationId: String?
    var selectCafe: Cafe?
    var distance: Double?
    var targetCoordinate = CLLocationCoordinate2D()

//    @objc func fetchTapAnnotationData() {
//        print("tap")
//        self.cafeDetailTableView.reloadData()
//        self.selectCafe = nil
//        self.distance = nil
//    }
    
    @IBOutlet weak var mapViewMKMapView: MKMapView!
    @IBOutlet weak var cafeDetailTableView: UITableView!
    
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { result, error in
            if let error = error {
                print("Encountered Erorr: \(error)")
            } else if let result = result, result.isCancelled {
                print("Cancelled")
            } else {
                print("Logged In")
                Profile.loadCurrentProfile { profile, error in
                    if let firstName = profile?.firstName,
                       let photo = profile?.lastName {
                        print(firstName)
                        print(photo)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //自訂登入FB按鈕
//        let loginButton = UIButton(type: .custom)
//        loginButton.backgroundColor = .darkGray
//        loginButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
//        loginButton.center = view.center
//        loginButton.setTitle("My Login Button", for: .normal)
//
//        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
//        view.addSubview(loginButton)
//
//        //檢查FB登入狀態
//        if let token = AccessToken.current,
//           !token.isExpired {
//            print("yes")
//        }
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(fetchTapAnnotationData))
        //self.mapViewMKMapView.addGestureRecognizer(tap)
        
        mapViewMKMapView.overrideUserInterfaceStyle = .light
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
                        let pointAnnotation = MyPointAnnotation()
                        
                        pointAnnotation.title = cafe[i].name
                        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: Double(cafe[i].latitude)!, longitude: Double(cafe[i].longitude)!)
                        pointAnnotation.subtitle = cafe[i].address
                        pointAnnotation.id = cafe[i].id
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
        let fullScreenSize = UIScreen.main.bounds.size
        print(fullScreenSize,"Map尺寸")
        button.mapView = mapViewMKMapView
        button.backgroundColor = .white
        button.tintColor = .black
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.center = CGPoint(x: fullScreenSize.width * 0.9, y: fullScreenSize.height * 0.52)
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
        
        guard let annotation = annotation as? MyPointAnnotation else {
            return nil
        }
        
//        if annotation.isKind(of: MKUserLocation.self) {
//            return nil
//        }

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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("\(view)風景")
        
        
        self.targetCoordinate = view.annotation!.coordinate
        self.getDistance()
        let data  = view.annotation as? MyPointAnnotation
        print(data?.id)
        selectAnnotationId = data?.id ?? nil
        print(self.selectAnnotationId)
        
        for i in 0..<cafe.count {
            if cafe[i].id == selectAnnotationId {
                print(cafe[i].id)
                self.selectCafe = cafe[i]
                print(self.selectCafe?.name)
            }
        }
//        if self.selectCafe != nil {
//            let name = MenuController.NotificationName
//            NotificationCenter.default.post(name: name, object: nil, userInfo: ["cafe" : selectCafe!])
//            print("有值")
//        }
        self.cafeDetailTableView.reloadData()
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

        let options = ["導航", "詳細資訊"]

        for title in options {
            let action = UIAlertAction(title: title, style: .default) { _ in
                switch title {
                case "導航":
                    self.navigation()
                case "詳細資訊":
                    self.performSegue(withIdentifier: "MapViewControllerToCafeDetailTableViewController", sender: nil)
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
    
    //取得目前位置與目標位置距離
    func getDistance() {
        let myPoint = CLLocation(latitude: (self.myLocationManager.location?.coordinate.latitude)!, longitude: (myLocationManager.location?.coordinate.longitude)!)
        let centerPoint = CLLocation(latitude: targetCoordinate.latitude, longitude: targetCoordinate.longitude)
        let distance = centerPoint.distance(from: myPoint)
        self.distance = distance
        print("我的位置\(myPoint), 目標位置\(centerPoint)")
        print("距離", distance)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? CafeDetailTableViewController
        controller?.cafeData = selectCafe
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

extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch distance {
            
        case .none:
            return ""
        case .some(_):
            if self.distance! >= 1000 {
                return "距離\(String(format: "%.1f", (self.distance! / 1000)))公里"
            } else {
                return "距離\(String(format: "%.0f", self.distance!))公尺"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MapTableViewCell.self)", for: indexPath) as! MapTableViewCell
        
        switch selectCafe?.wifi {
        case 0:
            cell.storeWifiLabel.text = "☆☆☆☆☆"
        case 0.5, 1:
            cell.storeWifiLabel.text = "★☆☆☆☆"
        case 1.5, 2:
            cell.storeWifiLabel.text = "★★☆☆☆"
        case 2.5, 3:
            cell.storeWifiLabel.text = "★★★☆☆"
        case 3.5, 4:
            cell.storeWifiLabel.text = "★★★★☆"
        case 4.5, 5:
            cell.storeWifiLabel.text = "★★★★★"
        default:
            cell.storeWifiLabel.text = "☆☆☆☆☆"
        }
        
        switch selectCafe?.seat {
        case 0:
            cell.storeSeatLabel.text = "☆☆☆☆☆"
        case 0.5, 1:
            cell.storeSeatLabel.text = "★☆☆☆☆"
        case 1.5, 2:
            cell.storeSeatLabel.text = "★★☆☆☆"
        case 2.5, 3:
            cell.storeSeatLabel.text = "★★★☆☆"
        case 3.5, 4:
            cell.storeSeatLabel.text = "★★★★☆"
        case 4.5, 5:
            cell.storeSeatLabel.text = "★★★★★"
        default:
            cell.storeSeatLabel.text = "☆☆☆☆☆"
        }
        
        switch selectCafe?.quiet {
        case 0:
            cell.storeQuietLabel.text = "☆☆☆☆☆"
        case 0.5, 1:
            cell.storeQuietLabel.text = "★☆☆☆☆"
        case 1.5, 2:
            cell.storeQuietLabel.text = "★★☆☆☆"
        case 2.5, 3:
            cell.storeQuietLabel.text = "★★★☆☆"
        case 3.5, 4:
            cell.storeQuietLabel.text = "★★★★☆"
        case 4.5, 5:
            cell.storeQuietLabel.text = "★★★★★"
        default:
            cell.storeQuietLabel.text = "☆☆☆☆☆"
        }
        
        switch selectCafe?.tasty {
        case 0:
            cell.storeTastyLabel.text = "☆☆☆☆☆"
        case 0.5, 1:
            cell.storeTastyLabel.text = "★☆☆☆☆"
        case 1.5, 2:
            cell.storeTastyLabel.text = "★★☆☆☆"
        case 2.5, 3:
            cell.storeTastyLabel.text = "★★★☆☆"
        case 3.5, 4:
            cell.storeTastyLabel.text = "★★★★☆"
        case 4.5, 5:
            cell.storeTastyLabel.text = "★★★★★"
        default:
            cell.storeTastyLabel.text = "☆☆☆☆☆"
        }
        
        switch selectCafe?.cheap {
        case 0:
            cell.storeCheapLabel.text = "☆☆☆☆☆"
        case 0.5, 1:
            cell.storeCheapLabel.text = "★☆☆☆☆"
        case 1.5, 2:
            cell.storeCheapLabel.text = "★★☆☆☆"
        case 2.5, 3:
            cell.storeCheapLabel.text = "★★★☆☆"
        case 3.5, 4:
            cell.storeCheapLabel.text = "★★★★☆"
        case 4.5, 5:
            cell.storeCheapLabel.text = "★★★★★"
        default:
            cell.storeCheapLabel.text = "☆☆☆☆☆"
        }
        
        switch selectCafe?.music {
        case 0:
            cell.storeMusicLabel.text = "☆☆☆☆☆"
        case 0.5, 1:
            cell.storeMusicLabel.text = "★☆☆☆☆"
        case 1.5, 2:
            cell.storeMusicLabel.text = "★★☆☆☆"
        case 2.5, 3:
            cell.storeMusicLabel.text = "★★★☆☆"
        case 3.5, 4:
            cell.storeMusicLabel.text = "★★★★☆"
        case 4.5, 5:
            cell.storeMusicLabel.text = "★★★★★"
        default:
            cell.storeMusicLabel.text = "☆☆☆☆☆"
        }
        
        return cell
    }
    
}


