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
@property (nonatomic, assign) CGRect containerInitialRect;
@property (nonatomic, assign) CGRect searchBarInitialRect;

@property (nonatomic, strong) NHSearchBar *searchBar;

@property (nonatomic, strong) NHSearchResultView *searchResultView;

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
    
    self.searchResultView = [[NHSearchResultView alloc] init];
    self.searchResultView.backgroundColor = [UIColor grayColor];
    
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
    if (!self.searchEnabled) {
        return;
    }
    
    self.searchResultView.alpha = ([text length] ? 1 : 0.5);
    self.searchResultView.tableView.hidden = ![text length];
    
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
    
    self.searchResultView.frame = tableViewRect;
    [self.container.view addSubview:self.searchResultView];
    self.searchResultView.tableView.hidden = ![self.searchBar.textField.text length];
    self.searchResultView.alpha = 0;
    
    [self.searchResultView setNeedsLayout];
    [self.searchResultView layoutIfNeeded];
    
    [self.searchBar setCloseButtonHidden:NO];
    [self.searchBar.superview bringSubviewToFront:self.searchBar];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationOptionBeginFromCurrentState
                                 |UIViewAnimationCurveEaseIn)
                     animations:^{
                         self.searchBar.frame = newSearchBarFrame;
                         self.searchBar.textField.textInset = kNHSearchTextFieldInsets;
                         self.container.view.frame = newContainerFrame;
                         self.searchResultView.alpha = ([self.searchBar.textField.text length] ? 1 : 0.5);
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
    [self.searchBar setCloseButtonHidden:YES];
    [self.searchBar endEditing:YES];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationOptionBeginFromCurrentState
                                 |UIViewAnimationCurveEaseIn)
                     animations:^{
                         self.searchBar.frame = self.searchBarInitialRect;
                         self.container.view.frame = self.containerInitialRect;
                         [self.searchBar layoutIfNeeded];
                         self.searchResultView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self.searchResultView removeFromSuperview];
                         
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
    
    [self.searchResultView removeFromSuperview];
    
    [self.searchBar.textField removeObserver:self
                                  forKeyPath:@"text"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.textChange];
}

@end
