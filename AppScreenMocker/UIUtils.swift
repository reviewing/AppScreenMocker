//
//  UIUtils.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/15/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit
import QuartzCore
import Photos

class UIUtils {
    static func UIColorFromARGB(_ argbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((argbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((argbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(argbValue & 0x0000FF) / 255.0,
            alpha: CGFloat((argbValue & 0xFF000000) >> 24) / 255.0
        )
    }
    
    static func imageWithView(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0);
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return image;
    }
    
    static func imageFromAssetURL(_ assetURL: URL, targetSize: CGSize, onComplete:@escaping ((_ image: UIImage?) -> Void)) {
        let asset = PHAsset.fetchAssets(withALAssetURLs: [assetURL], options: nil)
        guard let result = asset.firstObject else {
            return
        }
        
        let options = PHImageRequestOptions()
        options.version = .original
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        
        let imageManager = PHImageManager.default()
        imageManager.requestImage(for: result , targetSize: pointToPixel(targetSize), contentMode: PHImageContentMode.aspectFill, options: options) { (image, dict) -> Void in
            onComplete(image)
        }
    }
    
    static func pointToPixel(_ sizeInPoint: CGSize) -> CGSize {
        var sizeInPixel = sizeInPoint
        sizeInPixel.height *= UIScreen.main.scale
        sizeInPixel.width *= UIScreen.main.scale
        return sizeInPixel
    }
    
    static func rootViewController() -> UIViewController? {
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        while((rootViewController!.presentedViewController) != nil) {
            rootViewController = rootViewController!.presentedViewController
        }
        return rootViewController
    }
}
