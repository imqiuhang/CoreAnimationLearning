# CoreAnimation相关学习的愉快探讨
###### @author imqiuhang
### 前言
>* If you are writing iOS apps, you are using Core Animation whether you know it or not.
>
>* You may never need to use Core Animation directly, but when you do you should understand the role that Core Animation plays as part of your app’s infrastructure.

以上两句话是引用了Apple在CoreAnimation指导文档的前两句，我们翻译之

>* 第一句：**当你编写iOS应用的时候，不管你知不知道Core Animation这个东西，你都在使用它**。也就是说我们在日常编写iOS应用的时候一些不起眼的操作都会涉及到Core Animation的操作，只不过可能这些操作是系统自动帮我们做的，也就是‘**隐式**’的操作而我们忽略了他们的存在。

>* 第二句：我们可能**不会直接的使用**Core Animation，**但是当我们使用相关功能的时候应该要了解Core Animation在APP中所扮演的角色**


以上两句也表明了Apple对于Core Animation的态度：**我们尽量帮你实现，但你也应该了解他。**

>Core Animation Manages Your App’s Content<br>
Core Animation is not a drawing system itself. It is an infrastructure for compositing and manipulating your app’s content in hardware. At the heart of this infrastructure are layer objects, which you use to manage and manipulate your content.

 这一句文档诠释了CoreAnimation自身**不是一个绘制系统**，而是一个APP视图**内容的管理**基础系统，这个系统的上层便是**layer**。
##### 因此,本文中我们重点探讨CoreAnimation是如何管理app’s content in hardware，而如何提交绘制以及绘制的部分将会忽略。通过各种小demo更好的理解动画实现的一些机制和思想，了解"Core Animation所扮演的角色"这样能让我们在编写代码的时候更加的从容和省力。由于才疏学浅，错误在所难免，有错误的地方以及补充欢迎在[issues](https://github.com/imqiuhang/CoreAnimationLearning/issues)中提出，第一时间更正，谢谢！

### ☑️@TODO 
Core Animation相关，大部分绘制和计算都是系统在后台支持的，我们只需要简单的提供参数，关于系统如何使用硬件加速以及在不增加CPU负担的前提下实现动画的流畅和顺滑的会在下一篇文章中进行整理。

