//
//  NLLoadingView.m
//  SnapguideTest
//
//  Created by Nick Lupinetti on 11/23/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "NLLoadingView.h"
#import <QuartzCore/QuartzCore.h>

@interface NLLoadingView ()

@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, retain) UIView *roundRectView;
@property (nonatomic, retain) UILabel *activityText;

@end

@implementation NLLoadingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        CGRect roundRectFrame = CGRectMake(0, 0, 100, 100);
        roundRectFrame.origin.x = floorf((frame.size.width - roundRectFrame.size.width) / 2.0);
        roundRectFrame.origin.y = floorf((frame.size.height - roundRectFrame.size.height) / 2.0);
        self.roundRectView = [[[UIView alloc] initWithFrame:roundRectFrame] autorelease];
        self.roundRectView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        self.roundRectView.layer.cornerRadius = 10.0;
        self.roundRectView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;

        self.activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        CGRect activityFrame = self.activityView.frame;
        activityFrame.origin.x = floorf((roundRectFrame.size.width - activityFrame.size.width) / 2.0);
        activityFrame.origin.y = floorf((roundRectFrame.size.height - activityFrame.size.height) / 2.0) - 10;
        self.activityView.frame = activityFrame;
        
        CGRect textFrame = CGRectZero;
        textFrame.size.width = roundRectFrame.size.width;
        textFrame.origin.y = CGRectGetMaxY(activityFrame) + 10;
        textFrame.size.height = 20.0;
        self.activityText = [[[UILabel alloc] initWithFrame:textFrame] autorelease];
        self.activityText.backgroundColor = [UIColor clearColor];
        self.activityText.textColor = [UIColor whiteColor];
        self.activityText.font = [UIFont boldSystemFontOfSize:16.0];
        self.activityText.textAlignment = NSTextAlignmentCenter;
        
        [self.roundRectView addSubview:self.activityView];
        [self.roundRectView addSubview:self.activityText];
        [self addSubview:self.roundRectView];
    }
    return self;
}

- (void)dealloc {
    [_roundRectView release];
    [_activityText release];
    [_activityView release];
    [super dealloc];
}

- (void)setDisplayed:(BOOL)displayed {
    [self setDisplayed:displayed animated:NO];
}

- (void)setDisplayed:(BOOL)displayed animated:(BOOL)animated {
    _displayed = displayed;
    
    NSTimeInterval duration = animated ? 0.2 : 0.0;
    CGFloat alpha = displayed ? 1.0 : 0.0;
    
    if (displayed) {
        self.hidden = NO;
        [self.activityView startAnimating];
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.alpha = alpha;
    } completion:^(BOOL finished) {
        if (finished && !displayed) {
            [self.activityView stopAnimating];
            self.hidden = YES;
        }
    }];
}

- (void)displayWithText:(NSString*)text animated:(BOOL)animated {
    self.activityText.text = text;
    
    [self setDisplayed:YES animated:animated];
}

@end
