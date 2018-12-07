# CoreAnimationLearning
CoreAnimation相关学习记录
# CoreAnimationLearning
CoreAnimation相关学习记录
<!--CoreAnimation头文件包含-->

```objc
#import <QuartzCore/CAAnimation.h>✅
#import <QuartzCore/CADisplayLink.h>✅
#import <QuartzCore/CAEAGLLayer.h>
#import <QuartzCore/CAEmitterCell.h>✅
#import <QuartzCore/CAEmitterLayer.h>
#import <QuartzCore/CAGradientLayer.h>
#import <QuartzCore/CALayer.h>✅//CAAction✅
#import <QuartzCore/CAMediaTiming.h>✅
#import <QuartzCore/CAMediaTimingFunction.h>✅
#import <QuartzCore/CAReplicatorLayer.h>
#import <QuartzCore/CAScrollLayer.h>
#import <QuartzCore/CAShapeLayer.h>
#import <QuartzCore/CATextLayer.h>
#import <QuartzCore/CATiledLayer.h>
#import <QuartzCore/CATransaction.h>✅‼️
#import <QuartzCore/CATransform3D.h>
#import <QuartzCore/CATransformLayer.h>
#import <QuartzCore/CAValueFunction.h>
```

 <!--例子1代码-->
 
```objc
@interface LayerAndViewViewController ()

@property (nonatomic,strong)UIView  *view1;//view
@property (nonatomic,strong)CALayer *layer1;//layer

@end

@implementation LayerAndViewViewController

- (void)viewDidLoad {
     /*左边放一个layer1，右边放一个view1，点击按钮同时改变两个的backgroundColor*/
    //左边放一个layer
    self.layer1 = [CALayer layer];
    [self.view.layer addSublayer:self.layer1]
    //右边放一个View
    self.view1 = [[UIView alloc] init];
    [self.view addSubview:view1];
}

- (void)rightBarButtonDidSelected {
    /*点击按钮同时赋值同一个颜色*/
    UIColor *color = self.randomColor;
    self.view1.layer.backgroundColor = color.CGColor;
    self.layer1.backgroundColor = color.CGColor;
}

@end

```

 <!--例子2代码-->
  
```objc

@interface ExplicitTransactionViewController ()

@property (nonatomic,strong)CALayer  *layer2;
@property (nonatomic,strong)CALayer *layer1;
@property (nonatomic,strong)UISwitch *switch1;

@end

@implementation ExplicitTransactionViewController

- (void)viewDidLoad {

    /*左边放layer1右边放layer2，开关控制右边layer2是否开启动作，点击按钮同时改变backgroundColor*/
    
    /*左右各放一个layer*/
    self.layer1 = [CALayer layer];
    self.layer2 = [CALayer layer];
    [self.view.layer addSublayer:self.layer1]
    [self.view.layer addSublayer:self.layer2]
    
    /*加一个开关，开关控制右边layer是否允许action*/
    self.switch1 = [UISwitch new];
    [self.view addSubview:switch1];
}

- (void)rightBarButtonDidSelected {

    UIColor *color = self.randomColor;
    self.layer1.backgroundColor = color.CGColor;

    [CATransaction begin];
    /*默认是NO， 设置YES来禁用action*/
    [CATransaction setDisableActions:!self.switch1.on];
    [CATransaction setAnimationDuration:0.25];/*默认的是0.25秒*/
    self.layer2.backgroundColor = color.CGColor;
    [CATransaction commit];
}
```

 <!--例子3代码-->
  
```objc

@interface LayerAndViewLayerViewController ()

@property (nonatomic,strong)UIView  *view1;//view
@property (nonatomic,strong)CALayer *layer1;//layer

@end

@implementation LayerAndViewLayerViewController

- (void)viewDidLoad {

    /*左边放一个layer1，右边放一个view1里面的的layer，改变backgroundColor属性的值*/
    
    /* 左边放一个layer1*/
    self.layer1 = [CALayer layer];
    [self.view.layer addSublayer:self.layer1];
    
    /* 右边放一个View1的layer*/
    self.view1 = [[UIView alloc] init];
    [self.view.layer addSublayer:self.view1.layer];
}

- (void)rightBarButtonDidSelected {
    /*点击按钮同时赋值同一个颜色*/
    UIColor *color = self.randomColor;
    self.view1.layer.backgroundColor = color.CGColor;
    self.layer1.backgroundColor = color.CGColor;
}
```

 <!--例子4代码-->
  
