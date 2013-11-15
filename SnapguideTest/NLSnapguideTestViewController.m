//
//  NLSnapguideTestViewController.m
//  SnapguideTest
//
//  Created by Nick Lupinetti on 11/21/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "NLSnapguideTestViewController.h"
#import "NLNetworkManager.h"
#import "NLInstagramPhoto.h"
#import "NLInstagramPhotoCell.h"

static NSString * const API_ENDPOINT = @"https://api.instagram.com/v1/media/popular?client_id=50c0e12b64a84dd0b9bbf334ba7f6bf6";
static NSString * const API_PAYLOAD_KEY = @"data";
static NSString * const kCellReuseIdentifier = @"Cell";

#define kTableRowHeight 313.0


@implementation NLSnapguideTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // configure table and header
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = kTableRowHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.tableView registerClass:[NLInstagramPhotoCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    
    UIButton *header = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 44)] autorelease];
    [header addTarget:self action:@selector(loadPopularImages) forControlEvents:UIControlEventTouchUpInside];
    header.backgroundColor = [UIColor grayColor];
    [header setTitle:NSLocalizedString(@"Find Images", nil) forState:UIControlStateNormal];
    [header setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [header setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    header.titleLabel.shadowOffset = CGSizeMake(0, 1);
    self.tableView.tableHeaderView = header;
    
    // configure loading view
    self.loadingView = [[[NLLoadingView alloc] initWithFrame:self.view.bounds] autorelease];
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.loadingView];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView scrollRectToVisible:CGRectMake(0, 44, 1, 1) animated:NO];
    [self loadPopularImages];
}

- (void)dealloc {
    [_tableView release];
    [_loadingView release];
    [_feedItems release];
    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NLNetworkManager sharedManager] cancelRequests];
}

- (void)loadPopularImages {
    [self.loadingView displayWithText:NSLocalizedString(@"Loading...", nil) animated:YES];
    
    NSURL *url = [NSURL URLWithString:API_ENDPOINT];
    NLNetworkManager *netMan = [NLNetworkManager sharedManager];
    [netMan cancelRequests];
    
    // load the json feed, parse it and store the results as instagram objects.
    // for each, spawn a new request for its related images. then reload the tableview
    [netMan requestURL:url completion:^(NSData *data) {
        NSDictionary *json = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray *results = [NSMutableArray arrayWithCapacity:[json[API_PAYLOAD_KEY] count]];
        
        for (NSDictionary *result in json[API_PAYLOAD_KEY]) {
            NLInstagramPhoto *listing = [[[NLInstagramPhoto alloc] initWithDictionary:result] autorelease];
            [results addObject:listing];
            NSIndexPath *listingPath = [NSIndexPath indexPathForRow:[results indexOfObject:listing] inSection:0];
            
            [netMan requestImageAtURL:listing.imageURL completion:^(UIImage *image) {
                listing.image = image;
                
                NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
                if ([visiblePaths containsObject:listingPath]) {
                    [self.tableView reloadRowsAtIndexPaths:@[listingPath] withRowAnimation:UITableViewRowAnimationFade];
                }
            } failure:nil];
            
            [netMan requestImageAtURL:listing.userImageURL completion:^(UIImage *image) {
                listing.userImage = image;
                
                NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
                if ([visiblePaths containsObject:listingPath]) {
                    [self.tableView reloadRowsAtIndexPaths:@[listingPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            } failure:nil];
        }
        
        NSArray *immutableCopy = [[results copy] autorelease];
        self.feedItems = immutableCopy;
        [self.loadingView setDisplayed:NO animated:YES];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"Could not load popular images.");
    }];
}

#pragma mark - Table view data source

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NLInstagramPhotoCell *cell = (NLInstagramPhotoCell*)[tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    
    [cell setInstagramPhoto: self.feedItems[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedItems.count;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NLInstagramPhotoCell *cell = (NLInstagramPhotoCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell setPhotoFocused:!cell.isPhotoFocused animated:YES];
    
    if (cell.isPhotoFocused) {
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

@end
