//
//  SymbolView.h
//  ImageSlider
//
//  Created by Ji wonnam on 5/19/12.
//  Copyright (c) 2013 Choir Boys. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SYMBOL_SIZE     90
#define SYMBOL_MARGIN   0

@interface SymbolView : UIView
{
    id atarget;
    SEL aselector;
}

@property (nonatomic, retain) NSString * strImageName;
@property (nonatomic, retain) UIButton * btnBack;
@property (nonatomic, retain) UIImageView * viewImage;
@property (nonatomic, retain) UIImageView * viewShadow;

- (id)initWithImagePath:(NSString *)strPath frame:(CGRect)frame;
- (void)addTarget:(id)target action:(SEL)action;
-(BOOL) isSelected;
-(void) setSelect:(BOOL)bSelect;
-(id)setImagePath:(NSString *) strPath;

@end
