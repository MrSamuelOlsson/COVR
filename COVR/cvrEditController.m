//
//  cvrEditController.m
//  COVR
//
//  Created by albert on 8/15/13.
//  Copyright (c) 2013 Choir Boys. All rights reserved.
//

#import "cvrEditController.h"
#import "cvrfilterController.h"
#import "cvrAppDelegate.h"
#import "SymbolView.h"
#import "UIImage+Cut.h"

@interface cvrEditController ()

@end

@implementation cvrEditController

//@synthesize timer;

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
    
    // Let the notification center call the pictureIsCaptured once the pic is captured
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pictureIsCaptured) name:kImageCapturedSuccessfully object:nil];
    
    [_alertView setHidden:YES];    
    
    UIImage *image = [UIImage imageNamed:@"empty.png"];
    _editBoarder = [[YKImageCropperView alloc] initWithImage:image];
    
    [_editboarderContainer addSubview:_editBoarder];    
    
    cvrAppDelegate* delegate = (cvrAppDelegate*)[[UIApplication sharedApplication] delegate];
    int categoryIndex = delegate.categoryIndex;
    
    //initialize the cover image
    NSString * strPath;
    strPath = [NSString stringWithFormat:@"category%d_%d.jpg",categoryIndex+1, delegate.album_index];
    
    UIImage *imgCover = [UIImage imageNamed:strPath];
    
    [_editBoarder setCoverImage:imgCover];
    
    [self calcScrollView];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if(screenHeight == 480)
        [self resizeForiPhone4];
}

- (void) calcScrollView
{
//    if(timer != nil)
//    {
//        [timer invalidate];
//        timer = nil;
//    }
//    
//    NSArray *viewsToRemove = [_categoryScrollView subviews];
//    for (UIView *v in viewsToRemove) [v removeFromSuperview];
    
    cvrAppDelegate* delegate = (cvrAppDelegate*)[[UIApplication sharedApplication] delegate];
    int categoryIndex = delegate.categoryIndex;
    
    int categoryCount = 14;
    switch(categoryIndex)
    {
        case 0:
            categoryCount = 14;
            break;
        case 1:
            categoryCount = 33;
            break;
        case 2:
            categoryCount = 15;
            break;
        case 3:
            categoryCount = 12;
            break;
        case 4:
            categoryCount = 6;
            break;
        case 5:
            categoryCount = 10;
            break;
    }
    float posx = 12.5f;
    for (int i = 0; i < categoryCount; i++)
    {
        NSString * strPath;
        strPath = [NSString stringWithFormat:@"category%d_%d.jpg",categoryIndex+1, i+1];
        
        SymbolView * viewSymbol = [[[SymbolView alloc] initWithImagePath:strPath frame:CGRectMake(posx, 0, 90, 90)] autorelease];
        [viewSymbol addTarget:self action:@selector(actionSymbol:)];
        [_categoryScrollView addSubview:viewSymbol];
        viewSymbol.tag = i + 1;
        posx += 102.5f;
        
    }
    
    [_categoryScrollView setContentSize:CGSizeMake(12.5f + 102.5f * categoryCount, 90.0f)];
    
//    if(timer == nil)
//        timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(loadScrollValue) userInfo:nil repeats:YES];
}

//-(void)loadScrollValue{
//    NSArray *views = [_categoryScrollView subviews];
//    
//    cvrAppDelegate* delegate = (cvrAppDelegate*)[[UIApplication sharedApplication] delegate];
//    int categoryIndex = delegate.categoryIndex;
//    
//    for (UIView *v in views)
//    {
//        SymbolView* sv = (SymbolView*) v;
//        int tag = sv.tag;
//        if(sv.viewImage.image == nil)
//        {
//            NSString * strPath = [NSString stringWithFormat:@"category%d_%d.jpg",categoryIndex+1, tag];
//            [sv setImagePath:strPath];
//            break;
//        }
//        
//    }
//}

-  (void) resizeForiPhone4
{
    _cameraContainer.frame = CGRectMake(35.0f, 55.0f, 250.0f, 250.0f);
    _editboarderContainer.frame = CGRectMake(35.0f, 55.0f, 250.0f, 250.0f);
    _alertView.frame = CGRectMake(35.0f, 55.0f, 250.0f, 250.0f);
    _label1.frame = CGRectMake(0.0f, 21.0f, 250.0f, 45.0f);
    _label2.frame = CGRectMake(0.0f, 57.0f, 250.0f, 45.0f);
    _label3.frame = CGRectMake(0.0f, 89.0f, 250.0f, 45.0f);
    _label4.frame = CGRectMake(0.0f, 143.0f, 250.0f, 44.0f);
    _alertButton1.frame = CGRectMake(31.0f, 183.0f, 92.0f, 44.0f);
    _alertButton2.frame = CGRectMake(134.0f, 183.0f, 102.0f, 44.0f);
    
    _categoryScrollView.frame = CGRectMake(0, 313, 320, 90);
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"viewdidappear");    
    
    // Initialize the capturemanager
	[self setCaptureManager:[[[CaptureSessionManager alloc] init] autorelease] ];
	[[self captureManager] addVideoInput];
    
    // Add video preview layer
	[[self captureManager] addVideoPreviewLayer];
	CGRect layerRect = [[_cameraContainer  layer] bounds];
    
	[[[self captureManager] previewLayer] setBounds:layerRect];
	[[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                                  CGRectGetMidY(layerRect))];
    
    [[_cameraContainer layer] addSublayer:[[self captureManager] previewLayer]];
    
    // Enable still image for capturing
    [[self captureManager] addStillImageOutput];
    
    [_editBoarder setOrigImage:[UIImage imageNamed:@"empty.png"]];
    [[self.captureManager captureSession] startRunning];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) actionSymbol:(id)sender
{
    if (![_alertView isHidden]) {
        return;
    }
    
    cvrAppDelegate* delegate = (cvrAppDelegate*)[[UIApplication sharedApplication] delegate];
    int categoryIndex = delegate.categoryIndex;
    
    if ([sender isKindOfClass:SymbolView.class])
    {
        NSLog(@"tag index = %d", ((UIView *) sender).tag);
        
        NSString * strPath;
        strPath = [NSString stringWithFormat:@"category%d_%d.jpg", categoryIndex+1, ((UIView *) sender).tag];
        
        UIImage *image = [UIImage imageNamed:strPath];
        
        [_editBoarder setCoverImage:image];

    }
}

