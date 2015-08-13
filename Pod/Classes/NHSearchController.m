//
//  NHSearchViewController.m
//  Pods
//
//  Created by Sergey Minakov on 12.08.15.
//
//

#import "NHSearchController.h"

const CGFloat kNHSearchTextFieldMinLeftInset = 25;
const UIEdgeInsets kNHSearchTextFieldInsets = (UIEdgeInsets) { .left = 25, .right = 20 };
const CGFloat kNHSearchButtonWidth = 95;

#define SYSTEM_VERSION_LESS_THAN(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define image(name) \
[UIImage imageWithContentsOfFile: \
[[NSBundle bundleForClass:[NHSearchController class]]\
pathForResource:name ofType:@"png"]]

#define localization(name, table) \
NSLocalizedStringFromTableInBundle(name, \
table, \
[NSBundle bundleForClass:[NHSearchController class]], nil)

@implementation NHSearchTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, self.textInset);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, self.textInset);
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect rect = [super leftViewRectForBounds:bounds];
    rect.origin.x = self.textInset.left - rect.size.width - 5;
    
    return rect;
}
@end


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


- (void)dealloc {
#ifdef DEBUG
    NSLog(@"dealloc search bar");
#endif
}

@end

@interface NHSearchController ()<UITextFieldDelegate>

@property (nonatomic, weak) UIViewController *container;
@property (nonatomic, assign) CGRect containerInitialRect;
@property (nonatomic, assign) CGRect searchBarInitialRect;

@property (nonatomic, strong) NHSearchBar *searchBar;

@property (nonatomic, strong) UIView *searchResultContainer;
@property (nonatomic, strong) UITableView *searchTableView;

@property (nonatomic, assign) BOOL searchEnabled;

@property (nonatomic, strong) id textChange;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation NHSearchController

- (instancetype)initWithContainerViewController:(UIViewController*)container {
    self = [super init];
    
    if (self) {
        _container = container;
        _shouldOffsetStatusBar = YES;
        [self nhCommonInit];
    }
    return self;
}


- (void)nhCommonInit {
    self.containerInitialRect = self.container.view.frame;
    
    self.searchBar = [[NHSearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 43)];
    self.searchBar.backgroundColor = [UIColor lightGrayColor];
    self.searchBar.textField.delegate = self;
    [self.searchBar.button addTarget:self action:@selector(closeButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.searchBar.textField addObserver:self
                               forKeyPath:@"text"
                                  options:NSKeyValueObservingOptionNew
                                  context:nil];
    
    __weak __typeof(self) weakSelf = self;
    self.textChange = [[NSNotificationCenter defaultCenter]
                       addObserverForName:UITextFieldTextDidChangeNotification
                       object:self.searchBar.textField
                       queue:nil usingBlock:^(NSNotification *note) {
                           __strong __typeof(weakSelf) strongSelf = weakSelf;
                           [strongSelf changeText:strongSelf.searchBar.textField.text];
                       }];
    
    self.searchResultContainer = [UIView new];
    self.searchResultContainer.backgroundColor = [UIColor grayColor];
    
    self.searchTableView = [[UITableView alloc] init];
    self.searchTableView.backgroundColor = [UIColor whiteColor];
    self.searchTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.searchResultContainer addSubview:self.searchTableView];
    
    
    [self.searchResultContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.searchTableView
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.searchResultContainer
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1.0 constant:0]];
    [self.searchResultContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.searchTableView
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.searchResultContainer
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1.0 constant:0]];
    
    [self.searchResultContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.searchTableView
                                                                           attribute:NSLayoutAttributeRight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.searchResultContainer
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1.0 constant:0]];
    
    [self.searchResultContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.searchTableView
                                                                           attribute:NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.searchResultContainer
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0 constant:0]];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self.searchResultContainer addGestureRecognizer:self.tapGesture];
    
    [self.searchBar setNeedsLayout];
    [self.searchBar layoutIfNeeded];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self startSearch];
}

- (void)closeButtonTouch:(UIButton*)button {
    [self stopSearch];
}

