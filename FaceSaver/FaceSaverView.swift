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
        CGContextSetFillColorWithColor(context, NSColor.blackColor().CGColor);
        CGContextSetAlpha(context, 1);
        CGContextFillRect(context, rect);
        
        
        if let image = image {
            let point = SSRandomPointForSizeWithinRect(image.size, frame);
            image.drawAtPoint(point, fromRect: NSZeroRect, operation: .CompositeSourceOver, fraction: 1)
        }
    }
    
    override func animateOneFrame() {
        if let image = image {
            let origin = SSRandomPointForSizeWithinRect(image.size, frame)
            image.drawAtPoint(origin, fromRect: NSZeroRect, operation: .CompositeSourceOver, fraction: 1)
        }
    }
    
    override func hasConfigureSheet() -> Bool {
        return false
    }
    
    override func configureSheet() -> NSWindow? {
        return nil
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