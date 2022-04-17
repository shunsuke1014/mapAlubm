//
//  PhotoAnnotation.swift
//  map2022
//
//  Created by 佐川駿介 on 2022/01/15.
//

import UIKit
import MapKit
import Photos
import Foundation

class PhotoAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    var address :String?
    var image :UIImage?
    
    
    
    
    let asset :PHAsset?
    
    
    
    init(asset aAsset:PHAsset) {
        asset = aAsset
        coordinate = aAsset.location!.coordinate
        super.init()
        
//        self.executeGeocode()
    }
    
//    private func executeGeocode() {
//        if let aAsset = self.asset {
//            CLGeocoder().reverseGeocodeLocation(
//                aAsset.location!,
//                completionHandler: {(placemarks, error) -> Void in
//                    if error == nil && placemarks!.count > 0 {
//                        if let placemark = placemarks?.first as? CLPlacemark {
//                            self.title = placemark.name
//                            self.subtitle = (placemark.administrativeArea ?? "") + (placemark.locality ?? "")
//                            self.address = (self.subtitle ?? "") + (placemark.thoroughfare ?? "")
//                        }
//                    }
//                }
//            )
//        }
//    }
}
