//
//  SudokuView.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 9/1/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit
import Material

class SudokuView: UIView {
    let imageWidth: CGFloat = 80
    let imageMargin: CGFloat = 5
    var imageViews = [UIImageView]()

    var imageUrls = [NSURL]() {
        didSet {
            if oldValue.count != imageUrls.count {
                let oldImageViewCount = imageViews.count
                if imageViews.count < imageUrls.count {
                    for _ in 0..<imageUrls.count - oldImageViewCount {
                        let imageView = UIImageView()
                        imageView.backgroundColor = MaterialColor.black
                        imageView.tag = ViewID.BodyPhoto.rawValue
                        imageViews.append(imageView)
                        self.addSubview(imageView)
                    }
                } else if oldImageViewCount > imageUrls.count {
                    for _ in imageUrls.count..<oldImageViewCount {
                        let imageView = imageViews.removeLast()
                        imageView.removeFromSuperview()
                    }
                }
                
                self.updateConstraints()
            }
            
            for i in 0..<imageUrls.count {
                if i < oldValue.count && oldValue[i] === imageUrls[i] {
                    continue
                }
                
                let originalUrl = imageUrls[i]
                UIUtils.imageFromAssetURL(originalUrl, targetSize: CGSizeMake(imageWidth, imageWidth), onComplete: { (image) in
                    if self.imageUrls[i] == originalUrl {
                        self.imageViews[i].image = image
                    }
                })
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateConstraints()
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    override func updateConstraints() {
        for i in 0..<imageViews.count {
            self.snp_makeConstraints { make in
                make.top.equalTo(imageViews[0])
                make.left.equalTo(imageViews[0])
                make.width.equalTo(3 * imageWidth + 2 * imageMargin)
            }
            
            imageViews[i].snp_makeConstraints { make in
                make.width.height.equalTo(imageWidth)
            }
            
            switch i {
            case 0..<3:
                imageViews[i].snp_makeConstraints { make in
                    make.top.equalTo(self)
                    make.left.equalTo(CGFloat(i) * (imageWidth + imageMargin))
                }
                if imageViews.count <= 3 {
                    self.snp_makeConstraints { make in
                        make.bottom.equalTo(imageViews[0])
                    }
                }
            case 3..<6:
                imageViews[i].snp_makeConstraints { make in
                    make.top.equalTo(imageWidth + imageMargin)
                    make.left.equalTo(CGFloat(i - 3) * (imageWidth + imageMargin))
                }
                if imageViews.count <= 6 {
                    self.snp_makeConstraints { make in
                        make.bottom.equalTo(imageViews[3])
                    }
                }
            case 6..<9:
                imageViews[i].snp_makeConstraints { make in
                    make.top.equalTo(2 * (imageWidth + imageMargin))
                    make.left.equalTo(CGFloat(i - 6) * (imageWidth + imageMargin))
                }
                if imageViews.count <= 9 {
                    self.snp_makeConstraints { make in
                        make.bottom.equalTo(imageViews[6])
                    }
                }
            default:
                break
            }
        }

        super.updateConstraints()
    }
}
