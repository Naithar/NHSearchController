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
    [self.image drawInRect:CGRectMake(rect.origin.x, rect.origin.y, self.image.size.width, self.image.size.height)];
    
    [[(self.overlayColor ?: [UIColor blackColor]) colorWithAlphaComponent:0.5] set];
    
    [[UIBezierPath bezierPathWithRect:rect] fill];
}

- (void)getSnapshotForView:(UIView*)view withRect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextConcatCTM(context,
                       CGAffineTransformMakeTranslation(
                                                        -rect.origin.x,
                                                        -rect.origin.y));
    
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