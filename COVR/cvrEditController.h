//
//  cvrEditController.h
//  COVR
//
//  Created by albert on 8/15/13.
//  Copyright (c) 2013 Choir Boys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImagePickerController.h"
#import "YKImageCropperView.h"
#import "CaptureSessionManager.h"

@interface cvrEditController : UIViewController <CustomImagePickerControllerDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *categoryScrollView;
@property (retain, nonatomic) IBOutlet UIButton *btnPhotoSelector;

@property (retain, nonatomic) IBOutlet UIButton *onBackScene;
@property (retain, nonatomic) YKImageCropperView *editBoarder;
@property (retain, nonatomic) IBOutlet UIView *editboarderContainer;
@property (retain, nonatomic) IBOutlet UIButton *confirmBtn;
@property (retain, nonatomic) IBOutlet UIView *alertView;
@property (retain, nonatomic) IBOutlet UIView *cameraContainer;
@property (retain, nonatomic) IBOutlet UILabel *label1;
@property (retain, nonatomic) IBOutlet UILabel *label2;
@property (retain, nonatomic) IBOutlet UILabel *label3;
@property (retain, nonatomic) IBOutlet UILabel *label4;
@property (retain, nonatomic) IBOutlet UIButton *alertButton1;
@property (retain, nonatomic) IBOutlet UIButton *alertButton2;

//@property (retain, nonatomic) NSTimer* timer;

@property (nonatomic,retain) CaptureSessionManager *captureManager;
- (IBAction)switchCamera:(id)sender;
@end
