//
//  UIImage+ImageExtension.h
//  BagStore
//
//  Created by imqiuhang on 2017/6/27.
//  Copyright © 2017年 Framework. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UIImage (ImageExtension)

///将图片压缩成指定尺寸的图片 size为指定尺寸 @return 压缩后的图片
- (UIImage*)scaleImageWithSize:(CGSize)size;
///颜色转图片 Size(1,1)
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
///圆角图片
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius;
///描边圆角图片
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                                   borderWidth:(CGFloat)borderWidth
                                   borderColor:(UIColor *)borderColor;
///自定义描边圆角图片
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                                       corners:(UIRectCorner)corners
                                   borderWidth:(CGFloat)borderWidth
                                   borderColor:(UIColor *)borderColor
                                borderLineJoin:(CGLineJoin)borderLineJoin;


- (BOOL)writeToFileAtPath:(NSString*)path;///存储照片到文件中
- (UIImage *)originalImage;
- (UIImage *)templateImage;

///buffer
+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;
+ (UIImage *)getImageStream:(CVImageBufferRef)imageBuffer;
+ (UIImage *)getSubImage:(CGRect)rect inImage:(UIImage*)image;

- (UIImage *)compressQualityWithMaxLength:(NSInteger)maxLength;

@end
