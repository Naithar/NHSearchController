//
//  NHSearchTextField.h
//  Pods
//
//  Created by Sergey Minakov on 13.08.15.
//
//


@import UIKit;

extern const CGFloat kNHSearchTextFieldMinLeftInset;
extern const UIEdgeInsets kNHSearchTextFieldInsets;
extern const CGFloat kNHSearchButtonWidth;

@class NHSearchTextField;

@protocol NHSearchTextFieldDelegate <NSObject>

@optional
- (void)nhSearchTextField:(NHSearchTextField*)textField didChangeText:(NSString*)text;

@end
@interface NHSearchTextField : UITextField

@property (nonatomic, weak) id<NHSearchTextFieldDelegate> nhDelegate;
@property (nonatomic, assign) UIEdgeInsets textInset;

- (void)resetTextInsets:(BOOL)force;

@end