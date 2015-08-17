//
//  NHSearchViewController.m
//  Pods
//
//  Created by Sergey Minakov on 12.08.15.
//
//

#import "NHSearchController.h"


#define SYSTEM_VERSION_LESS_THAN(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)



@interface NHSearchController ()<UITextFieldDelegate>

@property (nonatomic, weak) UIViewController *container;
@property (nonatomic, weak) UIView *searchBackgroundView;

@property (nonatomic, assign) CGRect searchBarInitialRect;
@property (nonatomic, assign) CGRect searchBarContainerInitialRect;

@property (nonatomic, strong) NHSearchBar *searchBar;

@property (nonatomic, strong) NHSearchResultView *searchResultView;

@property (nonatomic, assign) BOOL searchEnabled;

@property (nonatomic, strong) id textChange;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, weak) UIView *initialSearchBarSuperview;

@property (nonatomic, assign) BOOL bottonSeparatorState;
@property (nonatomic, copy) NSString *searchText;
@end

@implementation NHSearchController

- (instancetype)initWithContainerViewController:(UIViewController*)container {
    return [self initWithContainerViewController:container andBackgroundView:nil];
}

- (instancetype)initWithContainerViewController:(UIViewController*)container
                              andBackgroundView:(UIView*)view {
    self = [super init];
    
    if (self) {
        _container = container;
        _searchBackgroundView = view;
        _shouldOffsetStatusBar = YES;
        [self nhCommonInit];
    }
    return self;
}


- (void)nhCommonInit {
    self.searchBar = [[NHSearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
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
    
    self.searchResultView = [[NHSearchResultView alloc] initWithBackgroundView:self.searchBackgroundView];
    self.searchResultView.backgroundColor = self.searchBackgroundView ? [UIColor whiteColor] : [UIColor clearColor];
    self.searchResultView.overlayColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self.searchResultView addGestureRecognizer:self.tapGesture];
    
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
    if (!self.searchEnabled
        || [self.searchText isEqualToString:text]) {
        return;
    }
    
    self.searchResultView.tableView.hidden = ![text length];
    
    if ([self.nhDelegate respondsToSelector:@selector(nhSearchController:didChangeText:)]) {
        [self.nhDelegate nhSearchController:self didChangeText:text];
    }
    
    self.searchText = text;
}

- (void)startSearch {
    
    if (self.searchEnabled) {
        return;
    }
    
    self.searchEnabled = YES;
    
    [self showSearch];
    
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
    [self.searchBar setCloseButtonHidden:YES];
    
    
    [self hideSearch];
    
    if ([self.nhDelegate respondsToSelector:@selector(nhSearchControllerDidEnd:)]) {
        [self.nhDelegate nhSearchControllerDidEnd:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if ([self.nhDelegate respondsToSelector:@selector(nhSearchController:didChangeText:)]) {
        [self.nhDelegate nhSearchController:self didChangeText:self.searchText];
    }
    
    return YES;
}

- (void)hideSearch {
    if (CGRectEqualToRect(CGRectZero, self.searchBarInitialRect)) {
        return;
    }
    
    [self.searchBar.textField resignFirstResponder];
    
    CGRect resultFrame = self.searchResultView.frame;
    
    resultFrame.origin.y = CGRectGetMaxY(self.searchBarContainerInitialRect);
    
    self.searchBar.bottomSeparator.hidden = self.bottonSeparatorState;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationOptionBeginFromCurrentState
                                 |UIViewAnimationCurveEaseIn)
                     animations:^{
                         self.searchBar.frame = self.searchBarContainerInitialRect;
                         [self.searchBar resetTextInsets:YES];
                         self.searchResultView.frame = resultFrame;
                         [self.searchBar layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         [self.searchResultView removeFromSuperview];
                         self.searchBar.frame = self.searchBarInitialRect;
                         [self.initialSearchBarSuperview addSubview:self.searchBar];
                     }];
}
- (void)showSearch {
    
    if (!self.searchEnabled) {
        return;
    }
    
    self.searchBarInitialRect = self.searchBar.frame;
    self.initialSearchBarSuperview = self.searchBar.superview;
    
    self.searchBarContainerInitialRect = [self.searchBar convertRect:self.searchBar.bounds toView:self.container.view];
    CGRect newSearchBarFrame = self.searchBarContainerInitialRect;
    CGRect newContainerFrame = self.container.view.frame;
    
    CGRect backgroundViewOffsetRect = [self.searchBar convertRect:self.searchBar.bounds toView:self.searchBackgroundView];
    [self.searchResultView prepareWithOffsetPoint:CGPointMake(0, CGRectGetMaxY(backgroundViewOffsetRect))];
    
    self.searchBar.frame = newSearchBarFrame;
    [self.container.view addSubview:self.searchBar];
    [self.container.view addSubview:self.searchResultView];
    [self.container.view bringSubviewToFront:self.searchBar];
    
    newContainerFrame.origin.y = CGRectGetMaxY(newSearchBarFrame);
    
    if (self.shouldOffsetStatusBar) {
        CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        newSearchBarFrame.size.height += statusBarHeight;
    }
    
    newContainerFrame.size.height -= newSearchBarFrame.size.height;
    self.searchResultView.tableView.hidden = ![self.searchBar.textField.text length];
    self.searchResultView.frame = newContainerFrame;
    [self.searchResultView setNeedsLayout];
    [self.searchResultView layoutIfNeeded];
    
    [self.searchBar setCloseButtonHidden:NO];
    [self.searchBar.superview bringSubviewToFront:self.searchBar];
    
    newSearchBarFrame.origin.y = 0;
    newContainerFrame.origin.y = CGRectGetMaxY(newSearchBarFrame);
    
    self.bottonSeparatorState = self.searchBar.bottomSeparator.hidden;
    self.searchBar.bottomSeparator.hidden = NO;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationOptionBeginFromCurrentState
                                 |UIViewAnimationCurveEaseIn)
                     animations:^{
                         self.searchBar.textField.textInset = kNHSearchTextFieldInsets;
                         [self.searchBar layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.searchBar.frame = newSearchBarFrame;
        self.searchBar.textField.textInset = kNHSearchTextFieldInsets;
        self.searchResultView.frame = newContainerFrame;
        [self.searchResultView layoutIfNeeded];
    }];
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"dealloc search");
#endif
    
    [self.searchBar removeFromSuperview];
    [self.searchResultView removeFromSuperview];
    
    [self.searchBar.textField removeObserver:self
                                  forKeyPath:@"text"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.textChange];
}

@end