//
//  ImageStreamView.swift
//  ImageStream
//
//  Created by Kreft, Michal on 11.07.15.
//  Copyright © 2015 yomajkel. All rights reserved.
//

import Cocoa
import ScreenSaver

class ImageStreamView: ScreenSaverView {
    
    var image: NSImage?
    var origin: NSPoint?
    var dest: NSPoint = NSMakePoint(-1, -2)
    var bgColor: CGColor = NSColor.blackColor().CGColor
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        loadImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadImage()
    }
    
    override func startAnimation() {
        super.startAnimation()
    }
    
    override func stopAnimation() {
        super.stopAnimation()
    }
    
    override func drawRect(rect: NSRect) {
        let context: CGContextRef = NSGraphicsContext.currentContext()!.CGContext
        CGContextSetFillColorWithColor(context, bgColor);
        CGContextSetAlpha(context, 1);
        CGContextFillRect(context, rect);
        
//        if let image = image {
//            if let origin = origin {
//                image.drawAtPoint(origin, fromRect: NSZeroRect, operation: .CompositeSourceOver, fraction: 1)
//            }
//        }
    }
    
    override func animateOneFrame() {

        if let image = image {
            if origin == nil {
                origin = SSRandomPointForSizeWithinRect(image.size, frame)
            }
            if let oldOrigin = origin {
                dest.x = getNewStepDirection(dest.x,
                    imageSize: image.size.width,
                    originPoint: oldOrigin.x,
                    maxPoint: frame.size.width
                )
                dest.y = getNewStepDirection(dest.y,
                    imageSize: image.size.height,
                    originPoint: oldOrigin.y,
                    maxPoint: frame.size.height
                )
                let newX = oldOrigin.x + dest.x
                let newY = oldOrigin.y + dest.y
                
                origin = NSMakePoint(newX, newY)
                
                drawOverOldImage(oldOrigin, imageSize: image.size)
                image.drawAtPoint(origin!, fromRect: NSZeroRect, operation: .CompositeSourceOver, fraction: 1)
            }

        }
    }
    
    override func hasConfigureSheet() -> Bool {
        return false
    }
    
    override func configureSheet() -> NSWindow? {
        return nil
    }
    
    func drawOverOldImage(origin: NSPoint, imageSize: NSSize) {
        let absDest:NSPoint = NSPoint(x:abs(dest.x), y:abs(dest.y));
        NSBezierPath.fillRect(NSMakeRect(
            origin.x-absDest.x,
            origin.y-absDest.y,
            imageSize.width+(absDest.x*2),
            imageSize.height+(absDest.y*2))
        )
    }
    
    func getNewStepDirection(currentStep:CGFloat, imageSize:CGFloat, originPoint:CGFloat, maxPoint:CGFloat) -> CGFloat {
        let newPoint = originPoint + currentStep
        if(newPoint <= 0 || newPoint >= (maxPoint-imageSize)) {
            return currentStep * -1
        }
        return currentStep
    }
    
    func loadImage() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let url = NSURL(string: "https://lh6.ggpht.com/ZHXX5h6hciPNTFc9l2gyCV9vMaJpa4hm6G6Y9QfwOjF5LttwoJjSdnJeiU0dDXfVrEI=w300")
            let data = NSData(contentsOfURL: url!)
            if let data = data {
                self.image = NSImage(data: data)
                self.needsDisplay = true
            }
        }
    }
    
}