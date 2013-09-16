//
//  YKImageCropperView.h
//  Copyright (c) 2013 yuyak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKImageCropperView : UIView

@property (nonatomic, retain) UIImage *image;

- (UIImage *)editedImage;
- (id)initWithImage:(UIImage *)image;
- (void)reset;
- (void)square;
- (void)setConstrain:(CGSize)size;
-(void) setOrigImage:(UIImage*) img;
- (void) setCoverImage:(UIImage*) imgCover;

@end