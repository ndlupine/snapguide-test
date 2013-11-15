//
//  NLSnapguideTestViewController.h
//  SnapguideTest
//
//  Created by Nick Lupinetti on 11/21/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLLoadingView.h"

@interface NLSnapguideTestViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *feedItems;
@property (nonatomic, retain) NLLoadingView *loadingView;

- (void)loadPopularImages;

@end
