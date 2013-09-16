//
//  cvrShareController.m
//  COVR
//
//  Created by albert on 8/22/13.
//  Copyright (c) 2013 Choir Boys. All rights reserved.
//

#import "cvrShareController.h"
#import "cvrViewController.h"
#import "cvrAppDelegate.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <Social/Social.h>
#import "SymbolView.h"

@interface cvrShareController ()

@end

@implementation cvrShareController

@synthesize dic, library, imageForReset, assetGroup, assets, timer;

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
    
    cvrAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    [_resultImageView setImage:appDelegate.effectedImage];
    
    self.imageForReset = appDelegate.effectedImage;
    
    self.library = [[[ALAssetsLibrary alloc] init] autorelease];
    
    self.assets = [[[NSMutableArray alloc] init] autorelease];
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            NSString * albumName = @"COVR";
           if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame)
            {
                self.assetGroup = group;
                
                ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    
                    if (result) {
                        [self.assets addObject:result];
                    }
                };
                
                ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
                [self.assetGroup setAssetsFilter:onlyPhotosFilter];
                [self.assetGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
            }
        }
    };
    
    NSUInteger groupTypes = ALAssetsGroupAlbum;
    [self.library enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        if (error!=nil) {
            NSLog(@"Big error: %@", [error description]);
        }
    }];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if(screenHeight == 480)
        [self resizeForiPhone4];
}

- (void) viewDidAppear:(BOOL)animated
{
    if(self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    NSArray *viewsToRemove = [_resultScrollView subviews];
    for (UIView *v in viewsToRemove) [v removeFromSuperview];
    
    cvrAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    float posx = 12.5f;
    int count = [self.assets count];
    for (int i = 0; i < count + 1; i++)
    {
        SymbolView * viewSymbol = [[SymbolView alloc] initWithImagePath:nil frame:CGRectMake(posx, 0, 90, 90)];
        
        [viewSymbol addTarget:self action:@selector(onSelectResultImg:)];
        
        if(i == 0)
            viewSymbol.viewImage.image = appDelegate.effectedImage;

        [_resultScrollView addSubview:viewSymbol];
        viewSymbol.tag = i + 1;
        posx += 102.5f;
        [viewSymbol release];
    }
    
    [_resultScrollView setContentSize:CGSizeMake(12.5f + 102.5f * (count + 1), 90)];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(loadScrollValue) userInfo:nil repeats:YES];
}

-(void)loadScrollValue{
    NSArray *views = [_resultScrollView subviews];
    
    for (UIView *v in views)
    {
        SymbolView* bv = (SymbolView*) v;
        int tag = bv.tag;
        if(bv.viewImage.image == nil)
        {
            ALAsset *asset = [self.assets objectAtIndex:tag-2];
            CGImageRef thumbnailImageRef = [asset thumbnail];
            UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];           
           
            bv.viewImage.image = thumbnail;
            break;
        }
        
    }
}

-  (void) resizeForiPhone4
{
    _finalCoverBG.frame = CGRectMake(0.0f, 30.0f, 320.0f, 320.0f);
    _resultImageView.frame = CGRectMake(57.0f, 61.0f, 206.0f, 206.0f);
    _groovyEffect.frame = CGRectMake(137.0f, 181.0f, 163.0f, 125.0f);
    
    _resultScrollView.frame = CGRectMake(0, 317.5f, 218, 90);
    _shareButton.frame = CGRectMake(217.5f, 317.5f, 90, 90);
}

- (IBAction)onSelectResultImg:(id)sender
{
    UIButton* btn = (UIButton*) sender;
    cvrAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    if([self.assets count] > 0)
    {
        if(btn.tag > 1)
        {
            ALAsset *asset = [self.assets objectAtIndex:btn.tag-2];
            ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
            
            UIImage *img = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage] scale:[assetRepresentation scale] orientation:(UIImageOrientation)[assetRepresentation orientation]];
            
            appDelegate.effectedImage = img;
            
            [_resultImageView setImage:appDelegate.effectedImage];
        }else
        {
            appDelegate.effectedImage = self.imageForReset;
            
            [_resultImageView setImage:appDelegate.effectedImage];
        }
        
//        if(btn.tag == 1)
//            self.groovyEffect.hidden = NO;
//        else
            self.groovyEffect.hidden = YES;
    }
}

- (IBAction)onShareImageFacebook:(id)sender {

    cvrAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
    
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [mySLComposerSheet setInitialText:@"You can use COVR app with fun!"];
        
        [mySLComposerSheet addImage:appDelegate.effectedImage];
        
        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://www.covr.com"]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
//    }else
//    {
//        NSString *message = @"The application cannot send a Facebook at the moment. This is because it cannot reach Facebook or you don't have a Facebook account associated with this device.";
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
//        [alertView show];
//    }
}



