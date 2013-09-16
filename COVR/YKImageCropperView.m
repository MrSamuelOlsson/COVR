//

#import "YKImageCropperView.h"

#import "YKImageCropperOverlayView.h"

typedef NS_ENUM(NSUInteger, OverlayViewPanningMode) {
    OverlayViewPanningModeNone     = 0,
    OverlayViewPanningModeLeft     = 1 << 0,
    OverlayViewPanningModeRight    = 1 << 1,
    OverlayViewPanningModeTop      = 1 << 2,
    OverlayViewPanningModeBottom   = 1 << 3
};

static CGSize minSize = {40, 40};

@interface YKImageCropperView ()

// Remember first touched point
@property (nonatomic, assign) CGPoint firstTouchedPoint;

// Panning mode for oeverlay view
@property (nonatomic, assign) OverlayViewPanningMode OverlayViewPanningMode;

// Returns if panning is for overlay view
@property (nonatomic, assign) BOOL isPanningOverlayView;
@property (nonatomic, assign) BOOL isMovingOverlayView;

// Current scale (up to 1)
@property (nonatomic, assign) CGFloat currentScale;

// Image view
@property (nonatomic, strong) UIImageView *imageView;

// Minimum size for image, maximum size for overlay
@property (nonatomic, assign) CGRect baseRect;

// Overlay view
@property (nonatomic, strong) YKImageCropperOverlayView *overlayView;

@property(nonatomic,assign) CGPoint touchCenter;
@property(nonatomic,assign) CGPoint rotationCenter;

@end

@implementation YKImageCropperView

@synthesize touchCenter = _touchCenter;
@synthesize rotationCenter = _rotationCenter;

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = screenRect.size.height;
            
        self.image = image;
        
        if(screenHeight == 480)
            self.frame = CGRectMake(0, 0,
                                250,
                                250);
        else
            self.frame = CGRectMake(0, 0,
                                    320,
                                    320);
        
        self.backgroundColor = [UIColor clearColor];

        self.imageView = [[[UIImageView alloc] init] autorelease];
        
        self.imageView.image = image;

        CGRect frame;
        frame.size = self.frame.size;
        frame.origin = self.frame.origin;
        self.imageView.frame = frame;
        self.imageView.center = self.center;
        self.baseRect = self.imageView.frame;
        [self addSubview:self.imageView];

        // Overlay
        self.overlayView = [[[YKImageCropperOverlayView alloc] initWithFrame:self.frame] autorelease];
        self.overlayView.maxSize = self.baseRect.size;
        [self addSubview:self.overlayView];

        UIPanGestureRecognizer *panGestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(panGesture:)] autorelease];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:panGestureRecognizer];
        
        UIRotationGestureRecognizer *rotationRecognizer = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)] autorelease];
        [self addGestureRecognizer:rotationRecognizer];
        
         UIPinchGestureRecognizer *pinchRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)] autorelease];
        [self addGestureRecognizer:pinchRecognizer];
        
        [self setClipsToBounds:YES];
        
        [self reset];
    }

    return self;
}

- (void) setCoverImage:(UIImage*) imgCover
{
    [self.overlayView setImage:imgCover];
    [self.overlayView setFlip];
    [self.overlayView setNeedsDisplay];
    
}

-(void) setOrigImage:(UIImage*) img
{
    self.image = img;
    self.imageView.image = img;
    
    CGRect frame;
    frame.origin = CGPointMake(0, 0);
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if(screenHeight == 480)
        frame.size = CGSizeMake(250, 250);
    else
        frame.size = CGSizeMake(320, 320);
    self.imageView.frame = frame;
    self.imageView.center = self.center;
    self.baseRect = self.imageView.frame;    
}

- (UIImage *)editedImage {

    self.overlayView.showFrameRect = NO;
    [self.overlayView setAlpha:1.0f];
    [self.overlayView setNeedsDisplay];
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
  
    UIGraphicsEndImageContext();
    
    self.overlayView.showFrameRect = YES;
    [self.overlayView setAlpha:0.7f];
    [self.overlayView setNeedsDisplay];
    
    return img;
//    return result;
}

- (void)reset {
    self.currentScale = 1.0;
    self.imageView.frame = self.baseRect;
    CGRect clearRect = self.baseRect;
    clearRect.origin = CGPointMake(self.frame.size.width / 6.0f,
                                   self.frame.size.height / 6.0f);
    clearRect.size = CGSizeMake(self.baseRect.size.width * 2.0f / 3.0f, self.baseRect.size.height * 2.0f / 3.0f);
    self.overlayView.clearRect = clearRect;
    [self.overlayView setNeedsDisplay];
}

