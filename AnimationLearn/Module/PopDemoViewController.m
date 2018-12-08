//
//  PopDemoViewController.m
//  AnimationLearn
//
//  Created by imqiuhang on 2018/11/18.
//  Copyright © 2018 imqiuhang. All rights reserved.
//

#import "PopDemoViewController.h"
#import "PDMasterViewController.h"

@interface PopDemoViewController ()

@end

@implementation PopDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PDMasterViewController"] animated:YES];
}


@end