- (IBAction)onShareImageTweeter:(id)sender {
    
    cvrAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [mySLComposerSheet setInitialText:@"You can use COVR app with fun!"];
        
        [mySLComposerSheet addImage:appDelegate.effectedImage];
        
        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://www.covr.com"]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    } else {
        // Show Alert View When The Application Cannot Send Tweets
        NSString *message = @"The application cannot send a tweet at the moment. This is because it cannot reach Twitter or you don't have a Twitter account associated with this device. Please shceck your connection or twitter setting.";
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (IBAction)onShareImageInstagram:(id)sender {
    [self ShareInstagram];
}

-(void)ShareInstagram
{
    UIImagePickerController *imgpicker=[[UIImagePickerController alloc] init];
    imgpicker.delegate=self;
    [self storeimageToInstagram];
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        
        CGRect rect = CGRectMake(0 ,0 , 612, 612);

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"15717.igo"];        
       
        NSURL *igImageHookFile = [NSURL fileURLWithPath:savedImagePath];        
       
        self.dic=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
        self.dic.UTI = @"com.instagram.exclusivegram";
        self.dic.delegate=self;
        [self.dic presentOpenInMenuFromRect: rect    inView: self.view animated: YES ];
         // [[UIApplication sharedApplication] openURL:instagramURL];
    }
    else
    {
        //   NSLog(@"instagramImageShare");
        UIAlertView *errorToShare = [[UIAlertView alloc] initWithTitle:@"Instagram unavailable " message:@"You need to install Instagram in your device in order to share this image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        errorToShare.tag=3010;
        [errorToShare show];
        [errorToShare release];
    }
}


- (void) storeimageToInstagram
{
    cvrAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"15717.igo"];
    UIImage *NewImg=[self resizedImage:appDelegate.effectedImage :CGRectMake(0, 0, 306, 306) ];
    NSData *imageData = UIImagePNGRepresentation(NewImg);
    [imageData writeToFile:savedImagePath atomically:NO];
}

-(UIImage*) resizedImage:(UIImage *)inImage: (CGRect) thumbRect
{
    CGImageRef imageRef = [inImage CGImage];
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    // There's a wierdness with kCGImageAlphaNone and CGBitmapContextCreate
    // see Supported Pixel Formats in the Quartz 2D Programming Guide
    // Creating a Bitmap Graphics Context section
    // only RGB 8 bit images with alpha of kCGImageAlphaNoneSkipFirst, kCGImageAlphaNoneSkipLast, kCGImageAlphaPremultipliedFirst,
    // and kCGImageAlphaPremultipliedLast, with a few other oddball image kinds are supported
    // The images on input here are likely to be png or jpeg files
    if (alphaInfo == kCGImageAlphaNone)
        alphaInfo = kCGImageAlphaNoneSkipLast;
    
    // Build a bitmap context that's the size of the thumbRect
    CGContextRef bitmap = CGBitmapContextCreate(
                                                NULL,
                                                thumbRect.size.width,       // width
                                                thumbRect.size.height,      // height
                                                CGImageGetBitsPerComponent(imageRef),   // really needs to always be 8
                                                4 * thumbRect.size.width,   // rowbytes
                                                CGImageGetColorSpace(imageRef),
                                                alphaInfo
                                                );
    
    // Draw into the context, this scales the image
    CGContextDrawImage(bitmap, thumbRect, imageRef);
    
    // Get an image from the context and a UIImage
    CGImageRef  ref = CGBitmapContextCreateImage(bitmap);
    UIImage*    result = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);   // ok if NULL
    CGImageRelease(ref);
    
    return result;
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate
{    
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    interactionController.delegate = self;
    
    return interactionController;
}

- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller
{
    
}

- (BOOL)documentInteractionController:(UIDocumentInteractionController *)controller canPerformAction:(SEL)action
{
    return YES;
}

- (BOOL)documentInteractionController:(UIDocumentInteractionController *)controller performAction:(SEL)action
{ 
    return YES;
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application
{

}


#pragma mark - user interation
- (IBAction)onClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickDone:(id)sender {
    
    if(self.timer != nil)
    {
        [self.timer invalidate];
    }
    
    cvrAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    [self.library saveImage:appDelegate.effectedImage toAlbum:@"COVR" withCompletionBlock:^(NSError *error) {
        if (error!=nil) {
            NSLog(@"Big error: %@", [error description]);
        }
    }];
    
   // UIImageWriteToSavedPhotosAlbum(appDelegate.effectedImage, self, nil, nil);
    
  
    //[self.navigationController pushViewController:cvrController animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
//    NSLog(@"cvrShareController: view did dealloc");
    
    [timer release];
    
    [_resultImageView release];
    [_finalCoverBG release];
    [_groovyEffect release];
    [_shareButton release];
    
    int count = [self.assets count];
    
    for (int i = 0; i < count; i++) {
        [[assets objectAtIndex:i] release];
    }

    
//    [assets release];
    
    [assetGroup release];

    NSArray *viewsToRemove = [_resultScrollView subviews];
    for (UIView *v in viewsToRemove) [v removeFromSuperview];
    
    [_resultScrollView release];
    [library release];
    [dic release];
    
   
    [super dealloc];
}

- (void)viewDidUnload {
    
    NSLog(@"cvrShareController: viewdidunload");
    [self setResultImageView:nil];
    self.library = nil;
    
    [self setResultScrollView:nil];   
 
    
    [super viewDidUnload];
}
@end
