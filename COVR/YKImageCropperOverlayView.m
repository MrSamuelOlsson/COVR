//
//  YKImageCropperOverlayView.m
//  Copyright (c) 2013 yuyak. All rights reserved.
//

#import "YKImageCropperOverlayView.h"

#define SIZE 20.0f

@implementation YKImageCropperOverlayView

@synthesize showFrameRect;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    showFrameRect = YES;
    [self setAlpha:0.7];
    
    return self;
}

- (CGRect)edgeRect {
    return CGRectMake(CGRectGetMinX(self.clearRect) - SIZE / 2,
                      CGRectGetMinY(self.clearRect) - SIZE / 2,
                      CGRectGetWidth(self.clearRect) + SIZE,
                      CGRectGetHeight(self.clearRect) + SIZE);
}

- (CGRect)topLeftCorner {
    return CGRectMake(CGRectGetMinX(self.clearRect) - SIZE / 2,
                      CGRectGetMinY(self.clearRect) - SIZE / 2,
                      SIZE, SIZE);
}

- (CGRect)topRightCorner {
    return CGRectMake(CGRectGetMaxX(self.clearRect) - SIZE / 2,
                      CGRectGetMinY(self.clearRect) - SIZE / 2,
                      SIZE, SIZE);
}

- (CGRect)bottomLeftCorner {
    return CGRectMake(CGRectGetMinX(self.clearRect) - SIZE / 2,
                      CGRectGetMaxY(self.clearRect) - SIZE / 2,
                      SIZE, SIZE);
}

- (CGRect)bottomRightCorner {
    return CGRectMake(CGRectGetMaxX(self.clearRect) - SIZE / 2,
                      CGRectGetMaxY(self.clearRect) - SIZE / 2,
                      SIZE, SIZE);
}

- (CGRect)topEdgeRect {
    return CGRectMake(CGRectGetMidX([self clearRect]) - SIZE / 2,
                      CGRectGetMinY([self clearRect]) - SIZE / 2,
                      SIZE, SIZE);
}

- (CGRect)rightEdgeRect {
    return CGRectMake(CGRectGetMaxX([self clearRect]) - SIZE / 2,
                      CGRectGetMidY([self clearRect]) - SIZE / 2,
                      SIZE, SIZE);
}

- (CGRect)bottomEdgeRect {
    return CGRectMake(CGRectGetMidX([self clearRect]) - SIZE / 2,
                      CGRectGetMaxY([self clearRect]) - SIZE / 2, SIZE, SIZE);
}

- (CGRect)leftEdgeRect {
    return CGRectMake(CGRectGetMinX([self clearRect]) - SIZE / 2,
                      CGRectGetMidY([self clearRect]) - SIZE / 2, SIZE, SIZE);
}

- (BOOL)isEdgeContainsPoint:(CGPoint)point {
    return CGRectContainsPoint([self topEdgeRect], point)
        || CGRectContainsPoint([self rightEdgeRect], point)
        || CGRectContainsPoint([self bottomEdgeRect], point)
        || CGRectContainsPoint([self leftEdgeRect], point);
}

- (BOOL)isCornerContainsPoint:(CGPoint)point {
    return CGRectContainsPoint([self topLeftCorner], point)
            || CGRectContainsPoint([self topRightCorner], point)
            || CGRectContainsPoint([self bottomLeftCorner], point)
            || CGRectContainsPoint([self bottomRightCorner], point);
}

CGImageRef flip (CGImageRef im) {
    CGSize sz = CGSizeMake(CGImageGetWidth(im), CGImageGetHeight(im));
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    CGContextDrawImage(UIGraphicsGetCurrentContext(),
                       CGRectMake(0, 0, sz.width, sz.height), im);
    CGImageRef result = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
    UIGraphicsEndImageContext();
    return result;
}

- (void) setFlip
{
    if(self.image != nil)
    {
        CGImageRef im = [self.image CGImage];
        CGSize sz = CGSizeMake(CGImageGetWidth(im), CGImageGetHeight(im));
        UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
        CGContextDrawImage(UIGraphicsGetCurrentContext(),
                           CGRectMake(0, 0, sz.width, sz.height), im);
        self.imageFliped = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(c, YES);
    
//    // Fill black
//    CGContextSetFillColorWithColor(c, [UIColor colorWithWhite:0 alpha:0.7].CGColor);
//    CGContextAddRect(c, CGRectMake(0, 0, 320, 480));
//    CGContextFillPath(c);

    // Clear inside
    CGContextClearRect(c, self.frame);
    CGContextFillPath(c);

    if(self.imageFliped != nil)
    {
        CGImageRef imgRef = [self.imageFliped CGImage];
        CGContextDrawImage(c, self.clearRect, imgRef);
    }

    if(showFrameRect)
    {
        // Draw corners
        //    CGContextSetFillColorWithColor(c, [UIColor colorWithRed: 44/255 green: 183/255 blue: 255/255 alpha:1.0].CGColor);
        CGContextSetRGBFillColor(c, 44.0f/255.0f, 183.0f/255.0f, 255.0f/255.0f, 1.0f);
        
        CGContextSaveGState(c);
        CGContextSetShouldAntialias(c, NO);
        
        CGFloat margin = SIZE / 2;
        
        // Clear outside
        CGRect clip = CGRectOffset(self.clearRect, -margin, -margin);
            clip.size.width += (margin * 2.0f), clip.size.height += (margin * 2.0f);
        CGContextClipToRect(c, clip);
        
        CGContextAddEllipseInRect(c, self.topLeftCorner);
        CGContextAddEllipseInRect(c, self.topRightCorner);
        CGContextAddEllipseInRect(c, self.bottomLeftCorner);
        CGContextAddEllipseInRect(c, self.bottomRightCorner);
        CGContextAddEllipseInRect(c, self.topEdgeRect);
        CGContextAddEllipseInRect(c, self.leftEdgeRect);
        CGContextAddEllipseInRect(c, self.rightEdgeRect);
        CGContextAddEllipseInRect(c, self.bottomEdgeRect);
        CGContextFillPath(c);
        
        // Clear inside
        //    margin = SIZE / 8;
        //    clip = CGRectOffset(self.clearRect, margin, margin);
        //    clip.size.width -= margin * 2, clip.size.height -= margin * 2;
        //    CGContextClearRect(c, clip);
        //    CGContextRestoreGState(c);
        
        // Grid
        CGContextSetStrokeColorWithColor(c, [UIColor colorWithRed: 44.0f/255.0f green: 183.0f/255.0f blue: 255.0f/255.0f alpha:1.0].CGColor);
        CGContextSetLineWidth(c, 3);
        
        CGContextAddRect(c, self.clearRect);
       
        CGContextStrokePath(c);
        
        CGContextRestoreGState(c);
        
    }
}

@end
