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
    }
    
    override func animateOneFrame() {

        if let image = image {
            if origin == nil {
                origin = SSRandomPointForSizeWithinRect(image.size, frame)
            }
            if let oldOrigin = origin {
                let stepX = getNewStepDirection(dest.x,
                    imageSize: image.size.width,
                    originPoint: oldOrigin.x,
                    maxPoint: frame.size.width
                )
                let stepY = getNewStepDirection(dest.y,
                    imageSize: image.size.height,
                    originPoint: oldOrigin.y,
                    maxPoint: frame.size.height
                )
                
                if (stepX != dest.x || stepY != dest.y) {
                    randomTint(image)
                }
                
                dest.x = stepX;
                dest.y = stepY;
                
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
    
    func randomTint(image: NSImage) {
        image.lockFocus()
        randomColor().set()
        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        NSRectFillUsingOperation(imageRect, NSCompositingOperation.CompositeSourceAtop)
        image.unlockFocus()
    }
    
    func randomColor() -> NSColor {
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        return NSColor(red: red, green: green, blue: blue, alpha: 100)
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
            let url = NSURL(string: "https://upload.wikimedia.org/wikipedia/en/thumb/1/18/Dvd-video-logo.svg/420px-Dvd-video-logo.svg.png")
            let data = NSData(contentsOfURL: url!)
            if let data = data {
                self.image = NSImage(data: data)
                self.randomTint(self.image!);
                self.needsDisplay = true
            }
        }
    }
    
}