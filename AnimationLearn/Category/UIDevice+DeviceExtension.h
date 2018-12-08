//
//  UIDevice+DeviceExtension.h
//  imqiuhang
//
//  Created by imqiuhang on 14/12/15.
//  Copyright (c) 2014年 imqiuhang. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIDevice (DeviceExtension)

#pragma mark - Device Information
+ (double)systemVersionNumber;/// Device system version (8.1)
@property (nonatomic, readonly) BOOL isPad;
@property (nonatomic, readonly) BOOL isSimulator;///是否是模拟器
@property (nonatomic, readonly) BOOL isJailbroken;///是否越狱
@property (nonatomic, readonly) BOOL canMakePhoneCalls NS_EXTENSION_UNAVAILABLE_IOS("");
@property (nonatomic, readonly) NSString *machineModel;///机型 "iPhone6,1" "iPad4,6"
@property (nonatomic, readonly) NSString *machineModelName;///机型名称"iPhone 5s" "iPad mini 2"
@property (nonatomic, readonly) NSDate *systemUptime;///系统开机时间

#pragma mark - Network Information
@property (nonatomic, readonly) NSString *ipAddressWIFI;///WIFI IP地址 maybe nil @"192.168.1.111"
@property (nonatomic, readonly) NSString *ipAddressCell;///IP地址 @"10.2.2.222" maybe nil

#pragma mark - Disk Space
@property (nonatomic, readonly) int64_t diskSpace;///磁盘空间 bytes
@property (nonatomic, readonly) int64_t diskSpaceFree;///磁盘剩余空间 bytes
@property (nonatomic, readonly) int64_t diskSpaceUsed;///磁盘已使用空间 bytes

#pragma mark - Memory Information
@property (nonatomic, readonly) int64_t memoryTotal;///内存空间 bytes (无法获取返回-1，下同)
@property (nonatomic, readonly) int64_t memoryUsed;///已使用内存(active + inactive + wired)
@property (nonatomic, readonly) int64_t memoryFree;///闲置内存 bytes
@property (nonatomic, readonly) int64_t memoryActive;///活跃内存 bytes
@property (nonatomic, readonly) int64_t memoryInactive;///不活跃内存 bytes
@property (nonatomic, readonly) int64_t memoryWired;///核心内存 bytes
@property (nonatomic, readonly) int64_t memoryPurgable;///便携式存储器空间 bytes

#pragma mark - CPU Information
@property (nonatomic, readonly) NSUInteger cpuCount;///可用的CPU进程数
@property (nonatomic, readonly) float cpuUsage;///已使用的CPU进程 -1 if error
@property (nonatomic, readonly) NSArray<NSNumber *> *cpuUsagePerProcessor;///nil if error

@end
