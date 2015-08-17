//
//  NHSearchTextField.m
//  Pods
//
//  Created by Sergey Minakov on 13.08.15.
//
//

#import "NHSearchTextField.h"

const CGFloat kNHSearchTextFieldMinLeftInset = 25;
const UIEdgeInsets kNHSearchTextFieldInsets = (UIEdgeInsets) { .left = 25, .right = 20 };
const CGFloat kNHSearchButtonWidth = 95;

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

- (void)resetTextInsets:(BOOL)force {
    if (UIEdgeInsetsEqualToEdgeInsets(self.textInset, kNHSearchTextFieldInsets)
        && !force) {
        return;
    }
    
    CGSize size = [self.placeholder
                   boundingRectWithSize:self.bounds.size
                   options:NSStringDrawingUsesDeviceMetrics|NSStringDrawingUsesFontLeading
                   attributes:@{ NSFontAttributeName : self.font ?: [UIFont systemFontOfSize:17]}
                   context:nil].size;
    
    CGFloat value = (self.bounds.size.width - size.width) / 2;
    
    self.textInset = UIEdgeInsetsMake(0, MAX(kNHSearchTextFieldMinLeftInset, value), 0, 20);
    [self setNeedsLayout];
}

@end