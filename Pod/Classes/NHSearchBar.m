//
//  NHSearchBar.m
//  Pods
//
//  Created by Sergey Minakov on 13.08.15.
//
//

#import "NHSearchBar.h"

#define image(name) \
[UIImage imageWithContentsOfFile: \
[[NSBundle bundleForClass:[NHSearchBar class]]\
pathForResource:name ofType:@"png"]]

#define localization(name, table) \
NSLocalizedStringFromTableInBundle(name, \
table, \
[NSBundle bundleForClass:[NHSearchBar class]], nil)


const CGFloat kNHSearchTextFieldMinLeftInset = 25;
const UIEdgeInsets kNHSearchTextFieldInsets = (UIEdgeInsets) { .left = 25, .right = 20 };
const CGFloat kNHSearchButtonWidth = 95;


@interface NHSearchBar ()

@property (nonatomic, strong) NHSearchTextField *textField;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *separator;

@property (nonatomic, strong) NSLayoutConstraint *buttonWidthConstraint;

@end

@implementation NHSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self nhCommonInit];
    }
    return self;
}

- (void)nhCommonInit {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.contentMode = UIViewContentModeRight;
    self.imageView.image = image(@"NHSearch.icon");
    
    self.textField = [[NHSearchTextField alloc] init];
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.layer.cornerRadius = 5;
    self.textField.clipsToBounds = YES;
    
    self.textField.placeholder = localization(@"NHSearch.placeholder", @"NHSearch");
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.leftView = self.imageView;
    self.textField.textInset = kNHSearchTextFieldInsets;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:self.textField];
    
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    self.button.backgroundColor = [UIColor clearColor];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button setTitle:localization(@"NHSearch.close", @"NHSearch") forState:UIControlStateNormal];
    self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.button.hidden = YES;
    self.button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self addSubview:self.button];
    
    self.separator = [UIView new];
    self.separator.backgroundColor = [UIColor blackColor];
    self.separator.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.separator];
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self.textField
                         attribute:NSLayoutAttributeLeft
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeLeft
                         multiplier:1.0 constant:7.5]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self.textField
                         attribute:NSLayoutAttributeBottom
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeBottom
                         multiplier:1.0 constant:-7.5]];
    [self.textField addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.textField
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.textField
                                   attribute:NSLayoutAttributeHeight
                                   multiplier:0 constant:28]];
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self.textField
                         attribute:NSLayoutAttributeRight
                         relatedBy:NSLayoutRelationEqual
                         toItem:self.button
                         attribute:NSLayoutAttributeLeft
                         multiplier:1.0 constant:0]];
    NSLayoutConstraint *buttonRightConstraint = [NSLayoutConstraint
                                                 constraintWithItem:self.button
                                                 attribute:NSLayoutAttributeRight
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                                 attribute:NSLayoutAttributeRight
                                                 multiplier:1.0 constant:-7.5];
    buttonRightConstraint.priority = UILayoutPriorityDefaultHigh;
    [self addConstraint:buttonRightConstraint];
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self.button
                         attribute:NSLayoutAttributeBottom
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeBottom
                         multiplier:1.0 constant:-7.5]];
    
    self.buttonWidthConstraint = [NSLayoutConstraint
                                  constraintWithItem:self.button
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.button
                                  attribute:NSLayoutAttributeWidth
                                  multiplier:0 constant:0];
    
    [self.button addConstraint:self.buttonWidthConstraint];
    [self.button addConstraint:[NSLayoutConstraint
                                constraintWithItem:self.button
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.button
                                attribute:NSLayoutAttributeHeight
                                multiplier:0 constant:28]];
    
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self.separator
                         attribute:NSLayoutAttributeBottom
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeBottom
                         multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self.separator
                         attribute:NSLayoutAttributeLeft
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeLeft
                         multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self.separator
                         attribute:NSLayoutAttributeRight
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeRight
                         multiplier:1.0 constant:0]];
    
    [self.separator addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.separator
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.separator
                                   attribute:NSLayoutAttributeHeight
                                   multiplier:0 constant:0.5]];
    
    [self resetTextInsets];
    
}

- (void)resetTextInsets {
    CGSize size = [self.textField.placeholder
                   boundingRectWithSize:self.textField.bounds.size
                   options:NSStringDrawingUsesDeviceMetrics|NSStringDrawingUsesFontLeading
                   attributes:@{ NSFontAttributeName : self.textField.font ?: [UIFont systemFontOfSize:17]}
                   context:nil].size;
    
    CGFloat value = (self.textField.bounds.size.width - size.width) / 2;
    
    self.textField.textInset = UIEdgeInsetsMake(0, MAX(kNHSearchTextFieldMinLeftInset, value), 0, 20);
    [self.textField setNeedsLayout];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [self resetTextInsets];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self resetTextInsets];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
}

- (void)setCloseButtonHidden:(BOOL)hidden {
    self.buttonWidthConstraint.constant = hidden ? 0 : kNHSearchButtonWidth;
    self.button.hidden = hidden;
}


- (void)dealloc {
#ifdef DEBUG
    NSLog(@"dealloc search bar");
#endif
    
    self.textField.delegate = nil;
}

@end