- (void)tapGestureAction:(UITapGestureRecognizer*)recognizer {
    if ([self.searchBar.textField.text length]) {
        return;
    }
    
    [self stopSearch];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.searchBar.textField
        && [keyPath isEqualToString:@"text"]) {
        NSString *newText = change[NSKeyValueChangeNewKey];
        [self changeText:newText];
    }
}

- (void)changeText:(NSString*)text {
    if (!self.searchEnabled) {
        return;
    }
    
    self.searchResultContainer.alpha = ([text length] ? 1 : 0.5);
    self.searchTableView.hidden = ![text length];
    
    if ([self.nhDelegate respondsToSelector:@selector(nhSearchController:didChangeText:)]) {
        [self.nhDelegate nhSearchController:self didChangeText:text];
    }
}

- (void)startSearch {
    
    if (self.searchEnabled) {
        return;
    }
    
    self.searchEnabled = YES;
    
    CGRect newContainerFrame = self.container.view.frame;
    CGRect newSearchBarFrame = self.searchBar.frame;
    self.searchBarInitialRect = self.searchBar.frame;
    
    if (self.shouldOffsetStatusBar) {
        CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        newSearchBarFrame.size.height += statusBarHeight;
        
        if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
            newSearchBarFrame.origin.y += statusBarHeight;
        }
    }
    
    CGFloat offset = [self.searchBar
                      convertRect:(CGRect) { .size = newSearchBarFrame.size }
                      toView:self.container.view].origin.y;
    
    newContainerFrame.origin.y -= offset;
    newContainerFrame.size.height += offset;
    
    CGRect tableViewRect = (CGRect) { .size = self.containerInitialRect.size };
    tableViewRect.origin.y = offset + newSearchBarFrame.size.height;
    tableViewRect.size.height -= newSearchBarFrame.size.height;
    
    self.searchResultContainer.frame = tableViewRect;
    [self.container.view addSubview:self.searchResultContainer];
    self.searchTableView.hidden = ![self.searchBar.textField.text length];
    self.searchResultContainer.alpha = 0;
    
    [self.searchResultContainer setNeedsLayout];
    [self.searchResultContainer layoutIfNeeded];
    
    self.searchBar.buttonWidthConstraint.constant = kNHSearchButtonWidth;
    self.searchBar.button.hidden = NO;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationOptionBeginFromCurrentState
                                 |UIViewAnimationCurveEaseIn)
                     animations:^{
                         self.searchBar.frame = newSearchBarFrame;
                         self.searchBar.textField.textInset = kNHSearchTextFieldInsets;
                         self.container.view.frame = newContainerFrame;
                         self.searchResultContainer.alpha = ([self.searchBar.textField.text length] ? 1 : 0.5);
                         [self.searchBar layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         
                     }];
    
    if ([self.nhDelegate respondsToSelector:@selector(nhSearchControllerDidBegin:)]) {
        [self.nhDelegate nhSearchControllerDidBegin:self];
    }
}

- (void)stopSearch {
    if (!self.searchEnabled) {
        return;
    }
    
    self.searchEnabled = NO;
    self.searchBar.textField.text = nil;
    self.searchBar.buttonWidthConstraint.constant = 0;
    [self.searchBar endEditing:YES];
    self.searchBar.button.hidden = YES;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationOptionBeginFromCurrentState
                                 |UIViewAnimationCurveEaseIn)
                     animations:^{
                         self.searchBar.frame = self.searchBarInitialRect;
                         self.container.view.frame = self.containerInitialRect;
                         [self.searchBar layoutIfNeeded];
                         self.searchResultContainer.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self.searchResultContainer removeFromSuperview];
                         
                     }];
    
    if ([self.nhDelegate respondsToSelector:@selector(nhSearchControllerDidEnd:)]) {
        [self.nhDelegate nhSearchControllerDidEnd:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"dealloc search");
#endif
    
    [self.searchResultContainer removeFromSuperview];
    
    [self.searchBar.textField removeObserver:self
                                  forKeyPath:@"text"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.textChange];
}

@end
