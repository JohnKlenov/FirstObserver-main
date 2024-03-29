//
//  MapViewManager.swift
//  FirstObserver
//
//  Created by Evgenyi on 13.11.22.
//

import UIKit
import MapKit
import FirebaseStorage
import FirebaseStorageUI


protocol MapViewManagerDelegate: AnyObject {
    func selectAnnotationView(isSelect: Bool)
}

class CustomMapView: MKMapView {

    
    var regionMap: CLLocationDistance = 18000
    
    var arrayPin:[Places] = [] {
        didSet {
            addAnnotations(arrayPin)
        }
    }
    weak var delegateMap: MapViewManagerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(" override init(frame: CGRect) ")
        delegate = self
//        calculateRegion()
        isZoomEnabled = false
        isScrollEnabled = false
        isPitchEnabled = false
        isRotateEnabled = false
        
        let initialLocation = CLLocation(latitude: 53.903318, longitude: 27.560448)
        self.centerLocation(initialLocation, regionRadius: regionMap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//       print(" override func awakeFromNib()")
//        delegate = self
//        calculateRegion()
//        isZoomEnabled = false
//        isScrollEnabled = false
//        isPitchEnabled = false
//        isRotateEnabled = false
//
//        let initialLocation = CLLocation(latitude: 53.903318, longitude: 27.560448)
//        self.centerLocation(initialLocation, regionRadius: regionMap)
//
//    }
    
    
    private func calculateRegion() {
        let onePercent = frame.size.width/100
        // 3.88 это 1% от т екущей ширины на storyboard
        let percentWidth = 100 - frame.size.width/onePercent
        // если > 0 нужно не увеличивать а уменьшать newRegion
        guard percentWidth > 0 else { return }
        let plusPercent:Double = Double(Int(percentWidth))/100
        print(" plusPercent - \(plusPercent)")
        let newRegion = Int(18000*plusPercent*10)
        
        regionMap = CLLocationDistance(newRegion)
    }
    
    
}


extension CustomMapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? Places else { return nil }
        let identifier = "places"
        let view: MKMarkerAnnotationView
        
        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeueView.annotation = annotation
            view = dequeueView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.glyphTintColor = .black
            view.markerTintColor = .red
            
            if let refImage = annotation.imageName {
                let refStorage = Storage.storage().reference(forURL: refImage)
                let imageView = UIImageView()
                imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                imageView.contentMode = .scaleAspectFit
                imageView.sd_setImage(with: refStorage, placeholderImage: UIImage(named: "DefaultImage")) { image, error, cacheType, storageRef in
                    if let error = error {
                        print("error - \(error)")
                    } else {
                        if let image = image {
                            print("image for leftCalloutAccessoryView - \(image)")
                            DispatchQueue.main.async {
                                view.leftCalloutAccessoryView = imageView
                            }
                        }
                    }
                }
            } else {
                view.leftCalloutAccessoryView = UIView()
            }
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        delegateMap?.selectAnnotationView(isSelect: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        delegateMap?.selectAnnotationView(isSelect: false)
    }
}
