//
//  cvrfilterController.m
//  COVR
//
//  Created by albert on 8/20/13.
//  Copyright (c) 2013 Choir Boys. All rights reserved.
//

#import "cvrfilterController.h"
#import "cvrShareController.h"
#import "cvrAppDelegate.h"
#import "ImageFilter.h"
#import <CoreImage/CoreImage.h>

@interface cvrfilterController ()

@end

@implementation cvrfilterController

@synthesize editedImage, effectedImage;
@synthesize hue_value, bw_value, noise_value;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [_alertView setHidden:YES];
    
    hue_value = 0;
    bw_value = 0;
    noise_value = 0;
    
    cvrAppDelegate *delegate = (cvrAppDelegate*)[[UIApplication sharedApplication] delegate];
    editedImage = delegate.editedImage;
    delegate.effectedImage = editedImage;
    _effectedImageView.image = editedImage;    
    
    
    UIImage *starNormal = [UIImage imageNamed:@"star.png"];
    UIImage *starSelected = [UIImage imageNamed:@"star.png"];
    [_filterSlider setThumbImage:starNormal forState:UIControlStateNormal];
    [_filterSlider setThumbImage:starSelected forState:UIControlStateHighlighted];
    [_filterSlider addTarget:self action:@selector(sliderMoved:) forControlEvents:UIControlEventTouchUpInside];
    [_filterSlider addTarget:self action:@selector(sliderMoving:) forControlEvents:UIControlEventTouchDragInside];
    
    UIImage *starMax = [[UIImage imageNamed:@"slider_hue.png"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    UIImage *starMin = [[UIImage imageNamed:@"slider_hue.png"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [_filterSlider setMaximumTrackImage:starMax forState:UIControlStateNormal];
    [_filterSlider setMinimumTrackImage:starMin forState:UIControlStateNormal];
    
    activeFilter = FilterNone;
    _filterSlider.hidden = YES;
    _sliderLabel.hidden = YES;
    _nofilterLabel.hidden = NO;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if(screenHeight == 480)
        [self resizeForiPhone4];
    
}

-  (void) resizeForiPhone4
{
    _effectedImageView.frame = CGRectMake(35.0f, 55.0f, 250.0f, 250.0f);
    _alertView.frame = CGRectMake(35.0f, 55.0f, 250.0f, 250.0f);
    _alertView.frame = CGRectMake(35.0f, 55.0f, 250.0f, 250.0f);
    _label1.frame = CGRectMake(0.0f, 21.0f, 250.0f, 45.0f);
    _label2.frame = CGRectMake(0.0f, 57.0f, 250.0f, 45.0f);
    _label3.frame = CGRectMake(0.0f, 89.0f, 250.0f, 45.0f);
    _label4.frame = CGRectMake(0.0f, 143.0f, 250.0f, 44.0f);
    _alertButton1.frame = CGRectMake(31.0f, 183.0f, 92.0f, 44.0f);
    _alertButton2.frame = CGRectMake(134.0f, 183.0f, 102.0f, 44.0f);
    
    _scrollView.frame = CGRectMake(5, 313, 310, 90);
}

- (IBAction) sliderMoved:(id)sender
{
    if(![_alertView isHidden])
    {
        return;
    }
    
    [self ApplyEffect];
}

- (IBAction) sliderMoving:(id)sender
{
    if(![_alertView isHidden])
    {
        return;
    }
    
    int value = _filterSlider.value;    
    _sliderLabel.text = [NSString stringWithFormat:@"%d", value];
}

- (IBAction)onHueButtonClicked:(id)sender {
    
    if(![_alertView isHidden])
    {
        return;
    }
    
    UIImage *starMax = [[UIImage imageNamed:@"slider_hue.png"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    UIImage *starMin = [[UIImage imageNamed:@"slider_hue.png"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [_filterSlider setMaximumTrackImage:starMax forState:UIControlStateNormal];
    [_filterSlider setMinimumTrackImage:starMin forState:UIControlStateNormal];
    
    _sliderLabel.hidden = YES;
    
//    cvrAppDelegate* delegate = (cvrAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(activeFilter == FilterNone)
    {
        activeFilter = FilterHue;
        _filterSlider.hidden = NO;
        _nofilterLabel.hidden = YES;        
       
        activeFilter = FilterHue;
        _filterSlider.value = hue_value;   
       
        UIImage *imageHue = [UIImage imageNamed:@"hue_on.png"];
        [_hueFilterBtn setImage:imageHue forState:UIControlStateNormal];
    }else if(activeFilter == FilterHue)
    {
        activeFilter = FilterNone;
        _filterSlider.hidden = YES;
        _nofilterLabel.hidden = NO;
        
        hue_value = 0;
        
//        _effectedImageView.image = self.tempEffectedImage;
        
//        delegate.effectedImage = self.tempEffectedImage;
        
        UIImage *imageHue = [UIImage imageNamed:@"hue_off.png"];
        [_hueFilterBtn setImage:imageHue forState:UIControlStateNormal];
    }else
    {        
        activeFilter = FilterHue;
        _filterSlider.value = hue_value;
        
        UIImage *imageHue = [UIImage imageNamed:@"hue_on.png"];
        [_hueFilterBtn setImage:imageHue forState:UIControlStateNormal];
    }
    
    _sliderLabel.text = [NSString stringWithFormat:@"%d", (int)hue_value];
    
    
    UIImage *imageBW = [UIImage imageNamed:@"bw_off.png"];
    UIImage *imageNoise = [UIImage imageNamed:@"noise_off.png"];    
    [_bwFilterBtn setImage:imageBW forState:UIControlStateNormal];
    [_noiseFilterBtn setImage:imageNoise forState:UIControlStateNormal];
    
    [self ApplyEffect];
}

- (IBAction)onBWButtonClicked:(id)sender {
    
    if(![_alertView isHidden])
    {
        return;
    }
    
    _sliderLabel.hidden = NO;
    
//    cvrAppDelegate* delegate = (cvrAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(activeFilter == FilterNone)
    {
        activeFilter = FilterBlackWhite;
        _filterSlider.hidden = NO;
        _nofilterLabel.hidden = YES;
 
        _filterSlider.value = bw_value;        
       
        UIImage *imageBW = [UIImage imageNamed:@"bw_on.png"];
        [_bwFilterBtn setImage:imageBW forState:UIControlStateNormal];
    }else if(activeFilter == FilterBlackWhite)
    {
        activeFilter = FilterNone;
        _filterSlider.hidden = YES;
        _nofilterLabel.hidden = NO;
        _sliderLabel.hidden = YES;
        
//        _effectedImageView.image = self.tempEffectedImage;
        
        bw_value = 0;
        
//        delegate.effectedImage = self.tempEffectedImage;
        
        UIImage *imageBW = [UIImage imageNamed:@"bw_off.png"];
        [_bwFilterBtn setImage:imageBW forState:UIControlStateNormal];
    }else
    {
        activeFilter = FilterBlackWhite;
        _filterSlider.value = bw_value;        
       
        UIImage *imageBW = [UIImage imageNamed:@"bw_on.png"];
        [_bwFilterBtn setImage:imageBW forState:UIControlStateNormal];
    }
    
    UIImage *starMax = [UIImage imageNamed:@"slider_black.png"];
    UIImage *starMin = [UIImage imageNamed:@"slider_black.png"];
    [_filterSlider setMaximumTrackImage:starMax forState:UIControlStateNormal];
    [_filterSlider setMinimumTrackImage:starMin forState:UIControlStateNormal];
    
    
    _sliderLabel.text = [NSString stringWithFormat:@"%d", (int)bw_value];
    
    UIImage *imageHue = [UIImage imageNamed:@"hue_off.png"];
    UIImage *imageNoise = [UIImage imageNamed:@"noise_off.png"];
    [_hueFilterBtn setImage:imageHue forState:UIControlStateNormal];    
    [_noiseFilterBtn setImage:imageNoise forState:UIControlStateNormal];
    
    [self ApplyEffect];
}

- (IBAction)onNoiseButtonClicked:(id)sender {
    
    if(![_alertView isHidden])
    {
        return;
    }
    
    _sliderLabel.hidden = NO;
    
//    cvrAppDelegate* delegate = (cvrAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UIImage *starMax = [UIImage imageNamed:@"slider_black.png"];
    UIImage *starMin = [UIImage imageNamed:@"slider_black.png"];
    [_filterSlider setMaximumTrackImage:starMax forState:UIControlStateNormal];
    [_filterSlider setMinimumTrackImage:starMin forState:UIControlStateNormal];
    
    if(activeFilter == FilterNone)
    {
        activeFilter = FilterNoise;
        _filterSlider.hidden = NO;
        _nofilterLabel.hidden = YES;      
        
        _filterSlider.value = noise_value;        
        
        UIImage *imageNoise = [UIImage imageNamed:@"noise_on.png"];
        [_noiseFilterBtn setImage:imageNoise forState:UIControlStateNormal];
    }else if(activeFilter == FilterNoise)
    {
        activeFilter = FilterNone;
        _filterSlider.hidden = YES;
        _nofilterLabel.hidden = NO;
        _sliderLabel.hidden = YES;
        
//        _effectedImageView.image = self.tempEffectedImage;
        
        noise_value = 0;
        
//        delegate.effectedImage = self.tempEffectedImage;
        
        UIImage *imageNoise = [UIImage imageNamed:@"noise_off.png"];
        [_noiseFilterBtn setImage:imageNoise forState:UIControlStateNormal];
    }else
    {        
        activeFilter = FilterNoise;
        _filterSlider.value = noise_value;
        
        UIImage *imageNoise = [UIImage imageNamed:@"noise_on.png"];
        [_noiseFilterBtn setImage:imageNoise forState:UIControlStateNormal];
    }
    
    _sliderLabel.text = [NSString stringWithFormat:@"%d", (int)noise_value];
    
    UIImage *imageHue = [UIImage imageNamed:@"hue_off.png"];
    UIImage *imageBW = [UIImage imageNamed:@"bw_off.png"];
    
    [_hueFilterBtn setImage:imageHue forState:UIControlStateNormal];
    [_bwFilterBtn setImage:imageBW forState:UIControlStateNormal];    
    
    [self ApplyEffect];
}

- (IBAction)onClickedUndo:(id)sender {
    
    [_alertView setHidden:NO];

}

- (IBAction)onAlertViewOk:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAlertViewCancel:(id)sender {
    [_alertView setHidden:YES];
}


- (IBAction)onConfirmEffect:(id)sender {
    
    if(![_alertView isHidden])
    {
        return;
    }
    
    //[self setCoverImage];
    
    cvrShareController* cvrViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cvrShareController"];
    
    [self.navigationController pushViewController:cvrViewController animated:YES];
}

- (void) setCoverImage {
    cvrAppDelegate* delegate = (cvrAppDelegate*)[[UIApplication sharedApplication] delegate];
    UIImage* imageCovr = [UIImage imageNamed:@"cover.png"];
    
    UIGraphicsBeginImageContext(delegate.effectedImage.size);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextClipToRect(c, CGRectMake(0, 0, delegate.effectedImage.size.width, delegate.effectedImage.size.height));
    [delegate.effectedImage drawInRect:CGRectMake(0, 0, delegate.effectedImage.size.width, delegate.effectedImage.size.height)];
    [imageCovr drawInRect:CGRectMake(0, 0, imageCovr.size.width, imageCovr.size.height) blendMode:kCGBlendModeOverlay alpha:0.7];
    delegate.effectedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void) ApplyEffect
{
    double value = _filterSlider.value;
    UIImage* image = (UIImage*)[self.editedImage copyImage:self.editedImage];
    
    cvrAppDelegate* delegate = (cvrAppDelegate*)[[UIApplication sharedApplication] delegate];
    
	switch (activeFilter) {
		case FilterHue:
        {
            hue_value = value;
			break;
        }
		case FilterBlackWhite:
        {
            bw_value = value;
			break;
        }
		case FilterNoise:
        {
            noise_value = value;
			break;
        }
		default:
			break;
	}
    
        UIImage* tempImage1 = nil;
        UIImage* tempImage2 = nil;
        UIImage* tempImage3 = nil;
    
        float radianVal = hue_value*3.6*M_PI/(double)180.0;
        tempImage1 = [self imageWithFilter:image rotatedByHue:radianVal];
    
        tempImage2 = [tempImage1 bwFilter:(100.0 - bw_value) / 100.0];
        tempImage3 = [tempImage2 noise:(noise_value / 1000.0)];
    
//        self.tempEffectedImage = tempImage3;
    
        [_effectedImageView setImage:tempImage3];  
        delegate.effectedImage = tempImage3;
}


- (UIImage*) imageWithFilter:(UIImage*) source rotatedByHue:(CGFloat) deltaHueRadians;
{
    // Create a Core Image version of the image.
    CIImage *sourceCore = [CIImage imageWithCGImage:[source CGImage]];
    
    // Apply a CIHueAdjust filter
    CIFilter *hueAdjust = [CIFilter filterWithName:@"CIHueAdjust"];
    [hueAdjust setDefaults];
    [hueAdjust setValue: sourceCore forKey: @"inputImage"];
    [hueAdjust setValue: [NSNumber numberWithFloat: deltaHueRadians] forKey: @"inputAngle"];
    CIImage *resultCore = [hueAdjust valueForKey: @"outputImage"];
    
    // Convert the filter output back into a UIImage.
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef resultRef = [context createCGImage:resultCore fromRect:[resultCore extent]];
    UIImage *result = [UIImage imageWithCGImage:resultRef];
    CGImageRelease(resultRef);
    
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    NSLog(@"cvrFilterController: View Did dealloc");
    
    [_effectedImageView release];
    [_hueFilterBtn release];
    [_bwFilterBtn release];
    [_noiseFilterBtn release];
    [_filterSlider release];
    [_alertView release];
    [_label1 release];
    [_label2 release];
    [_label3 release];
    [_label4 release];
    [_alertButton1 release];
    [_alertButton2 release];
    [_scrollView release];
    [_sliderLabel release];
    [_nofilterLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    
    NSLog(@"cvrFilterController: View Did Unload");
    
    [self setEffectedImageView:nil];
    [self setHueFilterBtn:nil];
    [self setBwFilterBtn:nil];
    [self setNoiseFilterBtn:nil];
    [self setFilterSlider:nil];
    [self setAlertView:nil];
    [super viewDidUnload];
}
@end