```objc

@interface LayerDelegateTestViewController ()

@property (nonatomic,strong)UIView  *view1;//view
@property (nonatomic,strong)CALayer *layer1;//layer

@end

@implementation LayerDelegateTestViewController

- (void)viewDidLoad {

    /*左变放一个layer1，右边放一个view1，改变view1的layer的delegate是否为nil*/;
    
    //左边放一个layer
    self.layer1 = [CALayer layer];
    [self.view.layer addSublayer:self.layer1];
    
    //右边放一个View
    self.view1 = [[UIView alloc];
    [self.view addSubview:self.view1];
    
    //点击按钮改变view的layer的delegate是否为nil
    UIButton *button = [UIButton new];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(setViewDelegate:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rightBarButtonDidSelected {
    //点击导航栏按钮，同时改变颜色
    UIColor *color = self.randomColor;
    self.view1.layer.backgroundColor = color.CGColor;
    self.layer1.backgroundColor = color.CGColor;
}

- (void)setViewDelegate:(UIButton *)sender {
    //点击改变按钮，设置view1.layer.delegate=nil或者view1
    self.view1.layer.delegate = self.view1.layer.delegate?nil:self.view1;
}

```
 <!--例子5代码-->
  
```objc

@interface LayerActionForLayerTestViewController ()

@property (nonatomic,strong)UIView  *view1;//view

@end

@implementation LayerActionForLayerTestViewController

- (void)viewDidLoad {

    /* 右边放一个View*/
    self.view1 = [[UIView alloc] init];
    [self.view addSubview:self.view1];

    NSMutableString *logs = @"".mutableCopy;
    
    //打印一下动画前的actionForLayer改变
    [logs appendFormat:@"动画前：%@\n",[self.view1 actionForLayer:self.view1.layer forKey:@"backgroundColor"]];
    [self addTextDescrib:logs.copy];
    
    //打印一下添加动画后的actionForLayer改变
    [UIView animateWithDuration:5 animations:^{
        self.view1.backgroundColor = [UIColor redColor];
       id value =  [self.view1 actionForLayer:self.view1.layer forKey:@"backgroundColor"];
        [logs appendString:[NSString stringWithFormat:@"添加动画后：%@",value]];
        [self addTextDescrib:logs.copy];
    }];
}

```


 <!--例子6代码pop和CA对比-->
  
```objc

@implementation POPAndCAComparisonViewController

- (void)viewDidLoad {

    /*左边是个带有CA动画的view，右边是POP动画的view，sleep 5秒*/
    UIView *caView = [[UIView alloc]init];
    [self.view addSubview:caView];
    CABasicAnimation *caAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    caAnimation.toValue = @(M_PI);
    caAnimation.duration = 2.0;
    caAnimation.repeatCount = 500;
    [caView.layer addAnimation:caAnimation forKey:@"anim"];
    
    UIView *popView = [[UIView alloc]init];
    [self.view addSubview:popView];
    POPBasicAnimation *popAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    popAnimation.toValue = @(M_PI);
    popAnimation.duration = 2.0;
    popAnimation.repeatCount = 500;
    [popView.layer pop_addAnimation:popAnimation forKey:@"rotation"];
    popAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
}

//sleep 5秒
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    sleep(5);
    //5秒后可以直接手动断点调试,效果也一样
}
@end

```

 <!--例子7代码粒子系统-->
  
