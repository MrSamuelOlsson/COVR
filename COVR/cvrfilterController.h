//
//  cvrfilterController.h
//  COVR
//
//  Created by albert on 8/20/13.
//  Copyright (c) 2013 Choir Boys. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    FilterNone=-1,
	FilterHue = 0,
	FilterBlackWhite,
	FilterNoise,

} FilterOptions;

@interface cvrfilterController : UIViewController
{
    FilterOptions activeFilter;
}
@property (retain, nonatomic) IBOutlet UIImageView *effectedImageView;
@property (retain, nonatomic) IBOutlet UIButton *hueFilterBtn;
@property (retain, nonatomic) IBOutlet UIButton *bwFilterBtn;
@property (retain, nonatomic) IBOutlet UIButton *noiseFilterBtn;
@property (retain, nonatomic) IBOutlet UISlider *filterSlider;

@property (retain, nonatomic) UIImage* editedImage;
@property (retain, nonatomic) UIImage* effectedImage;

@property (retain, nonatomic) IBOutlet UIView *alertView;
@property (retain, nonatomic) IBOutlet UILabel *label1;
@property (retain, nonatomic) IBOutlet UILabel *label2;
@property (retain, nonatomic) IBOutlet UILabel *label3;
@property (retain, nonatomic) IBOutlet UILabel *label4;
@property (retain, nonatomic) IBOutlet UIButton *alertButton1;
@property (retain, nonatomic) IBOutlet UIButton *alertButton2;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *sliderLabel;
@property (retain, nonatomic) IBOutlet UILabel *nofilterLabel;

@property (nonatomic, assign) float hue_value;
@property (nonatomic, assign) float bw_value;
@property (nonatomic, assign) float noise_value;

@end
