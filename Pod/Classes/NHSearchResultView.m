//
//  NHSearchResultView.m
//  Pods
//
//  Created by Sergey Minakov on 13.08.15.
//
//

#import "NHSearchResultView.h"

@interface NHSearchResultView ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation NHSearchResultView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self nhCommonInit];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    
//    CGContextRef imageContext = UIGraphicsGetCurrentContext();
//    CGContextClipToMask(imageContext, self.bounds, maskImage);
    [self.image drawInRect:CGRectMake(rect.origin.x, rect.origin.y, self.image.size.width, self.image.size.height)];
    
//    CGImageRelease(maskImage);
    
    [[(self.overlayColor ?: [UIColor blackColor]) colorWithAlphaComponent:0.5] set];
    
    [[UIBezierPath bezierPathWithRect:rect] fill];
}

- (CGImageRef)gradientImage {
    static UIImage *gradientImage;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, 0);
        CGContextRef maskContext = UIGraphicsGetCurrentContext();
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        int componentCount = 2;
        CGFloat components[8] = {
            1.0, 1.0, 1.0, 1.0,
            .0, .0, .0, .0,
        };
        CGFloat locations[2] = { 0.0, 0.8 };
        
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, componentCount);
        CGPoint startPoint = CGPointMake(0, 100);
        CGPoint endPoint = CGPointMake(0, 0);
        CGContextDrawLinearGradient(maskContext, gradient, startPoint, endPoint, 0);
        
        gradientImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
    });
    
    return gradientImage.CGImage;
}
- (void)getSnapshotForView:(UIView*)view withRect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextConcatCTM(context,
                       CGAffineTransformMakeTranslation(
                                                        -rect.origin.x,
                                                        -rect.origin.y));
    
    

    CGContextClipToMask(context, rect, [self gradientImage]);
    [view.layer renderInContext:context];
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)nhCommonInit {
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.tableView];
    
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self.tableView
                         attribute:NSLayoutAttributeTop
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeTop
                         multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self.tableView
                         attribute:NSLayoutAttributeLeft
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeLeft
                         multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self.tableView
                         attribute:NSLayoutAttributeRight
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeRight
                         multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self.tableView
                         attribute:NSLayoutAttributeBottom
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeBottom
                         multiplier:1.0 constant:0]];
    
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"dealloc search result view");
#endif
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

@end