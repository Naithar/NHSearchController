//
//  NHSearchViewController.m
//  Pods
//
//  Created by Sergey Minakov on 12.08.15.
//
//

#import "NHSearchController.h"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface NHSearchTextField ()

@end

@implementation NHSearchTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, self.textInset);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, self.textInset);
}

@end

@interface NHSearchController ()<UITextFieldDelegate>

@property (nonatomic, weak) UIViewController *container;
@property (nonatomic, assign) CGRect containerInitialRect;
@property (nonatomic, assign) CGRect searchBarInitialRect;

@property (nonatomic, strong) NSLayoutConstraint *closeButtonWidth;

@property (nonatomic, strong) UIView *searchBar;
@property (nonatomic, strong) NHSearchTextField *searchTextField;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIView *searchResultContainer;
@property (nonatomic, strong) UITableView *searchTableView;

@property (nonatomic, assign) BOOL searchEnabled;

@property (nonatomic, strong) id textChange;

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
    
    self.searchBar = [[UIView alloc] init];
    self.searchBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.searchTextField = [[NHSearchTextField alloc] init];
    self.searchTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchTextField.layer.cornerRadius = 15;
    self.searchTextField.clipsToBounds = YES;
    self.searchTextField.textInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.searchTextField.delegate = self;
    self.searchTextField.placeholder = @"NHSearch.placeholder";
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.textAlignment = NSTextAlignmentCenter;
    [self.searchBar addSubview:self.searchTextField];
    
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.closeButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.closeButton setTitle:@"NHSearch.close" forState:UIControlStateNormal];
    self.closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.closeButton addTarget:self action:@selector(closeButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton.hidden = YES;
    self.closeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.searchBar addSubview:self.closeButton];
    
    
    [self.searchBar addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.searchTextField
                                   attribute:NSLayoutAttributeLeft
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.searchBar
                                   attribute:NSLayoutAttributeLeft
                                   multiplier:1.0 constant:7.5]];
    [self.searchBar addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.searchTextField
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.searchBar
                                   attribute:NSLayoutAttributeBottom
                                   multiplier:1.0 constant:-7.5]];
    [self.searchTextField addConstraint:[NSLayoutConstraint constraintWithItem:self.searchTextField
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.searchTextField
                                                                     attribute:NSLayoutAttributeHeight
                                                                    multiplier:0 constant:30]];
    
    [self.searchBar addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.searchTextField
                                   attribute:NSLayoutAttributeRight
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.closeButton
                                   attribute:NSLayoutAttributeLeft
                                   multiplier:1.0 constant:0]];
    [self.searchBar addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.closeButton
                                   attribute:NSLayoutAttributeRight
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.searchBar
                                   attribute:NSLayoutAttributeRight
                                   multiplier:1.0 constant:-7.5]];
    [self.searchBar addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.closeButton
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.searchBar
                                   attribute:NSLayoutAttributeBottom
                                   multiplier:1.0 constant:-7.5]];
    
    self.closeButtonWidth = [NSLayoutConstraint constraintWithItem:self.closeButton
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.closeButton
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:0 constant:0];
    
    [self.closeButton addConstraint:self.closeButtonWidth];
    [self.closeButton addConstraint:[NSLayoutConstraint constraintWithItem:self.closeButton
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.closeButton
                                                                     attribute:NSLayoutAttributeHeight
                                                                    multiplier:0 constant:30]];
    

    
    self.searchBar.frame = CGRectMake(0, 0, 320, 44);
    
    [self.searchTextField addObserver:self
                           forKeyPath:@"text"
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    
    __weak __typeof(self) weakSelf = self;
    self.textChange = [[NSNotificationCenter defaultCenter]
                       addObserverForName:UITextFieldTextDidChangeNotification
                       object:self.searchTextField
                       queue:nil usingBlock:^(NSNotification *note) {
                           __strong __typeof(weakSelf) strongSelf = weakSelf;
                           [strongSelf changeText:strongSelf.searchTextField.text];
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
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self startSearch];
}

- (void)closeButtonTouch:(UIButton*)button {
    [self stopSearch];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.searchTextField
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
    self.searchTableView.hidden = ![self.searchTextField.text length];
    self.searchResultContainer.alpha = 0;
    
    [self.searchResultContainer setNeedsLayout];
    [self.searchResultContainer layoutIfNeeded];
    
    self.closeButtonWidth.constant = 80;
    self.closeButton.hidden = NO;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationOptionBeginFromCurrentState
                                 |UIViewAnimationCurveEaseIn)
                     animations:^{
                         self.searchTextField.textAlignment = NSTextAlignmentLeft;
                         self.searchBar.frame = newSearchBarFrame;
                         self.container.view.frame = newContainerFrame;
                         self.searchResultContainer.alpha = ([self.searchTextField.text length] ? 1 : 0.5);
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
    self.searchTextField.text = nil;
    self.closeButtonWidth.constant = 0;
    [self.searchBar endEditing:YES];
    self.closeButton.hidden = YES;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationOptionBeginFromCurrentState
                                 |UIViewAnimationCurveEaseIn)
                     animations:^{
                         self.searchTextField.textAlignment = NSTextAlignmentCenter;
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
    
    [self.searchTextField removeObserver:self
                              forKeyPath:@"text"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.textChange];
}

@end