- (IBAction)onClickedUndo:(id)sender {
    
    [_alertView setHidden:NO];
}

- (IBAction)onAlertViewCancel:(id)sender {
    [_alertView setHidden:YES];
}

- (IBAction)setAlertViewOk:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onClickedCameraOpen:(id)sender {
    
    if (![_alertView isHidden]) {
        return;
    }
    
    if([self.captureManager captureSession].isRunning)
    {
        [[self captureManager] captureStillImage];        
    }else
    {
        [_editBoarder setOrigImage:[UIImage imageNamed:@"empty.png"]];
        [[self.captureManager captureSession] startRunning];
    }
    
}

- (IBAction)onClickedPhotoOpen:(id)sender {
    
    if (![_alertView isHidden]) {
        return;
    }
    
    CustomImagePickerController *picker = [[CustomImagePickerController alloc] init];
    
    [picker setIsSingle:YES];
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [picker setCustomDelegate:self];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void) pictureIsCaptured
{
    UIImage* imageCamera = [[self captureManager] stillImage];
    
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenHeight = screenRect.size.height;

    imageCamera = [imageCamera clipImageWithScaleWithsize:CGSizeMake(640, 640)];
    
    [[self.captureManager captureSession] stopRunning];
    
//    UIGraphicsBeginImageContext(CGSizeMake(280, 280));
//    [[[self captureManager] previewLayer] renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *mergedImage = [UIGraphicsGetImageFromCurrentImageContext() retain];
//    UIGraphicsEndImageContext();
    
    [_editBoarder setOrigImage:imageCamera];
    
    //[imageCamera release];
//    imageCamera = nil;
    
    [[self.captureManager captureSession] stopRunning];
    
}

-(IBAction)onConfirmEdit:(id)sender {
    
    if (![_alertView isHidden]) {
        return;
    }
    
    cvrAppDelegate* delegate = (cvrAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    delegate.editedImage = [_editBoarder editedImage];
    
    NSLog(@"tag index = %d", ((UIView *) sender).tag);
    cvrfilterController* cvrViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cvrfilterController"];
        
    [self.navigationController pushViewController:cvrViewController animated:YES];
}

- (void)cameraPhoto:(UIImage *)image //Complete gettting image from camera or album
{
    NSLog(@"Image captured");
    [_editBoarder setOrigImage:image];
    
    if([[self.captureManager captureSession] isRunning])
    {
        [[self.captureManager captureSession] stopRunning];
    }
    
}

- (IBAction)switchCamera:(id)sender {
    
    if([[self.captureManager captureSession] isRunning])
    {
        [self.captureManager swapFrontAndBackCameras];
    }
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSLog(@"cvrEditController: view did disappear");
    
    [super viewDidDisappear:animated];
    
    if([[self.captureManager captureSession] isRunning])
    {
        [[self.captureManager captureSession] stopRunning];
    }
    
//    if(timer != nil)
//        [timer invalidate];
//    
//    timer = nil;
//    
//    NSArray *viewsToRemove = [_categoryScrollView subviews];
//    for (UIView *v in viewsToRemove) [v removeFromSuperview];
    
}

- (void)dealloc {
    NSLog(@"cvrEditController: View did dealloc");
    
    NSArray *viewsToRemove = [_categoryScrollView subviews];
    for (UIView *v in viewsToRemove) [v removeFromSuperview];
    [_categoryScrollView release];
    [_btnPhotoSelector release];
    [_onBackScene release];
    [_editBoarder release];
    [_editboarderContainer release];
    [_confirmBtn release];
    [_alertView release];
    [_cameraContainer release];
    [_label1 release];
    [_label2 release];
    [_label3 release];
    [_label4 release];
    [_alertButton1 release];
    [_alertButton2 release];

    [_captureManager release];
    [super dealloc];
}
- (void)viewDidUnload {
    
    NSLog(@"cvrEditController: View Did Unload");
    
    [self setCategoryScrollView:nil];
    [self setBtnPhotoSelector:nil];
    [self setOnBackScene:nil];
    [self setEditBoarder:nil];
    [self setEditboarderContainer:nil];
    [self setConfirmBtn:nil];
    [self setAlertView:nil];
    [super viewDidUnload];
}



@end
