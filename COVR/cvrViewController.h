//
//  cvrViewController.h
//  COVR
//
//  Created by albert on 8/13/13.
//  Copyright (c) 2013 Choir Boys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cvrViewController : UIViewController <UIScrollViewDelegate>

@property (retain, nonatomic) IBOutlet UIButton *rightArrowBtn;

@property (retain, nonatomic) IBOutlet UIButton *leftArrowBtn;
@property (retain, nonatomic) IBOutlet UIButton *m_categorySelector;
@property (retain, nonatomic) IBOutlet UILabel *labelCategoryText;

@property (retain, nonatomic) IBOutlet UIScrollView *categoryScrollView;

@property (nonatomic, assign) int m_categoryIndex;

@property (retain, nonatomic) IBOutlet UIImageView *m_categoryBG;

@property (retain, nonatomic) NSTimer* timer;
@property (retain, nonatomic) IBOutlet UIView *splashView;
@property (retain, nonatomic) IBOutlet UIImageView *imgSplashView;

- (IBAction)onRightArrowTouchUp:(id)sender;

- (IBAction)onLeftArrowTouchUp:(id)sender;

-(void)refreshCategory;

@end
