//
//  NLLoadingView.h
//  SnapguideTest
//
//  Created by Nick Lupinetti on 11/23/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLLoadingView : UIView

@property (nonatomic, getter = isDisplayed) BOOL displayed;

- (void)setDisplayed:(BOOL)displayed animated:(BOOL)animated;
- (void)displayWithText:(NSString*)text animated:(BOOL)animated;

@end
