//
//  ViewController.swift
//  map2022
//
//  Created by 佐川駿介 on 2022/01/15.
//

import UIKit
import MapKit
import Photos
import AVFAudio

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
    {
    var myLock = NSLock()  // 排他制御
    let goldenRatio = 1.618  // 拡大縮小の比率
    var player0:AVAudioPlayer?

    @IBOutlet var mapView : MKMapView!
    @IBOutlet var zoomInButton : UIButton!
    @IBOutlet var zoomOutButtom: UIButton!
    var vHeight = UIScreen.main.bounds.size.height//viewHeight
    var vWidth = UIScreen.main.bounds.size.width

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.prepareMapView()
        self.checkAuthorizationStatus()
        mapView.delegate = self
        
        zoomInButton.frame  = CGRect(x:vWidth*0.8, y:vHeight*0.73, width:50, height:50)
        zoomOutButtom.frame = CGRect(x:vWidth*0.8, y:vHeight*0.81, width:50, height:50)
        
//    // 再生する音声ファイルを指定する
//        let url = Bundle.main.bundleURL.appendingPathComponent("bgm.mp3")
//        do {
//            try player0 = AVAudioPlayer(contentsOf: url)
//        } catch {
//            print("Error")
//        }
//        player0!.play()
//        //音声をループさせる
//        player0!.numberOfLoops = -1
    }
    
    
    
    
    
    private func prepareMapView() {
//        回転するかと、3D表示
        self.mapView.isRotateEnabled = false
        self.mapView.isPitchEnabled = false
        self.mapView.delegate = self
        
        // 東京駅の位置情報を設定（緯度: 35.681236 経度: 139.767125）
        let latitude = 35.681236
        let longitude = 139.767125
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        mapView.setCenter(location, animated:true)
    }
    
// フォトライブラリへのアクセス権
    private func checkAuthorizationStatus() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            self.prepareAnnotations()
        default:
            PHPhotoLibrary.requestAuthorization{ status in
                if status == .authorized {
                    self.prepareAnnotations()
                }
            }
        }
    }
    
    
    
//画像取得→一枚ずつ情報取得→PHAsset型が取れた→assetに位置情報が入ってた→mapViewのその位置にピンを置く
    private func prepareAnnotations() {
        let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil) //PHAssetクラスのメソッド。メディアタイプを指定してアセット取得
        fetchResult.enumerateObjects ({result, index, stop in
            if let asset = result as? PHAsset {
                // PHAsset型のオブジェクトが取り出せた場合の処理
                if asset.location != nil {
                    let annotation = PhotoAnnotation(asset: asset)
                    self.mapView.addAnnotation(annotation)
                    
                }
            }
        })
        
    }

 
    
//dequeで未使用のピンを探す
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let photoAnnotation = annotation as? PhotoAnnotation
        let photoAnnotationViewID = "photoAnnotationView"
        var photoAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: photoAnnotationViewID) as? PhotoAnnotationView
        
        if photoAnnotationView == nil {
            photoAnnotationView = PhotoAnnotationView.init(annotation: photoAnnotation, reuseIdentifier: photoAnnotationViewID)
        }
        //photoAnnotationのimageがnilでなければphotoAnnotationViewのimageにセットする
        if let image = photoAnnotation?.image {
            photoAnnotationView?.image = image
        } else {
            let screenScale = UIScreen.main.scale
            let targetSize = CGSize(
                width: PhotoAnnotationView.size.width * screenScale,
                height: PhotoAnnotationView.size.height * screenScale)
            
            PHImageManager().requestImage(
                for: (photoAnnotation?.asset)!,
                targetSize: targetSize,
                contentMode: .aspectFill,
                options: nil,
                resultHandler: {(image, info) -> Void in
                    photoAnnotation?.image = image;
                    photoAnnotationView?.thumbnailImage = image;
                }
            )
        }
        return photoAnnotationView
    }

    
//ピンが選択された時にセンターに移動する
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let coordinate :CLLocationCoordinate2D = view.annotation!.coordinate
        var region :MKCoordinateRegion = mapView.region
        region.center = coordinate
        mapView.setRegion(region, animated: true)
    }



    
//ズームイン
    @IBAction func clickZoomin(_ sender: Any) {
        print("clickZoomin")
        myLock.lock()
        if (0.005 < mapView.region.span.latitudeDelta / goldenRatio) {
            print("latitudeDelta-1 : " + mapView.region.span.latitudeDelta.description)
            var regionSpan:MKCoordinateSpan = MKCoordinateSpan()
            regionSpan.latitudeDelta = mapView.region.span.latitudeDelta / goldenRatio
            mapView.region.span = regionSpan
            print("latitudeDelta-2 : " + mapView.region.span.latitudeDelta.description)
        }
        myLock.unlock()
    }
//ズームアウト
    @IBAction func clickZoomout(_ sender: Any) {
        print("clickZoomout")
        myLock.lock()
        if (mapView.region.span.latitudeDelta * goldenRatio < 150.0) {
            print("latitudeDelta-1 : " + mapView.region.span.latitudeDelta.description)
            var regionSpan:MKCoordinateSpan = MKCoordinateSpan()
            regionSpan.latitudeDelta = mapView.region.span.latitudeDelta * goldenRatio
            mapView.region.span = regionSpan
            print("latitudeDelta-2 : " + mapView.region.span.latitudeDelta.description)
        }
        myLock.unlock()
    }
    
    
}
