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
    static func UIColorFromARGB(argbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((argbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((argbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(argbValue & 0x0000FF) / 255.0,
            alpha: CGFloat((argbValue & 0xFF000000) >> 24) / 255.0
        )
    }
    
    static func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    
    static func imageFromAssetURL(assetURL: NSURL, targetSize: CGSize, onComplete:((image: UIImage?) -> Void)) {
        let asset = PHAsset.fetchAssetsWithALAssetURLs([assetURL], options: nil)
        guard let result = asset.firstObject where result is PHAsset else {
            return
        }
        
        let imageManager = PHImageManager.defaultManager()
        imageManager.requestImageForAsset(result as! PHAsset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (image, dict) -> Void in
            onComplete(image: image)
        }
    }
    
    static func rootViewController() -> UIViewController? {
        var rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        while((rootViewController!.presentedViewController) != nil) {
            rootViewController = rootViewController!.presentedViewController
        }
        return rootViewController
    }
}