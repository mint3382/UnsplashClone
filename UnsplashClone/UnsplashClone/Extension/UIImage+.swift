//
//  UIImage+.swift
//  UnsplashClone
//
//  Created by minsong kim on 1/31/24.
//

import UIKit

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage? {
        let newRect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height).integral
        
        UIGraphicsBeginImageContextWithOptions(newRect.size, true, 1)
        draw(in: newRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
