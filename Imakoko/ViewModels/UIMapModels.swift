//
//  UIMapModels.swift
//  Imakoko
//
//  Created by t&a on 2022/09/07.
//

import SwiftUI
import MapKit

// Swift UIでは実装できない地図機能を実装する
// UIMapAddressGetView：長押し位置の住所を取得
// MARK: -

// アノテーション用クラス
class LocationPin: NSObject, MKAnnotation {
    
    var title: String?
    var latitude: Double  // 緯度
    var longitude: Double // 経度
    // 座標
    var coordinate:CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(title:String, latitude: Double ,longitude: Double) {
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
    }
}

// MARK: - タップした住所を取得


struct UIMapAddressGetView: UIViewRepresentable {
    
    
    @State var mapView = MKMapView()
    @State var tapped:Bool = false   // タップしたかどうか
    @Binding var tapAddress:String   // タップされた住所を格納
    @StateObject var locationManager = LocationManager.shared
    
    func makeUIView(context: Self.Context) -> MKMapView {
        
        let region = locationManager.region
        
        let gesture = UILongPressGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.longTapped(_:))
        )
        mapView.addGestureRecognizer(gesture)
        mapView.region = region
        
        let currentPin = LocationPin(title: "",latitude:region.center.latitude, longitude: region.center.longitude)
        mapView.addAnnotation(currentPin)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Self.Context) {
        // ビュー更新時にタップかつリセット(CurrentMapVieewのHeaderボタンを押下)されていれば
        if tapped == true && tapAddress == ""{
            // アノテーションリセット
            if !mapView.annotations.isEmpty{
                mapView.removeAnnotation(mapView.annotations[0])
            }
            // 現在地をセット
            let region = locationManager.region
            let currentPin = LocationPin(title: "",latitude:region.center.latitude, longitude: region.center.longitude)
            mapView.addAnnotation(currentPin)
            mapView.region = region
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self,mapView:$mapView,tapped: $tapped,tapAddress:$tapAddress)
    }

}

extension UIMapAddressGetView{
    class Coordinator: NSObject {
        
        var control: UIMapAddressGetView
        
        @Binding var mapView: MKMapView
        @Binding var tapped: Bool
        @Binding var tapAddress: String
        
        @State var geocoder = CLGeocoder()
        
        init(_ control: UIMapAddressGetView,mapView:Binding<MKMapView>,tapped:Binding<Bool>,tapAddress:Binding<String>){
            self.control = control
            _mapView = mapView
            _tapped = tapped
            _tapAddress = tapAddress
        }
        
        // 長押しされた時に実行されるメソッド
        @objc func longTapped(_ gesture: UILongPressGestureRecognizer) {
            
            
            let viewPoint = gesture.location(in: mapView)
            let mapCoordinate: CLLocationCoordinate2D = mapView.convert(viewPoint, toCoordinateFrom:mapView)
            let tapAnotation = LocationPin(title: "",latitude:mapCoordinate.latitude, longitude: mapCoordinate.longitude)
            
            if !mapView.annotations.isEmpty{
                mapView.removeAnnotation(mapView.annotations[0])
            }
            
            geocoder.reverseGeocodeLocation(CLLocation(latitude: mapCoordinate.latitude, longitude: mapCoordinate.longitude)) { [weak self] placemarks, error in
                guard let self else { return }
                if let placemark = placemarks?.first {
                    //住所
                    //住所
                    let administrativeArea = placemark.administrativeArea ?? ""
                    let locality = placemark.locality ?? ""
                    let subLocality = placemark.subLocality ?? ""
                    let thoroughfare = placemark.thoroughfare ?? ""
                    let subThoroughfare =  placemark.subThoroughfare ?? ""
                    let placeName = !thoroughfare.contains(subLocality) ? subLocality + thoroughfare : thoroughfare
                    self.tapAddress = administrativeArea + locality + placeName + subThoroughfare
                    if self.tapAddress.isEmpty {
                        self.tapAddress = "取得できないエリアです..."
                    }
                }
            }
            self.tapped = true
            
            mapView.addAnnotation(tapAnotation)
        }
        
    }
}
