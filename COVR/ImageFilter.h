
#import <Foundation/Foundation.h>

enum {
    CurveChannelNone                 = 0,
    CurveChannelRed					 = 1 << 0,
    CurveChannelGreen				 = 1 << 1,
    CurveChannelBlue				 = 1 << 2,
};
typedef NSUInteger CurveChannel;

@interface UIImage (ImageFilter)

/* Filters */
- (UIImage*) hueFilter:(double)angle;
- (UIImage*) bwFilter:(double)levels;
- (UIImage*)noise:(double)amount;

/* Color Correction */
- (UIImage*) levels:(NSInteger)black mid:(NSInteger)mid white:(NSInteger)white;
- (UIImage*) applyCurve:(NSArray*)points toChannel:(CurveChannel)channel;
- (UIImage*) adjust:(double)r g:(double)g b:(double)b;

/* Convolve Operations */
- (UIImage*) sharpen;
- (UIImage*) edgeDetect;
- (UIImage*) gaussianBlur:(NSUInteger)radius;
- (UIImage*) vignette;
- (UIImage*) darkVignette;
- (UIImage*) polaroidish;

/* Blend Operations */
- (UIImage*) overlay:(UIImage*)other;

/* Pre-packed filter sets */
- (UIImage*) lomo;

- (UIImage*) copyImage:(UIImage*)img;
@end
