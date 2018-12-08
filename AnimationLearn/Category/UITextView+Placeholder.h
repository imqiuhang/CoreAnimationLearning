//
//  QHCategorys
//
//  Created by imqiuhang on 15/2/10.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.


@interface UITextView (Placeholder)

@property (nonatomic, readonly) UILabel *placeholderLabel;

@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong) NSAttributedString     *attributedPlaceholder;
@property (nonatomic, strong) IBInspectable UIColor  *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;

@end