```objc
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define APP_MAIN_WINDOW  [UIApplication sharedApplication].delegate.window

@implementation CAEmitterCellDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightBarButtonTitle:@"发射"];
    self.view.backgroundColor = [UIColor blackColor];
    [self snow];
}

- (void)rightBarButtonDidSelected {
    [self rocket];
}

- (void)snow {
    
    CGRect emitterFrame =  APP_MAIN_WINDOW.bounds;
    
    ///生成发射器
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = emitterFrame;
    emitter.emitterPosition = CGPointMake(ScreenWidth/2.f, 0);
    emitter.emitterSize = emitterFrame.size;
    emitter.emitterMode = kCAEmitterLayerVolume;//发射模式
    emitter.emitterShape = kCAEmitterLayerLine;//发射源的形状
    [APP_MAIN_WINDOW.layer addSublayer:emitter];
    emitter.renderMode = kCAEmitterLayerAdditive;
    
    //发射器里面的粒子
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"icon_snowflake"].CGImage;
    cell.name = @"snow";
    cell.birthRate = 10;
    cell.lifetime = 50.f ;
    cell.velocity = 50;
    float minSize = 0.05f;
    float maxSize = 0.35f;
    cell.scale = (maxSize+minSize)/2.f;
    cell.scaleRange = (maxSize - minSize)/2.f;
    cell.velocityRange = 20;
    cell.emissionLongitude = M_PI;
    cell.emissionRange = M_PI/4 ;
    cell.spin = M_PI/12; // 子旋转角度
    cell.spinRange = M_PI/12;
    emitter.emitterCells = @[cell];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ///停止发射器的
        [emitter setValue:@(0) forKeyPath:@"emitterCells.snow.birthRate"];
    });
}

- (void)rocket {
    
    ///创建
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    fireworksEmitter.emitterSize = CGSizeZero;
    fireworksEmitter.emitterMode = kCAEmitterLayerOutline;//发射模式
    fireworksEmitter.emitterShape = kCAEmitterLayerLine;//发射源的形状
    
    fireworksEmitter.frame = APP_MAIN_WINDOW.bounds;
    fireworksEmitter.emitterPosition = CGPointMake(ScreenWidth/2.f, ScreenHeight-80);
    fireworksEmitter.renderMode = kCAEmitterLayerAdditive;//发射源的渲染模式
    fireworksEmitter.seed = (arc4random()%100)+1;
    [APP_MAIN_WINDOW.layer addSublayer:fireworksEmitter];
    
    //火箭
    CAEmitterCell* rocket  = [CAEmitterCell emitterCell];
    rocket.name = @"rocket";
    rocket.birthRate = 3;
    rocket.velocity = 500;
    rocket.velocityRange = 80;
    rocket.yAcceleration = 75;
    rocket.lifetime = 1.02;
    rocket.contents = (id) [[UIImage imageNamed:@"icon_fireworks_rocket"] CGImage];
    rocket.scale = 0.6;
    rocket.emissionRange = (M_PI/6); // 周围发射角度
    
    rocket.emissionLongitude = -M_PI/25;
    
    //爆炸
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    burst.birthRate = 1.0;
    burst.velocity = 0;
    burst.scale = 0.2;
    burst.lifetime = 0.15;
    
    //烟花
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    spark.birthRate = 400;
    spark.velocity = 125;
    spark.emissionRange = 2* M_PI;
    spark.yAcceleration = 75;
    spark.lifetime = 3;
    spark.contents = (id) [[UIImage imageNamed:@"icon_fireworks_flower"] CGImage];
    spark.scaleSpeed =-0.2;
    spark.greenSpeed =0.5;
    spark.redSpeed = 1;
    spark.blueSpeed = 0;
    spark.alphaSpeed =-0.45;
    spark.spin = 2* M_PI;
    spark.spinRange = 2* M_PI;
    spark.scale = 3.f;
    spark.alphaRange = 0.3;
    
    ///把烟花，爆炸等各种粒子组加入到发射器里
    fireworksEmitter.emitterCells = [NSArray arrayWithObject:rocket];
    rocket.emitterCells = [NSArray arrayWithObject:burst];
    burst.emitterCells = [NSArray arrayWithObject:spark];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [fireworksEmitter setValue:@(0) forKeyPath:@"emitterCells.rocket.birthRate"];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [fireworksEmitter removeFromSuperlayer];
    });
}

@end
```
