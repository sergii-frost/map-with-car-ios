//
//  CarAnnotationView.swift
//  MapWithCar
//
//  Created by Sergii Frost on 2017-10-09.
//  Copyright © 2017 Frosted AB. All rights reserved.
//

import Foundation
import MapKit

public class CarAnnotationView: MKAnnotationView {
    
    var direction: CLLocationDegrees? {
        didSet {
            self.image = #imageLiteral(resourceName: "car_icon").image(withDegrees: 360.0 - (direction ?? 0))
        }
    }
    
    public override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.image = #imageLiteral(resourceName: "car_icon")
        self.canShowCallout = false
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension UIImage {
    func image(withDegrees degrees: CLLocationDegrees?) -> UIImage? {
        guard let degrees = degrees else {
            return nil
        }
        let radians = degrees * .pi / 180
        
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        let LARGEST_SIZE = CGFloat(max(self.size.width, self.size.height))
        guard let context = CGContext.init(data: nil, width:Int(LARGEST_SIZE), height:Int(LARGEST_SIZE), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue) else {
            return self
        }
        
        var drawRect = CGRect.zero
        drawRect.size = self.size
        let drawOrigin = CGPoint(x: (LARGEST_SIZE - self.size.width) * 0.5,y: (LARGEST_SIZE - self.size.height) * 0.5)
        drawRect.origin = drawOrigin
        var tf = CGAffineTransform.identity
        tf = tf.translatedBy(x: LARGEST_SIZE * 0.5, y: LARGEST_SIZE * 0.5)
        tf = tf.rotated(by: CGFloat(radians))
        tf = tf.translatedBy(x: LARGEST_SIZE * -0.5, y: LARGEST_SIZE * -0.5)
        context.concatenate(tf)
        context.draw(cgImage, in: drawRect)
        let contextImage = context.makeImage()!
        
        drawRect = drawRect.applying(tf)
        
        guard let rotatedImage = contextImage.cropping(to: drawRect) else {
            return nil
        }
        let resultImage = UIImage(cgImage: rotatedImage)
        return resultImage
    }
}
