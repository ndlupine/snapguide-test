//
//  NLInstagramPhotoCell.m
//  SnapguideTest
//
//  Created by Nick Lupinetti on 11/22/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "NLInstagramPhotoCell.h"
#import <QuartzCore/QuartzCore.h>

#define kPhotoFrame CGRectMake(7.0, 7.0, 306.0, 306.0)
#define kPhotoSize CGSizeMake (306.0, 306.0)
#define kUserSize CGSizeMake (30.0, 30.0)
#define kUserBorderSize 7.0
#define kUserBorderColor [UIColor colorWithWhite:0.9 alpha:0.8]

static UIImage * kGradientImage;

@interface NLInstagramPhotoCell ()

@property (nonatomic, retain) UIView *userView;
@property (nonatomic, retain) UIImageView *userImageView;
@property (nonatomic, retain) UIImageView *userGradientView;
@property (nonatomic, retain) UIImageView *photoImageView;
@property (nonatomic, retain) UILabel *userNameLabel;
@property (nonatomic, retain) UILabel *likeLabel;

+ (UIImage*)gradientImage;

@end

@implementation NLInstagramPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.photoImageView = [[[UIImageView alloc] init] autorelease];
        self.userNameLabel = [[[UILabel alloc] init] autorelease];
        self.likeLabel = [[[UILabel alloc] init] autorelease];
        self.userImageView = [[[UIImageView alloc] init] autorelease];
        self.userView = [[[UIView alloc] init] autorelease];
        self.userGradientView = [[[UIImageView alloc] init] autorelease];
        
        self.userNameLabel.backgroundColor = [UIColor clearColor];
        self.userNameLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.userNameLabel.textColor = [UIColor colorWithRed:0.15 green:0.05 blue:0.5 alpha:1.0];
        
        self.likeLabel.backgroundColor = kUserBorderColor;
        self.likeLabel.font = [UIFont systemFontOfSize:15.0];
        self.likeLabel.textColor = [UIColor darkGrayColor];
        self.likeLabel.textAlignment = NSTextAlignmentCenter;
        
        self.userView.backgroundColor = kUserBorderColor;
        
        self.photoImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [self.contentView addSubview:self.photoImageView];
        [self.photoImageView addSubview:self.userView];
        [self.photoImageView addSubview:self.likeLabel];
        [self.userView addSubview:self.userGradientView];
        [self.userView addSubview:self.userImageView];
        [self.userView addSubview:self.userNameLabel];
    }
    
    return self;
}

- (void)dealloc {
    [_photoImageView release];
    [_userImageView release];
    [_userGradientView release];
    [_userNameLabel release];
    [_userView release];
    [_likeLabel release];
    [super dealloc];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.photoFocused = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews]; 
    
    CGSize contentSize = self.contentView.frame.size;
    CGSize photoSize = self.photoImageView.image ? self.photoImageView.image.size : kPhotoSize;
    
    CGRect photoFrame = CGRectZero;
    photoFrame.size = self.photoImageView.image.size;
    photoFrame.origin.x = floorf((contentSize.width - photoSize.width) / 2.0);
    photoFrame.origin.y = floorf(contentSize.height - photoSize.height);
    
    CGRect userPhotoFrame = CGRectZero, userBorderFrame = CGRectZero;
    userBorderFrame.origin = CGPointMake(kUserBorderSize, kUserBorderSize);
    userBorderFrame.size.height = kUserSize.height + kUserBorderSize * 2.0;
    userPhotoFrame.origin = CGPointMake(kUserBorderSize, kUserBorderSize);
    userPhotoFrame.size = kUserSize;
    
    [self.userNameLabel sizeToFit];
    CGRect nameFrame = self.userNameLabel.frame;
    nameFrame.origin.x = CGRectGetMaxX(userPhotoFrame) + kUserBorderSize;
    nameFrame.origin.y = floorf((userBorderFrame.size.height - nameFrame.size.height) / 2.0);
    nameFrame.size.width = fminf(nameFrame.size.width, photoSize.width - kUserBorderSize - nameFrame.origin.x);
    
    CGFloat gradSize = userBorderFrame.size.height;
    userBorderFrame.size.width = fminf(CGRectGetMaxX(nameFrame), photoSize.width - kUserBorderSize * 2.0 - gradSize);
    
    CGRect gradientFrame = userBorderFrame;
    gradientFrame.size.width = gradSize;
    gradientFrame.origin.x = userBorderFrame.size.width;
    gradientFrame.origin.y = 0;
    
    [self.likeLabel sizeToFit];
    CGRect likeFrame = self.likeLabel.frame;
    likeFrame.size.height += 4;
    likeFrame.size.width += 8;
    likeFrame.origin.x = kUserBorderSize;
    likeFrame.origin.y = photoFrame.size.height - likeFrame.size.height - kUserBorderSize;
    
    self.likeLabel.frame = likeFrame;
    self.userNameLabel.frame = nameFrame;
    self.photoImageView.frame = photoFrame;
    self.userImageView.frame = userPhotoFrame;
    self.userView.frame = userBorderFrame;
    self.userGradientView.frame = gradientFrame;
}

#pragma mark - Properties

- (void)setInstagramPhoto:(NLInstagramPhoto *)instagramPhoto {
    self.photoImageView.image = instagramPhoto.image;
    self.userImageView.image = instagramPhoto.userImage;
    self.userNameLabel.text = instagramPhoto.username;
    self.userGradientView.image = [NLInstagramPhotoCell gradientImage];
    self.likeLabel.text = [NSString stringWithFormat:@"+%i",instagramPhoto.likes];
}

- (void)setPhotoFocused:(BOOL)photoFocused {
    [self setPhotoFocused:photoFocused animated:NO];
}

- (void)setPhotoFocused:(BOOL)photoFocused animated:(BOOL)animated {
    _photoFocused = photoFocused;
    
    self.userView.transform = photoFocused ? CGAffineTransformMakeScale(0, 0) : CGAffineTransformMakeScale(1, 1);
    self.likeLabel.transform = self.userView.transform;
    
    if (animated) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = photoFocused ? @[@1.0, @1.1, @0.0] : @[@0.0, @1.1, @1.0];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.duration = 0.2;
        [self.userView.layer addAnimation:animation forKey:@"shrinkExpand"];
        [self.likeLabel.layer addAnimation:animation forKey:@"shrinkExpand"];
    }
}

#pragma mark - Static methods

+ (UIImage*)gradientImage {
    if (!kGradientImage) {
        CGFloat size = (kUserSize.width + kUserBorderSize * 2.0) * [[UIScreen mainScreen] scale];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, size, 1, 8, 0, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
        
        CGFloat white;
        [kUserBorderColor getWhite:&white alpha:NULL];
        CGColorRef endColor = [[UIColor colorWithWhite:white alpha:0] CGColor];
        
        NSArray *colors = @[(id)kUserBorderColor.CGColor, (id)endColor];
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, NULL);
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(size, 0), 0);
        
        CGImageRef cgImage = CGBitmapContextCreateImage(context);
        kGradientImage = [UIImage imageWithCGImage:cgImage];
        
        CGGradientRelease(gradient);
        CGImageRelease(cgImage);
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
    }
    
    return kGradientImage;
}

@end