- (void)square {
    [self setConstrain:CGSizeMake(1, 1)];
}

- (void)setConstrain:(CGSize)size {
    CGFloat constrainRatio = size.width / size.height;
    CGFloat currentRatio = self.overlayView.clearRect.size.width / self.overlayView.clearRect.size.height;
    CGSize newSize = self.overlayView.clearRect.size;

    if (currentRatio > constrainRatio) {
        newSize.width = newSize.height * constrainRatio;
    } else {
        newSize.height = newSize.width * (size.height / size.width);
    }

    // Size should be bigger than min size
    if (newSize.width < minSize.width || newSize.height < minSize.height) {
        if (size.height / size.width > 1) {
            newSize.width = minSize.width;
            newSize.height = minSize.width * size.height / size.width;
        } else {
            newSize.width = minSize.width * size.width / size.height;
            newSize.height = minSize.height;
        }
    }

    CGRect frame = self.overlayView.clearRect;
    frame.size = newSize;
    self.overlayView.clearRect = frame;

    [self.overlayView setNeedsDisplay];
}

- (CGSize)getImageSizeForPreview:(UIImage *)image {
    CGFloat maxWidth = self.frame.size.width, maxHeight = self.frame.size.height;

    CGSize size = image.size;

    if (size.width > maxWidth) {
        size.height *= (maxWidth / size.width);
        size.width = maxWidth;
    }

    if (size.height > maxHeight) {
        size.width *= (maxHeight / size.height);
        size.height = maxHeight;
    }

    if (size.width < minSize.width) {
        size.height *= (minSize.width / size.width);
        size.width = minSize.width;
    }

    if (size.height < minSize.height) {
        size.width *= (minSize.height / size.height);
        size.height = minSize.height;
    }

    return size;
}

- (void)setCurrentScale:(CGFloat)currentScale {
    _currentScale = MAX(1.0f, currentScale);
}

- (BOOL)shouldRevertX {
    CGRect clearRect = self.overlayView.clearRect;
    CGRect imageRect = self.imageView.frame;

    if (CGRectGetMinX(imageRect) > CGRectGetMinX(clearRect)
        || CGRectGetMaxX(imageRect) < CGRectGetMaxX(clearRect)) {
        return YES;
    }

    if (CGRectGetMinX(clearRect) < CGRectGetMinX(self.baseRect)
        || CGRectGetMaxX(clearRect) > CGRectGetMaxX(self.baseRect)) {
        return YES;
    }

    if (clearRect.size.width < minSize.width) {
        return YES;
    }

    return NO;
}

- (BOOL)shouldRevertY {
    CGRect clearRect = self.overlayView.clearRect;
    CGRect imageRect = self.imageView.frame;

    if (CGRectGetMinY(imageRect) > CGRectGetMinY(clearRect)
        || CGRectGetMaxY(imageRect) < CGRectGetMaxY(clearRect)) {
        return YES;
    }

    if (CGRectGetMinY(clearRect) < CGRectGetMinY(self.baseRect)
        || CGRectGetMaxY(clearRect) > CGRectGetMaxY(self.baseRect)) {
        return YES;
    }

    if (clearRect.size.height < minSize.height) {
        return YES;
    }

    return NO;
}


