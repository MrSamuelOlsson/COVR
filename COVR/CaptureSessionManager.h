#define kImageCapturedSuccessfully @"imageCapturedSuccessfully"

#import "CoreMedia/CoreMedia.h"
#import "AVFoundation/AVFoundation.h"

@interface CaptureSessionManager : NSObject {

}

@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;
@property (retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, retain) UIImage *stillImage;

- (void)addVideoPreviewLayer;
- (void)addVideoInput;
- (void)addStillImageOutput;
- (void)captureStillImage;
- (void)swapFrontAndBackCameras;
@end
