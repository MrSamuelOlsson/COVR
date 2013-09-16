//
//  cvrShareController.h
//  COVR
//
//  Created by albert on 8/22/13.
//  Copyright (c) 2013 Choir Boys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface cvrShareController : UIViewController <UIDocumentInteractionControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UIScrollViewDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *resultImageView;
@property (nonatomic, strong) UIDocumentInteractionController *dic;

@property (atomic, strong) ALAssetsLibrary *library;
@property (retain, nonatomic) IBOutlet UIScrollView *resultScrollView;

@property (nonatomic, retain) UIImage *imageForReset;
@property (retain, nonatomic) IBOutlet UIImageView *finalCoverBG;
@property (retain, nonatomic) IBOutlet UIImageView *groovyEffect;
@property (retain, nonatomic) IBOutlet UIButton *shareButton;

@property (retain, nonatomic) NSMutableArray* assets;
@property (retain, nonatomic) ALAssetsGroup* assetGroup;

@property (retain, nonatomic) NSTimer* timer;

@end
