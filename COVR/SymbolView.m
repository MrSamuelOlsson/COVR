//
//  SymbolView.m
//  ImageSlider
//
//  Created by Xuemin Wen on 5/19/12.
//  Copyright (c) 2013 Choir Boys. All rights reserved.
//

#import "SymbolView.h"

@implementation SymbolView

@synthesize btnBack, viewImage, viewShadow;
@synthesize strImageName;

- (void)addTarget:(id)target action:(SEL)action
{
    atarget = target;
    aselector = action;
}

-(BOOL) isSelected
{
    return btnBack.tag;
}

-(void) setSelect:(BOOL)bSelect
{
    if (bSelect)
        [btnBack setImage:[UIImage imageNamed:@"symbol-selected.png"] forState:UIControlStateNormal];
    else
        [btnBack setImage:nil forState:UIControlStateNormal];
    btnBack.tag = bSelect;
}

-(void) actionPressed
{   
    if ([atarget canPerformAction:aselector withSender:self])
        [atarget performSelector:aselector withObject:self];
}


- (id)initWithImagePath:(NSString *)strPath frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        UIImageView * vimgBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-view.png"]];
        [vimgBack setFrame:CGRectMake(SYMBOL_MARGIN / 2, SYMBOL_MARGIN / 2, SYMBOL_SIZE - SYMBOL_MARGIN, SYMBOL_SIZE - SYMBOL_MARGIN)];
        [self addSubview:vimgBack];
        [vimgBack release];
        viewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SYMBOL_SIZE - SYMBOL_MARGIN , SYMBOL_SIZE - SYMBOL_MARGIN)];

        if (strPath == nil)
            [viewImage setImage:nil];
        else
            [viewImage setImage:[UIImage imageNamed:strPath]];
        
        viewShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inner_shadow.png"]];
        [viewShadow setFrame:CGRectMake(0, 0, SYMBOL_SIZE -SYMBOL_MARGIN, SYMBOL_SIZE - SYMBOL_MARGIN)];

        btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SYMBOL_SIZE, SYMBOL_SIZE)];
        [btnBack addTarget:self action:@selector(actionPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:viewImage];
        [self addSubview:viewShadow];
        [self addSubview:btnBack];
        strImageName = [strPath retain];
    }
    return self;
}

-(id)setImagePath:(NSString *) strPath
{
    if (strPath == nil)
        [viewImage setImage:nil];
    else
        [viewImage setImage:[UIImage imageNamed:strPath]];
}

-(void) dealloc
{
    [btnBack release];
    [strImageName release];
    [viewImage release];
    [viewShadow release];
    [super dealloc];
}

@end
