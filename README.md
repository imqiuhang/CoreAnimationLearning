# CoreAnimation相关学习的愉快探讨
###### @author imqiuhang
### 前言
>* If you are writing iOS apps, you are using Core Animation whether you know it or not.
>
>* You may never need to use Core Animation directly, but when you do you should understand the role that Core Animation plays as part of your app’s infrastructure.

以上是Apple在CoreAnimation指导的前言中的前两句话的引用，我们翻译之

第一句：**当你编写iOS应用的时候，不管你知不知道Core Animation这个东西，你都在使用它**。也就是说我们在日常编写iOS应用的时候一些不起眼的操作都会涉及到Core Animation的操作，只不过可能这些操作是系统自动帮我们做的，也就是‘**隐式**’的操作而我们忽略了他们的存在。

第二句：我们可能**不会直接的使用**Core Animation，**但是当我们使用相关功能的时候应该要了解Core Animation在背后默默的支持**(这句是我瞎翻译的)

---
因此，本片文章主要是针对CoreAnimation行为层面的一些探讨，通过各种小demo更好的理解动画实现的一些机制，以及分析开源第三方动画库的原理和效果做一些侧面的比较。由于才疏学浅，错误在所难免，有错误的地方以及补充欢迎在[issues](https://github.com/imqiuhang/CoreAnimationLearning/issues)中提出，第一时间更正，谢谢！

### ☑️@TODO 
Core Animation相关，大部分绘制和计算都是系统在后台支持的，我们只需要简单的提供参数，关于系统如何使用硬件加速以及在不增加CPU负担的前提下实现动画的流畅和顺滑的会在下一篇文章中进行整理。

### 相关链接
>* [Apple Core Animation Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html)
>* [CAMediaTimingFunction可视化](https://github.com/YouXianMing/Tween-o-Matic-CN)
>* [facebook pop](https://github.com/facebook/pop)
>* [popping-pop guide](https://github.com/schneiderandre/popping)
>* [AGGeometryKit](https://github.com/agens-no/AGGeometryKit-POP)
>* [本文章demo仓库](https://github.com/imqiuhang/CoreAnimationLearning)

### 本文目录
>* CATransaction-事务，重点揭示core animation偷偷干的那些事
>* 显式事务和隐式事务，CAAction-探讨layer被view支配的恐惧
>* layer的属性修改与呈现，揭示layer树结构
>* CoreAnimation动画整理以及CAMediaTiming相关操作
>* 定时器动画 -基于CADisplaylink的Facebook pop框架的整理
>* 粒子系统-CAEmitterCell

### CoreAnimation 目录
###### ✅表示本文涉及到，‼️表示重点探讨
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
---
---
### 正文部分
❗️备注1：以下所有的代码，为了精简和突出重点，所有的**布局代码**以及不太相关的代码都已经去掉，完整代码可以在[本文章demo仓库](https://github.com/imqiuhang/CoreAnimationLearning)中下载查看。所以忽略布局相关，可以直接在GIF中看到效果。

❗️备注2：为了方便更好的看到动画的效果和差异，GIF图片都经过了4倍的缓速。

---

【例子1】首先，我们来看一段非常非常简单的代码，然后运行它，看一下效果，代码非常简单，在vc的view中左边添加一个layer，右边添加一个view，然后点击导航栏的按钮，同时改变他们的backgroundColor属性。

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

看一下效果

![例子1-view和layer.gif](https://upload-images.jianshu.io/upload_images/3058688-c5020249f9161c7e.gif?imageMogr2/auto-orient/strip)


原本layer和view都是蓝色的，点击change，同时改变为红色，但是我们可以非常明显的看到，左边layer的颜色从蓝色变成红色的过程中，经历了一系列的颜色过度而右边的view几乎是非常突兀的变成了红色。

这个不禁引起了我们的思考，按理说，我们没有书写任何的动画代码，理论上，变化应该都和右边的view一样，非常直接的变成我们要的红色，可为何左边的layer“**偷偷”的给自己加戏？**

聪明的我们可能立刻就想起来在前言中我们引用了Apple官方指导的一句话"**当你编写iOS应用的时候，不管你知不知道Core Animation这个东西，你都在使用它**",也就是说可能我们赋值backgroundColor的时候“一不小心”的触发了CA的某个“隐式的”特性，因此我们还是决定从官方文档入手，找到这个“隐身”的东西。

>Layer Modifications Trigger Animations，
Most of the animations you create using Core Animation involve the modification of the layer’s properties. Like views, layer objects have a bounds rectangle, a position onscreen, an opacity, a transform, and many other visually-oriented properties that can be modified. For most of these properties, changing the property’s value results in the creation of an **implicit** animation whereby the layer animates from the old value to the new value. You can also explicitly animate these properties in cases where you want more control over the resulting animation behavior.

最终我们在文档中找到这么一段话，我用我英语4级多了5分的水平翻译了一下

>图层修改触发动画，您使用Core Animation创建的大多数动画都涉及修改图层的属性。与视图一样，图层对象具有frame，屏幕上的位置，不透明度，变换以及可以修改的许多其他视觉属性。对于大多数这些属性，更改属性的值会导致创建**隐式动画**，从而将图层从旧值设置为新值。如果希望更多地控制生成的动画行为，也可以显式设置这些属性的动画。


首先我们抓住几个重点

* 图层修改触发动画 Layer Modifications Trigger Animations
* 图层属性修改触发隐式动画 changing the property’s value results in the creation of an implicit animation
* 可以显式设置这些属性的动画  explicitly animate

因此我们大致知道了我们在修改图层属性的时候(CALayer属于Core Animation框架下，UIView属于UIKit，这个点我们在稍后会有讨论，所以先忽略为什么view不会触发隐式动画)会触发一个隐式动画，也就是我们看到的左边的layer偷偷给自己加的过渡动画。

那么何为隐式动画？隐式动画是如何自动的加入到一个属性的改变过程里的？

这个在官方的指导中没有非常详细的介绍，但是我们通过查阅如何显式的提交动画中也能发现触发隐式动画的关键是Transactions，也就是在CATransaction这个类中，首先查阅这个类，并没有属性可以供我们操作，也只有几个静态方法给我们调用，因此我们先看下文档对于这个类的解释。

### CATransaction

<!--Transaction官方解释-->

>Transactions are CoreAnimation's mechanism for batching multiple layer-
  tree operations into atomic updates to the render tree. **Every modification to the layer tree requires a transaction to be part of.**  <br><br>CoreAnimation supports two kinds of transactions, "explicit" transactions
  and "implicit" transactions.
  <br><br>Explicit transactions are where the programmer calls `[CATransaction begin] `
  before modifying the layer tree, and `[CATransaction commit]`<br>afterwards.<br><br>Implicit transactions are created automatically by CoreAnimation when the
  layer tree is modified by a thread without an active transaction.
  They are committed automatically when the thread's **run-loop next
  iterates**. In some circumstances (i.e. no run-loop, or the run-loop
  is blocked) it may be necessary to use explicit transactions to get
  timely render tree updates. 
  
  
 继续用4级的水平翻译一下
 
### 事务

>事务是CoreAnimation 将layer tree多个修改操作批量提交给渲染树的机制。 对layer tree的修改都需要事务作为其一部分。
>
>CoreAnimation支持两种事务，显式事务和隐式事务。
>显式事务是程序员在修改层树之前调用[CATransaction begin]，然后是[CATransaction commit]。
>当layer tree 修改时，如果没有有效的事务，CoreAnimation会自动创建隐式事务。

>它们在线程的runloop下一次迭代时自动提交。 在一些情况下（没有runloop，或者runloop被阻塞），可能有必要使用显式事务来及时地呈现树更新。
管理了一堆不能访问的事务。CATransaction没有属性或者实例方法，也不能用+alloc和-init方法创建它。只能用+begin和+commit入栈出栈一次事务的提交。

划重点

* 事务是layer属性修改批量提交给渲染树（后面会提到）的机制
* CoreAnimation支持 显式事务 和 隐式事务。
* layer每次修改都必须有对应事务
* 它们在线程的runloop下一次迭代时自动提交（可以看下系统在APP启动时候在runloop中注册的各类回调）
* 不能init一个事务的实例，只能乖乖调用静态方法

因此我们大致知道了，对于layer的修改，都会伴随着事务的提交，也就是事务的存在使我们看到了例子1中layer的过渡动画，那么我们来看下CATransaction中到底有些什么。

```objc
@interface CATransaction : NSObject

/* Begin a new transaction for the current thread; nests. */

+ (void)begin;

/* Commit all changes made during the current transaction. Raises an
 * exception if no current transaction exists. */

+ (void)commit;

/* Accessors for the "animationDuration" per-thread transaction
 * property. Defines the default duration of animations added to
 * layers. Defaults to 1/4s. */

+ (CFTimeInterval)animationDuration;
+ (void)setAnimationDuration:(CFTimeInterval)dur;

+ (nullable CAMediaTimingFunction *)animationTimingFunction;
+ (void)setAnimationTimingFunction:(nullable CAMediaTimingFunction *)function;

/* Accessors for the "disableActions" per-thread transaction property.
 * Defines whether or not the layer's -actionForKey: method is used to
 * find an action (aka. implicit animation) for each layer property
 * change. Defaults to NO, i.e. implicit animations enabled. */

+ (BOOL)disableActions;
+ (void)setDisableActions:(BOOL)flag;

+ (nullable void (^)(void))completionBlock;
+ (void)setCompletionBlock:(nullable void (^)(void))block;

@end

```

我去掉了一些不在讨论范围没的方法和注释，着重看下我们要讨论的方法。

首先我在百花之中第一眼就看到了**animationDuration**这个方法以及他的注释，**Defaults to 1/4s.也就是0.25秒**，这使得我恍然大悟

##### 结合上面Apple文档里说的，layer的修改都要事务作为一部分，如果不显示提供事务，则会创建隐式的事务，我们可以理解为事务是对一个可变属性修改的**动画载体**而在这里我们看到了事务里动画默认是0.25秒，所以结合我们的demo，我们已经非常清楚这个过渡动画是如何产生的了。

##### layer修改backgroundColor->系统提供了一个修改的动画载体-事务->事务的默认动画时长是0.25秒，因此我们看到了layer非常平滑的颜色改变的过渡效果！Apple牛逼！

然后我们继续看下其他的方法

`+ (void)begin` <br>
`+ (void)commit`<br>
`+ (void)setAnimationDuration:(CFTimeInterval)dur`<br>
`+ (void)setAnimationTimingFunction`<br>
`+ (void)setCompletionBlock:(nullable void (^)(void))block`<br>
这几个个方法乍一看和UIView提供的动画方法非常像是吧，只不过把AnimationCurve类型换成了TimingFunction，TimingFunction可以更加灵活一些，本质还是差不多，delegate换成block，嗯，简直孪生兄弟。

```objc
[UIView beginAnimations:@"animationKey" context:nil];
[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
[UIView setAnimationDuration:0.25f];
[UIView setAnimationDelegate:self];
self.view.backgroundColor = [UIColor redColor];
[UIView commitAnimations];
```

既然可以手动begin和commit提交事务，而且有一个`+ (void)setDisableActions:(BOOL)flag`方法，那么我们通过像提交一个动画一样手动去提交一个事务看看和隐式事务是否有什么区别。

####通过上面CATransaction的官方文档，只要将layer的属性修改包装在begin和commit之间就行了，那么我们试一下吧。

###例子2
例子非常简单，VC的view左边放layer1，右边放layer2，右边的事务我们手动提交，开关控制右边layer2 DisableActions的值，点击按钮同时改变backgroundColor属性，并且手动提交右边layer2的事务。
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
    //右边的layer我们手动提交事务
    [CATransaction begin];
    /*默认是NO， 设置YES来禁用action*/
    [CATransaction setDisableActions:!self.switch1.on];
    [CATransaction setAnimationDuration:0.25];/*默认的是0.25秒*/
    self.layer2.backgroundColor = color.CGColor;
    [CATransaction commit];
}
```

我们看下效果

![例子2-1关闭事务action.gif](https://upload-images.jianshu.io/upload_images/3058688-80c2d535d39fa90c.gif?imageMogr2/auto-orient/strip)

![例子2-1开启事务action.gif](https://upload-images.jianshu.io/upload_images/3058688-ccea1755fe4a74a3.gif?imageMogr2/auto-orient/strip)

首先，第一张图我们设置了右边的layer setDisableActions为YES，那么和我们预期的一样，左边的layer有过渡动画，右边的没有
在看第二张图，我们手动提交了右边layer的事务，并且setDisableActions为NO，也就是开启了action，由于设置的动画时长是默认的0.25，所以我们看到和我们所想的一样，两边的过渡没有任何区别，因为主要设置的参数一样，隐式和显式的事务没有任何区别，当然我们可以设置显式事务的其他参数，例如动画时长，特别是setAnimationTimingFunction来达到我们想要的变化效果。

根据文档，事务可以嵌套 需要等最外层的事务commit之后才会提交到runloop

```objc
 
[CATransaction begin];

	  [CATransaction begin];
	         ...
	  [CATransaction commit];
  ...
  
[CATransaction commit];

```

##### 当然了，我们在文档的很多地方都看到“Animatable Properties”,也就是可动画的属性，那么必然也会有不可动画属性，只有Animatable标记的属性的改变的事务才会有动画，这点我们在稍后会有提到。Animatable一般都在.h的属性注释中标记，可以在CALayer.中看到，列举两个例子
```objc
/* Unlike NSView, each Layer in the hierarchy has an implicit frame
 * rectangle, a function of the `position', `bounds', `anchorPoint',
 * and `transform' properties. When setting the frame the `position'
 * and `bounds.size' are changed to match the given frame. */

@property CGRect frame;

/** Geometry and layer hierarchy properties. **/

/* The bounds of the layer. Defaults to CGRectZero. Animatable. */

@property CGRect bounds;

/* The position in the superlayer that the anchor point of the layer's
 * bounds rect is aligned to. Defaults to the zero point. Animatable. */

@property CGPoint position;
```

可以很明显的看出layer的frame不是Animatable属性，而bounds和position是Animatable，可以两个结合代替frame
在官方文档中是这么描述的

> frame ,This property is not animatable. You can achieve the same results by animating the bounds and position properties.

备注:B代表default implied CABasicAnimation，在下方表格B-1中<br>
    T代表default implied CATransition，在下方表格B-2中<br>

##### 表格A-1,layer的属性和默认动画值

| 属性 | 默认动画 | 
| :------: | :------: | 
| anchorPoint | B | 
| backgroundColor | T|
| backgroundFilters |T|
| borderColor |B|
| borderWidth |B|
| bounds |B|
| compositingFilter |T|
| contents |B|
| contentsRect |B|
| cornerRadius |B|
| doubleSided |不支持|
| filters |B|
| frame |不支持|
| hidden |B|
| mask |B|
| masksToBounds |B|
| opacity |B|
| position |B|
| shadowColor |B|
| shadowOffset |B|
| shadowOpacity |B|
| shadowPath |B|
| shadowRadius |B|
| sublayers |B|
| sublayerTransform |B|
| transform |B|
| zPosition |B|


##### 表格B-1-default implied CABasicAnimation(B)

| Description | Value | 
| :------: | :------: | 
| Class | CABasicAnimation | 
| Duration |0.25 seconds, or the duration of the current transaction|
|Key path|Set to the property name of the layer.|


##### 表格B-1-代表default implied CATransition(T)

| Description | Value | 
|:------: | :------: | 
| Class | CATransition | 
| Duration |0.25 seconds, or the duration of the current transaction|
| Type |Fade (kCATransitionFade)|
|Start progress|0.0|
|End progress|1.0|

