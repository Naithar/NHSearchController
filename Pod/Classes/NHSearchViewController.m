//
//  NHSearchViewController.m
//  Pods
//
//  Created by Sergey Minakov on 12.08.15.
//
//

#import "NHSearchViewController.h"

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

@interface NHSearchViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) UIViewController *container;
@property (nonatomic, assign) CGRect containerInitialRect;
@property (nonatomic, assign) CGRect searchBarInitialRect;

@property (nonatomic, strong) UIView *searchBar;
@property (nonatomic, strong) NHSearchTextField *searchTextField;

@property (nonatomic, strong) UITableView *searchTableView;

@property (nonatomic, assign) BOOL searchEnabled;

@property (nonatomic, strong) id textChange;

@end

@implementation NHSearchViewController

- (instancetype)initWithContainerViewController:(UIViewController*)container {
    self = [super init];
    
    if (self) {
        _container = container;
        [self nhCommonInit];
    }
    return self;
}

- (void)nhCommonInit {
    self.containerInitialRect = self.container.view.frame;
    
    self.searchBar = [[UIView alloc] init];
    self.searchBar.backgroundColor = [UIColor redColor];
    
    self.searchTextField = [[NHSearchTextField alloc] init];
    self.searchTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchTextField.layer.cornerRadius = 15;
    self.searchTextField.clipsToBounds = YES;
    self.searchTextField.textInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.searchTextField.delegate = self;
    [self.searchBar addSubview:self.searchTextField];
    
    [self.searchBar addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.searchTextField
                                   attribute:NSLayoutAttributeLeft
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.searchBar
                                   attribute:NSLayoutAttributeLeft
                                   multiplier:1.0 constant:7.5]];
    [self.searchBar addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.searchTextField
                                   attribute:NSLayoutAttributeRight
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.searchBar
                                   attribute:NSLayoutAttributeRight
                                   multiplier:1.0 constant:-7.5]];
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
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self startSearch];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
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
    
}

- (void)startSearch {
    CGRect newContainerFrame = self.container.view.frame;
    CGRect newSearchBarFrame = self.searchBar.frame;
    self.searchBarInitialRect = self.searchBar.frame;
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    newSearchBarFrame.size.height += statusBarHeight;
    
    CGFloat offset = [self.searchBar
                      convertRect:(CGRect) { .size = newSearchBarFrame.size }
                      toView:self.container.view].origin.y;
    
    newContainerFrame.origin.y -= offset;
    newContainerFrame.size.height += offset;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationCurveEaseIn
                     animations:^{
                         self.searchBar.frame = newSearchBarFrame;
                         self.container.view.frame = newContainerFrame;
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

- (void)stopSearch {
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationCurveEaseIn
                     animations:^{
                         self.searchBar.frame = self.searchBarInitialRect;
                         self.container.view.frame = self.containerInitialRect;
                     } completion:^(BOOL finished) {
                         
                     }];
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
//    return YES;
//}

- (void)dealloc {
    NSLog(@"dealloc search");
    
    [self.searchTextField removeObserver:self
                              forKeyPath:@"text"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.textChange];
}

@end
