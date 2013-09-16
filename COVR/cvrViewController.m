//
//  cvrViewController.m
//  COVR
//
//  Created by albert on 8/13/13.
//  Copyright (c) 2013 Choir Boys. All rights reserved.
//

#import "cvrViewController.h"
#import "SymbolView.h"
#import "cvrEditController.h"
#import "cvrAppDelegate.h"
#import <time.h>

@interface cvrViewController ()

@end

@implementation cvrViewController

@synthesize m_categoryIndex, timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    m_categoryIndex = 0;
    
//    _labelCategoryText.font = [UIFont fontWithName:@"MachineScript" size:14];
    
    [self calcScrollView];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if(screenHeight == 480)
        [self resizeForiPhone4];
    
    cvrAppDelegate* delegate = (cvrAppDelegate*)[[UIApplication sharedApplication] delegate];
    if(delegate.firstLaunched)
    {
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(finishSplash) userInfo:nil repeats:NO];
        delegate.firstLaunched = NO;
    }
}

-(void) finishSplash
{
    _splashView.hidden = YES;
    _imgSplashView.hidden = YES;
}

- (void) calcScrollView
{
    if(timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
    
    NSArray *viewsToRemove = [_categoryScrollView subviews];
    for (UIView *v in viewsToRemove) [v removeFromSuperview];
    
    int categoryCount = 14;
    switch(m_categoryIndex)
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
//        strPath = [NSString stringWithFormat:@"category%d_%d.jpg",m_categoryIndex+1, i+1];
        
        SymbolView * viewSymbol = [[SymbolView alloc] initWithImagePath:nil frame:CGRectMake(posx, 0, 90, 90)];
            
        [viewSymbol addTarget:self action:@selector(actionSymbol:)];
        [_categoryScrollView addSubview:viewSymbol];
            
        viewSymbol.tag = i + 1;
        posx += 102.5f;
        [viewSymbol release];

    }
    
    [_categoryScrollView setContentSize:CGSizeMake(12.5f + 102.5f * categoryCount, 90.0f)];
    [self loadScrollContent:_categoryScrollView];
    
    if(timer == nil)
        timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(loadScrollValue) userInfo:nil repeats:YES];
}

-(void)loadScrollValue{
    NSArray *views = [_categoryScrollView subviews];

    for (UIView *v in views)
    {
        SymbolView* sv = (SymbolView*) v;
        int tag = sv.tag;
        if(sv.viewImage.image == nil)
        {
            NSString * strPath = [NSString stringWithFormat:@"category%d_%d.jpg",m_categoryIndex+1, tag];
            [sv setImagePath:strPath];
            break;
        }       
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   [self loadScrollContent:scrollView];
}


- (void) loadScrollContent:(UIScrollView *)scrollView
{
    NSArray *views = [_categoryScrollView subviews];
    CGPoint offset = scrollView.contentOffset;
    CGSize size = scrollView.frame.size;
    CGRect rect = CGRectMake(offset.x, offset.y, size.width, size.height);
    for (UIView *v in views)
    {
        CGPoint point = v.frame.origin;
        CGPoint point2 = CGPointMake(point.x + v.frame.size.width, point.y);
        if(CGRectContainsPoint(rect, point) || CGRectContainsPoint(rect, point2))
        {
            SymbolView* sv = (SymbolView*) v;
            int tag = sv.tag;
            if(sv.viewImage.image == nil)
            {
                NSString * strPath = [NSString stringWithFormat:@"category%d_%d.jpg",m_categoryIndex+1, tag];
                [sv setImagePath:strPath];
            }
        }
    }
}

-  (void) resizeForiPhone4
{
    _m_categoryBG.frame = CGRectMake(35.0f, 55.0f, 250.0f, 250.0f);
    _categoryScrollView.frame = CGRectMake(0, 313, 320, 90);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _categoryScrollView.delegate = self;
}

-(void) actionSymbol:(id)sender
{
    SymbolView* sv = (SymbolView*) sender;
    
    cvrAppDelegate* delegate = (cvrAppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.categoryIndex = m_categoryIndex;
    delegate.album_index = sv.tag;
    
    cvrEditController* cvrViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cvrEditController"];
    [self.navigationController pushViewController:cvrViewController animated:YES];
}

- (IBAction)onSelectedCategoryButton:(id)sender {
    
    cvrAppDelegate* delegate = (cvrAppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.categoryIndex = m_categoryIndex;
    delegate.album_index = 1;
    
    cvrEditController* cvrViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cvrEditController"];
    [self.navigationController pushViewController:cvrViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_rightArrowBtn release];
    [_leftArrowBtn release];
    [_m_categorySelector release];
    [_labelCategoryText release];
    [_categoryScrollView release];
    [_m_categoryBG release];
    [timer release];
    
    [_splashView release];
    [_imgSplashView release];
    [super dealloc];
}

- (void)viewDidUnload {
    
    [self setRightArrowBtn:nil];
    [self setLeftArrowBtn:nil];
    [self setM_categorySelector:nil];
    [self setLabelCategoryText:nil];
    [self setCategoryScrollView:nil];
    [super viewDidUnload];
    
}

- (IBAction)onRightArrowTouchUp:(id)sender {
    m_categoryIndex++;
    if(m_categoryIndex >= 6)
        m_categoryIndex = 0;
    
    [self calcScrollView];
    [self refreshCategory];
}

- (IBAction)onLeftArrowTouchUp:(id)sender {
    m_categoryIndex--;
    
    if (m_categoryIndex < 0) {
        m_categoryIndex = 5;
    }
    
    [self calcScrollView];
    [self refreshCategory];
}

- (void) refreshCategory
{
    NSString* categoryName = [NSString stringWithFormat:@"%@%d%@", @"category", m_categoryIndex + 1, @".png"];
    
    UIImage* img = [UIImage imageNamed:categoryName];
    [_m_categorySelector setImage:img forState:UIControlStateNormal];
    
    if(m_categoryIndex == 0)
    {
        [_labelCategoryText setText:@"Your friends will get it. But your mom..."];
    }else if(m_categoryIndex == 1)
    {
        [_labelCategoryText setText:@"You know you love them classic!"];
    }else if(m_categoryIndex == 2)
    {
         [_labelCategoryText setText: @"This is serious Covering! Are you up for it?"];
    }else if(m_categoryIndex == 3)
    {
        [_labelCategoryText setText: @"You hum their songs, how about a cover?"];
    }else if(m_categoryIndex == 4)
    {
        [_labelCategoryText setText: @"The more the merrier! Party time!"];
    }else if(m_categoryIndex == 5)
    {
        [_labelCategoryText setText: @"Share the fun with you your better half!"];
    }

}
@end
