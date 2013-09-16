//
//  cvrAppDelegate.h
//  COVR
//
//  Created by Xuemin Wen on 8/13/13.
//  Copyright (c) 2013 Choir Boys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cvrAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (retain, nonatomic) UIImage *editedImage;
@property (retain, nonatomic) UIImage *effectedImage;

@property (nonatomic, assign) int categoryIndex;
@property (nonatomic, assign) int album_index;

@property (nonatomic, assign) bool firstLaunched;

@end