### 相关链接
>* [Apple Core Animation Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html)
>* [CAMediaTimingFunction可视化](https://github.com/YouXianMing/Tween-o-Matic-CN)
>* [layer层级以及坐标系转换](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/CoreAnimationBasics/CoreAnimationBasics.html#//apple_ref/doc/uid/TP40004514-CH2-SW12)
>* [facebook pop](https://github.com/facebook/pop)
>* [popping-pop guide](https://github.com/schneiderandre/popping)
>* [AGGeometryKit](https://github.com/agens-no/AGGeometryKit-POP)
>* [本文章demo仓库](https://github.com/imqiuhang/CoreAnimationLearning)

### 本文目录
>* [CATransaction-显式事务和隐式事务，重点揭示core animation偷偷干的那些事](#CATransaction-事务)
>* [CAAction-探讨layer被view支配的恐惧](#layer与view)
>* [layer的属性修改与呈现，揭示layer树结构](#layer树结构)
>* [CAAnimation动画整理以及CAMediaTiming，CAMediaTiming相关协议的组合操作](#下面总结一下CAAnimation相关)
>* [定时器动画 -基于CADisplaylink的Facebook pop框架的源码分析](#Facebook-pop)
>* [粒子系统-CAEmitterCell](#粒子系统)

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
## 正文部分

<br>

❗️备注1：以下所有的代码，为了精简和突出重点，所有的**布局代码**以及不太相关的代码都已经去掉，完整代码可以在[本文章demo仓库](https://github.com/imqiuhang/CoreAnimationLearning)中下载查看。所以忽略布局相关，可以直接在GIF中看到效果。

❗️备注2：为了方便更好的看到动画的效果和差异，GIF图片都经过了4倍的缓速。
<br>
<br>

### CATransaction-事务
---

#####【例子1】

首先，我们来看一段非常非常简单的代码，然后运行它，看一下效果，代码非常简单，在vc的view中左边添加一个layer，右边添加一个view，然后点击导航栏的按钮，同时改变他们的backgroundColor属性。

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

##### CATransaction

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
 
##### 事务

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

#### 通过上面CATransaction的官方文档，只要将layer的属性修改包装在begin和commit之间就行了，那么我们试一下吧。

##### 【例子2】
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


### layer与view
---

至此，我们已经非常清楚的了解到了layer是如何通过事务来达到默认动画的效果，我们也可以大致解释例子1中，为什么layer有默认动画，而view没有

##### 这时候我们可能非常大声的喊出：因为事务树作用在layer上的而不是view上<br>
##### 那么问题来了，我们都知道view只不过是layer的一个代理而已啊，文档上也是这么说的啊
>view is layer's delegate

#### 所以刚刚清醒又陷入到迷惑之中：对哦，这和我add一个view还是add一个layer有毛关系哦。凭什么view就没隐式动画？view里面不也是有个layer负责这些吗！！

所以带着疑惑，我们换个思路，假如我们add view1的layer呢，是否有隐式动画？也就是把例子1中`[self.view addSubview:view1]`改成`[self.view.layer addSublayer:self.view1.layer]`试试看效果，直接看代码

##### 【例子3】

例子很简单，就是例子1的改版，左边直接放个layer，右边放一个view.layer，点击导航栏按钮，改变两个视图的颜色

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
看下效果

![例子3-直接添加子view对比.gif](https://upload-images.jianshu.io/upload_images/3058688-9649cfbe14be142d.gif?imageMogr2/auto-orient/strip)

###### 由此可见，和addView还是addLayer并无关系，只要是view中的layer，换句话说只要layer被view管理，那么隐式动画都没有被默认开启，那么view是如果禁用layer的隐式动画？

上面也提到了，view是layer的delegate，也就是layer的管理者，那么我们看下CALayer中这个delegate是什么

```objc
/* An object that will receive the CALayer delegate methods defined
 * below (for those that it implements). The value of this property is
 * not retained. Default value is nil. */

@property(nullable, weak) id <CALayerDelegate> delegate;

```
也就是这个delegate，layer的delegate默认是nil，也就是直接创建的layer的delegate为nil，而通过view关联的layer默认的delegate为view，那是不是这个原因，我们通过一个例子来看下。

##### 【例子4】

例子也非常简单，左边放一个layer1，右边放一个view1，然后我们改变view1的layer的delegate是否为nil分别测试一下

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

看下效果

###### view1的layer的delegate为view时，也就是delegate不为nil

![例子4-1-view设置layerdelegate为view.gif](https://upload-images.jianshu.io/upload_images/3058688-17446b855fd5c8a3.gif?imageMogr2/auto-orient/strip)


###### view1的layer的delegate为nil时

![例子4-2-设置view的layerdelegate为nil.gif](https://upload-images.jianshu.io/upload_images/3058688-30dff72f78edea90.gif?imageMogr2/auto-orient/strip)


可能这个gif速度减慢没做好，需要特别仔细的看哈。 可以看出，当右边layer的delegate为view1(默认)的时候，和我们预期一样，直接改变颜色，没有默认效果，而下面layer的delegate我们手动置位nil的时候可以看出左右两个视图都有了默认动画，看来问题就是出在这里，view通过layer的这个delegate支配了layer！


##### 但是刚刚官方文档说了layer的改变都会包含在事务，也就是说事务的提交肯定无法取消，那么how?
原因其实在CATransaction的文档中已经有相关体现，也就是disableActions这个方法，那么何为action，UIView如何通过action来实现对layer的隐式动画的控制？通过翻阅Apple的官方文档其实我们也不难发现。我们先来看下这个delegate中能够和事务中的action联系起来的方法

```objc
@protocol CALayerDelegate <NSObject>
@optional
- (void)layoutSublayersOfLayer:(CALayer *)layer;

/* If defined, called by the default implementation of the
 * -actionForKey: method. Should return an object implementing the
 * CAAction protocol. May return 'nil' if the delegate doesn't specify
 * a behavior for the current event. Returning the null object (i.e.
 * '[NSNull null]') explicitly forces no further search. (I.e. the
 * +defaultActionForKey: method will not be called.) */

- (nullable id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event;

@end

```

##### 我想都不需要划重点了，看到下面这句我相信已经恍然大悟了
> Returning the null object (i.e.
 * '[NSNull null]') explicitly forces no further search

 也就是说，返回NSNull就停止搜寻，那么隐式事务就拿不到一个action(action是什么待会会讲到，我们这里就认为没有action就相当于事务的disableActions为YES了)，那么也就没有了动画，也就是说UIView通过实现layer的delegate并且返回了NSNull从而达到了禁止隐式事务的目的。
 
不知道你有没有注意到explicitly forces no further search这句话，也就是返回NSNull,Core Animation会停止进一步的搜寻，换句话说如果返回一个nil，那么Core Animation将会继续搜寻一个合适的action？那么哪里搜寻？

这点在文档中有非常详细的介绍，甚至有相关的代码，我直接翻译一下


>在一个action被执行之前，layer需要找到要action的相应操作对象。与layer相关的action的是通过修改的属性对应的字符串作为key的。当图层属性改变时，图层会调用其actionForKey:方法来搜索与该key关联的action。在此搜索过程中，您的应用可以在几个点插入自己，并为该键提供相关的操作对象。

>Core Animation按以下顺序查找action对象：
>
1. 如果图层具有delegate并且该delegate实现该actionForLayer:forKey:方法，则该图层将调用该方法。delegate实现以下几种情况的其中一个：
 * 返回一个属性key对应的action，提供默认动画
 * 返回一个nil如果它不处理这个属性key对应的action，在这种情况下将继续让后面2，3，4的步骤执行搜索。
 * 返回NSNull对象，在这种情况下，搜索立即结束。也就是没有默认的动画。
2. 在该layer的actions字典中通过属性key查找action，如果有的话。`@property(nullable, copy) NSDictionary<NSString *, id<CAAction>> *actions;`
3. 在该layer的style字典中查找包含该键的actions字典。`@property(nullable, copy) NSDictionary *style`（换句话说，style是key-actions的一个字典）
4. 该图层调用其defaultActionForKey:类方法。
5. layer提供Core Animation定义的隐式操作（如果有）。


>如果某个步骤找到了action，则layer将停止其搜索并执行返回的action。当它找到一个action时，调用该action的runActionForKey:object:arguments:方法来执行该动作。如果为给定的action是CAAnimation的实例，则可以使用该方法的默认实现来执行动画。如果要定义符合CAAction协议的自定义对象，则必须使用对象的该方法实现来采取适当的操作。



##### 哇，好大一堆哦！我们划个重点，其实抛开七七八八的解释，也就是如果这个layer的delegate被实现了，则通过delegate的actionForLayer:forKey:方法获取，这期间如果返回了NSNull则停止一切搜索，也就是没有action了，如果返回nil,或者压根没有delegate则通过layer自己的几个字典里通过key来找到action

```objc
@protocol CAAction

/* Called to trigger the event named 'path' on the receiver. The object
 * (e.g. the layer) on which the event happened is 'anObject'. The
 * arguments dictionary may be nil, if non-nil it carries parameters
 * associated with the event. */

- (void)runActionForKey:(NSString *)event object:(id)anObject
    arguments:(nullable NSDictionary *)dict;

@end
```

可以看出CAAction也就是一个协议，通过文档不难发现CAAnimation也是一个实现了CAAction协议的action `@interface CAAnimation : NSObject
    <NSSecureCoding, NSCopying, CAMediaTiming, CAAction>`
    
    
#### 看到这里我们也明白了，其实view通过代理了layer的delegate，实现actionForLayer:forKey:返回NSNull来达到禁用了layer属性改变的默认动画！

语言太过无趣，我们通过两张图来对比下！

![layer被view支配](https://upload-images.jianshu.io/upload_images/3058688-346d36a1b107c789.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![layer自由](https://upload-images.jianshu.io/upload_images/3058688-efa3256f5f6c6bc1.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

其实也很好理解apple为什么这么做，layer是负责动画，渲染等显示相关的，而view负责用户交互，Apple认为view更多的应该是以处理用户事件为主，所以view默认并没有开启隐式动画，而layer负责纯展示，所以在变化的时候加入过渡动画会显得更加平滑，所以在不需要处理用户交互事件的元素上我们可以用layer代替view，好看性能又好，美滋滋。

---

问题又来了，刚理清view如何禁用了过渡动画，那么我们调用UIView的动画的时候为什么能动起来？说好的action不给呢？

```objc
[UIView beginAnimations:@"animationKey" context:nil];
[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
[UIView setAnimationDuration:0.25f];
[UIView setAnimationDelegate:self];
self.view1.backgroundColor = [UIColor redColor];
[UIView commitAnimations];

```

或者

```objc
[UIView animateWithDuration:1 animations:^{
    self.view1.backgroundColor = [UIColor redColor];
}];
```

没有action了，那怎么动?

##### 我们来看个例子，看看究竟action是否永远很死板的返回NSNull！！！

##### 【例子5】

例子也非常的简单，就是添加一个view1，打印一下动画前和加了动画时(应该说在动画提交上下文中)view1的layer actionForLayer:forKey方法返回的值

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

![例子5-actionForLayer的返回时机.png](https://upload-images.jianshu.io/upload_images/3058688-0d9f611db97eff88.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 可以很明显的看到，在动画前预料之中，返回NSNull.null,但是在动画的上下文中，既然返回了一个CAAction协议的对象，看下面这张图，我们打印一下，也就是之前文档所说的CAAnimation的子类！

![例子5-actionForLayer的返回时机-结果.png](https://upload-images.jianshu.io/upload_images/3058688-a12a4d2da3db9f0a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


##### 也就是说在动画的block或者begin commit之间这个context中，view通过layer的delegate竟然又返回了action！十分“鸡贼”!至于如何实现的我们不深入探讨了，总之view通过这个方法在我们手动调用动画的时候，这个方法返回了一个我们想要的动画！

当然了，动画block内如果属性并没有发生实质的变化，也是不会有action返回的，当然也不会有动画过程，并且会立刻回调completion，像下面这两种写法。

```objc
   self.view.backgroundColor = [UIColor yellowColor];
    [UIView animateWithDuration:1.f animations:^{
        self.view.backgroundColor = [UIColor yellowColor];
    } completion:^(BOOL finished) {
        //会立刻回调，并且不会返回action
    }];
```

```objc
    self.view.backgroundColor = [UIColor yellowColor];
    [UIView animateWithDuration:1.f animations:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.view.backgroundColor = [UIColor redColor];
        });
    } completion:^(BOOL finished) {
        //虽然颜色变了，但是是延迟，已经出了作用域后才变化的，所以会立刻回调，并且不会返回action
    }];
```


##### 另外，文档另外一个说明就是多个属性批量提交，那么一个属性多次修改，会提交多个事务吗？答案是不会的，运行时只会提交一个结果。


```objc
    self.view1.width = 100.f;
    self.view1.width = 100.f;
    self.view1.width = 100.f;
```
在运行时只会提交一次修改， layoutSubviews也只会调用一次,很Apple。

当然了，我们也可以直接自己去指定layer的delegate，并且实现相关的方法返回一个我们想要的隐式动画，这是文档上的官方例子，当然我们要根据上面的表格中对应属性锁对应的action类型来返回一个正确的action

```objc
- (id<CAAction>)actionForLayer:(CALayer *)theLayer
                        forKey:(NSString *)theKey {
    CATransition *theAnimation=nil;
 
    if ([theKey isEqualToString:@"contents"]) {
 
        theAnimation = [[CATransition alloc] init];
        theAnimation.duration = 1.0;
        theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        theAnimation.type = kCATransitionPush;
        theAnimation.subtype = kCATransitionFromRight;
    }
    return theAnimation;
}
```


---
---

### layer树结构
---

##### 其实说到了动画，我们不得不说下layer的model tree结构，以及在动画和非动画时候的model tree结构,下面两张是Apple文档里的官方图片

![树结构1.png](https://upload-images.jianshu.io/upload_images/3058688-b89b37365451c465.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![树结构2.png](https://upload-images.jianshu.io/upload_images/3058688-8a0f0984dbf4dc54.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


这里直接应用一下其他作者写的一个例子

>在CALayer内部，它控制着两个属性：presentationLayer(以下称为P)和modelLayer（以下称为M）。P只负责显示，M只负责数据的存储和获取。我们对layer的各种属性赋值比如frame，实际上是直接对M的属性赋值，而P将在每一次屏幕刷新的时候回到M的状态。比如此时M的状态是1，P的状态也是1，然后我们把M的状态改为2，那么此时P还没有过去，也就是我们看到的状态P还是1，在下一次屏幕刷新的时候P才变为2。而我们几乎感知不到两次屏幕刷新之间的间隙，所以感觉就是我们一对M赋值，P就过去了。P就像是瞎子，M就像是瘸子，瞎子背着瘸子，瞎子每走一步（也就是每次屏幕刷新的时候）都要去问瘸子应该怎样走（这里的走路就是绘制内容到屏幕上），瘸子没法走，只能指挥瞎子背着自己走。可以简单的理解为：一般情况下，任意时刻P都会回到M的状态。<br><br>而当一个CAAnimation（以下称为A）加到了layer上面后，A就把M从P身上挤下去了。现在P背着的是A，P同样在每次屏幕刷新的时候去问他背着的那个家伙，A就指挥它从fromValue到toValue来改变值。而动画结束后，A会自动被移除，这时P没有了指挥，就只能大喊“M你在哪”，M说我还在原地没动呢，于是P就顺声回到M的位置了。这就是为什么动画结束后我们看到这个视图又回到了原来的位置，是因为我们看到在移动的是P，而指挥它移动的是A，M永远停在原来的位置没有动，动画结束后A被移除，P就回到了M的怀里。
动画结束后，P会回到M的状态（当然这是有前提的，因为动画已经被移除了，我们可以设置fillMode来继续影响P），但是这通常都不是我们动画想要的效果。我们通常想要的是，动画结束后，视图就停在结束的地方，并且此时我去访问该视图的属性（也就是M的属性），也应该就是当前看到的那个样子。按照官方文档的描述，我们的CAAnimation动画都可以通过设置modelLayer到动画结束的状态来实现P和M的同步。<br>
作者：DHUsesAll <br>
来源：CSDN <br>
原文：https://blog.csdn.net/u013282174/article/details/50388546 <br>

---


##### 所以总结一下就是动画中的view要获取其最接近的状态比如现在的位置则要通过layer.presentationLayer来获取其中的属性。因此需要注意在动画中的元素在处理用户交互，判断点击等的-hitTest:需要用presentationLayer去判断，也就是动画中的师徒获取frame等相关属性需要用presentationLayer来获取才是最接近的

灵魂交互图^_^

![树结构-3.png](https://upload-images.jianshu.io/upload_images/3058688-144aacc765d20eeb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

至于刷新时机以及渲染会在下一篇中做探讨。


---
---
---

### 下面总结一下CAAnimation相关
---

![常用动画](https://upload-images.jianshu.io/upload_images/3058688-37bc3c288f804a39.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


其他的animation类型想必都已经用的非常熟练了，不再重复，CATransition其实是个比较好用的转场动画，比如图片的切换，文字的切换都是效果非常好的，而且也不需要实例化几个元素来回切换

代码

```objc

//update卡片的时候设置文字和图片之前添加转场动画即可
[self.titleLabel.layer addAnimation:self.defaulutTransitionAnimation forKey:kTransitionAnimationName];
 self.titleLabel.text = note.title;
    
    @weakify(self);
    [self.headImageView ht_setImageWithDefault:note.unify_coverURL  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        @strongify(self);
        if (image&&self) {
            /* headImageView transition */
            [self.headImageView.layer addAnimation:self.defaulutTransitionAnimation forKey:kTransitionAnimationName];
        }
    }];

- (CATransition *)defaulutTransitionAnimation {
    
    CATransition *animation = CATransition.animation;
    animation.duration = kTransitionAnimationDuration;
    //有几个效果不错的类型，也可以设置子类型，比如方向等
    animation.type = kCATransitionFade;
    animation.removedOnCompletion = YES;
    return animation;
}
```


![转场动画.gif](https://upload-images.jianshu.io/upload_images/3058688-43364f4ff1eb14bc.gif?imageMogr2/auto-orient/strip)

##### 通过动画对象layer的CAMediaTiming协议控制动画的暂停，开始，倒退，自定义进度等，这个是官方的文档的例子。


```objc
//暂停动画
-(void)pauseLayer:(CALayer*)layer {
   CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
   layer.speed = 0.0;
   layer.timeOffset = pausedTime;
}
 
 //开始动画
-(void)resumeLayer:(CALayer*)layer {
   CFTimeInterval pausedTime = [layer timeOffset];
   layer.speed = 1.0;
   layer.timeOffset = 0.0;
   layer.beginTime = 0.0;
   CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
   layer.beginTime = timeSincePause;
}

//倒退，结合repeatCount = MAXFLOAT实现反复动画
layer.autoreverses = YES;

```

##### 当然，设置动画的speed为0，就可以通过timeOffset自定义控制动画的进度了。

##### CAMediaTimingFunction，时间函数，这个就是调参生成自己的变化曲线，没有特别之处，可以在[CAMediaTimingFunction可视化](https://github.com/YouXianMing/Tween-o-Matic-CN)这个工具中进行参数事实查看曲线

![实时效果](https://github.com/YouXianMing/Tween-o-Matic-CN/raw/master/app.png)

### Facebook-pop
---

##### 下面我们从第三方开源动画框架POP入手，侧面对比下CoreAnimation

首先，我们了解到spring动画，即弹簧动画是有着非常好的用户体验的，各种仿真和缓动效果让iOS系统本身和自带应用非常炫酷，但是spring动画本身是iOS9才引入的api,如果我们想要在iOS9以下使用该如何操作呢？

第一中自然是使用先前提到的iOS7 UIView提供的block动画，虽然可以使用的参数比较少，单也能大致的实现一些spring的效果,如下代码可以看到可以传入弹簧的阻尼Damping，初始速率velocity

```objc

+ (void)animateWithDuration:(NSTimeInterval)duration
                      delay:(NSTimeInterval)delay
     usingSpringWithDamping:(CGFloat)dampingRatio
      initialSpringVelocity:(CGFloat)velocity
                    options:(UIViewAnimationOptions)options
                 animations:(void (^)(void))animations
                 completion:(void (^)(BOOL))completion;

```

那如果想实现效果更多，自定义能力更强的spring动画如何？这就用到了大名鼎鼎的[facebook pop，开源动画库](https://github.com/facebook/pop)，一款GitHub 2W star的开源框架。Facebook最初是将其用于paper应用，一经推出，便引起了巨大的关注，paper的各种动画效果也是令善于抄袭的产品经理们垂涎三尺。

这里我们不讨论如何使用pop，因为其用法非常简单，和CAAnimation用法几乎完全一致，只是多了些参数，根据pop文档即可，我们先看一下几个效果，其他效果可以下载pop的第三方demo>* [popping-pop guide](https://github.com/schneiderandre/popping)

衰减效果

![popdemo-衰减动画.gif](https://upload-images.jianshu.io/upload_images/3058688-882ef27e798f6f5b.gif?imageMogr2/auto-orient/strip)

![popdemo-组合1.gif](https://upload-images.jianshu.io/upload_images/3058688-f5cffed95dcd4e11.gif?imageMogr2/auto-orient/strip)

![popdemo-组合2.gif](https://upload-images.jianshu.io/upload_images/3058688-ea0f31811df67714.gif?imageMogr2/auto-orient/strip)

![popdemo-组合3.gif](https://upload-images.jianshu.io/upload_images/3058688-6cf95082b34a1347.gif?imageMogr2/auto-orient/strip)

![popdemo-CADisplayLink.gif](https://upload-images.jianshu.io/upload_images/3058688-5dc1f6d0ac341cd5.gif?imageMogr2/auto-orient/strip)

![popdemo-spring动画.gif](https://upload-images.jianshu.io/upload_images/3058688-bed516523b5e2b2a.gif?imageMogr2/auto-orient/strip)


##### 来细谈一下POP的实现，从而从侧面对比一下CAAnimation

首先，我们在最上面也提到了，Core Animation提交了动画参数后所做的事情是在后台进程进行操作的，并使用了各种硬件加速等手段达到动画的流畅性，而作为第三方框架，这点是显然做不到的。动画，其显示原理简化一下就是在屏幕刷新的获得改帧对应的layer状态，然后设置，从而达到肉眼可见的动画效果，说白了就是有个定时器，这个定时器就是在屏幕刷新的时候调用，那么这个定时器显而易见就是CADisplayLink了。

定时器有了，使用CADisplayLink即可，那么等CADisplayLink回调的时候我们在设置layer的状态是不是就达到了目的，也就是说给layer一个read和write的方法，在回调的时候调用，让我们看下源码。

首先，既然POP也是通过layer添加一个动画，类似于CAAimation,那么我们找到pop animation的基类，POPAnimator看下他的init做了什么操作，我们去掉Mac os的代码以及加锁等操作的代码，简化的看一下

```objc
- (instancetype)init
{
  self = [super init];
  if (nil == self) return nil;

  _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render)];
  _displayLink.paused = YES;
  [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
  return self;
}

```
可以看到在init的时候，初始化了CADisplayLink这个定时器，并且加了回调render，默认定时器是暂停的，只有当动画add到layer的时候才开始。

我们早往下看下render回调做了什么，我们一层层的往下看，直到实现层，同理我们去掉了加锁等代码方便阅读

```objc

- (void)render
{
  CFTimeInterval time = [self _currentRenderTime];
  [self renderTime:time];
}

- (void)renderTime:(CFTimeInterval)time
{
  [self _renderTime:time items:_list];
}
- (void)_renderTime:(CFTimeInterval)time items:(std::list<POPAnimatorItemRef>)items
{
  // begin transaction with actions disabled
  [CATransaction begin];
  [CATransaction setDisableActions:YES];

  // notify delegate
  __strong __typeof__(_delegate) delegate = _delegate;
  [delegate animatorWillAnimate:self];

  // count active animations
  const NSUInteger count = items.size();
  if (0 == count) {
    // unlock
  } else {
    // copy list into vector
    std::vector<POPAnimatorItemRef> vector{ items.begin(), items.end() };
    for (auto item : vector) {
      [self _renderTime:time item:item];
    }
  }
  // update display link
  updateDisplayLink(self);
  [delegate animatorDidAnimate:self];
  [CATransaction commit];
}

```

这里有几个重点就是`[CATransaction setDisableActions:YES]`也印证里我们上面说的在做layer动画的时候最好关闭默认事务的action。
第二，`[self _renderTime:time item:item]`，这个方法一层层比较多，有兴趣可以直接在源码上看，具体在这个方法里通过read block获取，然后计算，获取当前的状态，然后通过write block给layer当前的状态赋值，具体的计算过程可以在源码中看到，我们看下read和write的block，在POPAnimatableProperty文件中。

```objc

@property (readonly, nonatomic, copy) POPAnimatablePropertyReadBlock readBlock;

/**
 @abstract Block used to write values from an array of floats into a property.
 */
@property (readonly, nonatomic, copy) POPAnimatablePropertyWriteBlock writeBlock;

```
那么这个block是如何与layer关联起来的，这点pop用了非常简单聪明的办法

```objc

NSString * const kPOPSCNNodeScaleY = @"scnnode.scale.y";
NSString * const kPOPSCNNodeScaleZ = @"scnnode.scale.z";
NSString * const kPOPSCNNodeScaleXY = @"scnnode.scale.xy";

typedef struct
{
  NSString *name;
  POPAnimatablePropertyReadBlock readBlock;
  POPAnimatablePropertyWriteBlock writeBlock;
  CGFloat threshold;
} _POPStaticAnimatablePropertyState;

```
name即动画的kaypath,即已经定义的一些例如kPOPSCNNodeScaleY等，通过kaypath将read white打包到一个结构体中，取的时候通过kaypath直接获取，我们实际看一下

```objc
static POPStaticAnimatablePropertyState _staticStates[] =
{
  /* CALayer */

  {kPOPLayerBackgroundColor,
    ^(CALayer *obj, CGFloat values[]) {
      POPCGColorGetRGBAComponents(obj.backgroundColor, values);
    },
    ^(CALayer *obj, const CGFloat values[]) {
      CGColorRef color = POPCGColorRGBACreate(values);
      [obj setBackgroundColor:color];
      CGColorRelease(color);
    },
    kPOPThresholdColor
  },

  {kPOPLayerBounds,
    ^(CALayer *obj, CGFloat values[]) {
      values_from_rect(values, [obj bounds]);
    },
    ^(CALayer *obj, const CGFloat values[]) {
      [obj setBounds:values_to_rect(values)];
    },
    kPOPThresholdPoint
  },
...

```


既然POP使用了基于屏幕刷新频率的定时器CADisplayLink作为回调源，并且`[_displayLink addToRunLoop:[NSRunLoop mainRunLoop]`也是添加在主线程的loop中，那么主线程如果卡顿是否会影响动画的流畅性？这个是显然的，我们可以通过一个demo来验证一下POP和CA在主线程卡顿时候的表现。

 <!--例子6代码pop和CA对比-->
  
##### 【例子6】

例子也很简单，左边放一个view添加CABasicAnimation，右边放一个view添加POPBasicAnimation，然后让主线程sleep5秒，对比一下。
  
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

效果图

![例子6-CA和POP对比.gif](https://upload-images.jianshu.io/upload_images/3058688-3d224250ff3e6942.gif?imageMogr2/auto-orient/strip)

可以很明显的看到在线程sleep也就是阻塞的情况下，pop是停止动画的，而CA的动画仍然在继续，也验证了之前提到的CA的动画是在独立进程中进行的。

POP和CAAnimation对比


| options | POP | CAAnimation | 
|:------: | :------: | :------: | 
| 支持系统| /|Spring动画 iOS 9| 
| 原理|POP是使用Objective-C++,基于CADisplayLink的框架，也就是说POP基于一个屏幕刷新频率的定时器的动画框架，如果线程阻塞，则动画停止|提交动画后，QuartzCore框架把动画的参数打包好，然后通过 IPC （处理器）发送给名为 backboardd 的后台处理程序。应用也会发送当前展示在屏幕上的每一个 layer 的信息。也就是说处理CA的动画是在一个独立的进程，独立于APP的存在。线程阻塞，断点什么的都不影响动画，🐂|

总的来说，作为spring动画日常使用，POP还是很优秀的框架，
iOS7-iOS9也可以用UIView的spring block动画粗略代替相对的效果

---
---


### 粒子系统
---

在iOS中另外一个性能非常优秀但是可能不怎么常用的动画：CAEmitterCell<br>
CAEmitterCell，iOS原生粒子动画系统,比较容易实现雪花，弹幕之类的
粒子发射效果，即使数量较多性能也比较不错。

这个可以实现大量粒子发射的效果，而且性能极佳，具体实现原理我们不细说，看下用法

##### 【例子7】

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

其实用法非常简单，就是一生成一个发射器，发射器里可以装很多发射源，和AnimationGroup一样可以指定时间，就是参数比较难调，而且随机性太大，需要花一些时间。

看下效果

![例子7-例子发射器.gif](https://upload-images.jianshu.io/upload_images/3058688-4983cd546a35b171.gif?imageMogr2/auto-orient/strip)

---
---

### 总结


Core Animation相关的东西还是比较多的，有些不太会出现在我们的日常使用当中，特别是一些框架已经默默做的事情，正如Apple文档所说的，我们必须了解其参与的角色，一些隐式的操作有可能会影响到我们日常的显式操作，@TODO**其中还有layer的很多相关还没有提到，会在后续慢慢补充**

[↑↑↑↑回到顶部↑↑↑↑](#readme)

[↑↑↑↑回到顶部↑↑↑↑](#readme)

[↑↑↑↑回到顶部↑↑↑↑](#readme)