- (OverlayViewPanningMode)getOverlayViewPanningModeByPoint:(CGPoint)point {
    if (CGRectContainsPoint(self.overlayView.topLeftCorner, point)) {
        return (OverlayViewPanningModeLeft | OverlayViewPanningModeTop);
    } else if (CGRectContainsPoint(self.overlayView.topRightCorner, point)) {
        return (OverlayViewPanningModeRight | OverlayViewPanningModeTop);
    } else if (CGRectContainsPoint(self.overlayView.bottomLeftCorner, point)) {
        return (OverlayViewPanningModeLeft | OverlayViewPanningModeBottom);
    } else if (CGRectContainsPoint(self.overlayView.bottomRightCorner, point)) {
        return (OverlayViewPanningModeRight | OverlayViewPanningModeBottom);
    } else if (CGRectContainsPoint(self.overlayView.topEdgeRect, point)) {
        return OverlayViewPanningModeTop;
    } else if (CGRectContainsPoint(self.overlayView.rightEdgeRect, point)) {
        return OverlayViewPanningModeRight;
    } else if (CGRectContainsPoint(self.overlayView.bottomEdgeRect, point)) {
        return OverlayViewPanningModeBottom;
    } else if (CGRectContainsPoint(self.overlayView.leftEdgeRect, point)) {
        return OverlayViewPanningModeLeft;
    }

    return OverlayViewPanningModeNone;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    [self.overlayView setNeedsDisplay];
    
    if ([touches count] == 1) {
        self.firstTouchedPoint = [(UITouch*)[touches anyObject] locationInView:self];
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)sender {

        CGPoint translation = [sender translationInView:self.overlayView];
        CGAffineTransform transform = CGAffineTransformTranslate( self.overlayView.transform, translation.x, translation.y);
        self.overlayView.transform = transform;
    
        CGRect rect = [self.overlayView frame];
    
        float center_x = rect.origin.x + (rect.size.width / 2);
        float center_y = rect.origin.y + (rect.size.height / 2);
    
//    NSLog(@"center_x:%f center_y:%f", center_x, center_y);
        if(center_x < 0 || center_x > self.imageView.frame.size.width)
        {
            CGAffineTransform transform2 = CGAffineTransformTranslate( self.overlayView.transform, -translation.x, -translation.y);
            self.overlayView.transform = transform2;
            
//            NSLog(@"center_x over over!!!!!!!");
        }else if(center_y < 0 || center_y > self.imageView.frame.size.height)
        {
            CGAffineTransform transform2 = CGAffineTransformTranslate( self.overlayView.transform, -translation.x, -translation.y );
            self.overlayView.transform = transform2;
            
//             NSLog(@"center_y over over!!!!!!!");
        }
    
        [sender setTranslation:CGPointMake(0, 0) inView:self];

}

- handleRotation:(UIRotationGestureRecognizer*)recognizer
{
        if(recognizer.state == UIGestureRecognizerStateBegan){
            self.rotationCenter = self.touchCenter;
        }
        
//        CGFloat deltaX = self.rotationCenter.x-self.imageView.bounds.size.width/2;
//        CGFloat deltaY = self.rotationCenter.y-self.imageView.bounds.size.height/2;
    
        CGAffineTransform transform= CGAffineTransformRotate(self.overlayView.transform, recognizer.rotation);
        self.overlayView.transform = transform;
        
        recognizer.rotation = 0;
}

- handlePinch:(UIPinchGestureRecognizer *)recognizer
{
        CGAffineTransform transform = CGAffineTransformScale(self.overlayView.transform, recognizer.scale, recognizer.scale);
    
        self.overlayView.transform = transform;
        recognizer.scale = 1;
}

- (void)panOverlayView:(UIPanGestureRecognizer *)sender {
    CGPoint d = [sender translationInView:self];
    CGRect oldClearRect = self.overlayView.clearRect;
    CGRect newClearRect = self.overlayView.clearRect;

    if (self.OverlayViewPanningMode & OverlayViewPanningModeLeft) {
        newClearRect.origin.x += d.x;
        newClearRect.size.width -= d.x;
    } else if (self.OverlayViewPanningMode & OverlayViewPanningModeRight) {
        newClearRect.size.width += d.x;
    }

    if (self.OverlayViewPanningMode & OverlayViewPanningModeTop) {
        newClearRect.origin.y += d.y;
        newClearRect.size.height -= d.y;
    } else if (self.OverlayViewPanningMode & OverlayViewPanningModeBottom) {
        newClearRect.size.height += d.y;
    }

    self.overlayView.clearRect = newClearRect;

    // Check x
    if ([self shouldRevertX]) {
        newClearRect.origin.x = oldClearRect.origin.x;
        newClearRect.size.width = oldClearRect.size.width;
    }

    // Check y
    if ([self shouldRevertY]) {
        newClearRect.origin.y = oldClearRect.origin.y;
        newClearRect.size.height = oldClearRect.size.height;
    }

    self.overlayView.clearRect = newClearRect;
    [self.overlayView setNeedsDisplay];
    
}

- (void)panImage:(UIPanGestureRecognizer *)sender {
    CGPoint d = [sender translationInView:self];
    CGRect oldClearRect = self.overlayView.clearRect;
    CGRect newClearRect = self.overlayView.clearRect;
    
    newClearRect.origin.x += d.x;
    newClearRect.origin.y += d.y;
    
    self.overlayView.clearRect = newClearRect;
    
    // Check x
    if ([self shouldRevertX]) {
        newClearRect.origin.x = oldClearRect.origin.x;
        newClearRect.size.width = oldClearRect.size.width;
    }
    
    // Check y
    if ([self shouldRevertY]) {
        newClearRect.origin.y = oldClearRect.origin.y;
        newClearRect.size.height = oldClearRect.size.height;
    }
    
    self.overlayView.clearRect = newClearRect;
    [self.overlayView setNeedsDisplay];
}

-(void) dealloc
{
    NSLog(@"YKImagennnnnnnnnnnn!");
    self.imageView = nil;
    self.overlayView = nil;    
    [super dealloc];
}

@end