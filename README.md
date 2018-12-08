# 一，CoreAnimation相关学习的愉快探讨
###前言
>* If you are writing iOS apps, you are using Core Animation whether you know it or not.
>
>* You may never need to use Core Animation directly, but when you do you should understand the role that Core Animation plays as part of your app’s infrastructure.
>
>以上是Apple在CoreAnimation指导的前言中的前两句话，我们翻译之
>
>第一句：**当你编写iOS应用的时候，不管你知不知道Core Animation这个东西，你都在使用它**。也就是说我们在日常编写iOS应用的时候一些不起眼的操作都会涉及到Core Animation的操作，只不过可能这些操作是系统自动帮我们做的，也就是‘**隐式**’的操作而我们忽略了他们的存在。
>
>第二句：我们可能**不会直接的使用**Core Animation，**但是当我们使用相关功能的时候应该要了解Core Animation在背后默默的支持**(这句是我瞎翻译的)

---
因此，本片文章主要是针对CoreAnimation行为层面的一些探讨，通过各种小demo更好的理解动画实现的一些机制，以及分析开源第三方动画库的原理和效果做一些侧面的比较。由于才疏学浅，错误在所难免，有错误的地方以及补充欢迎在[issues](https://github.com/imqiuhang/CoreAnimationLearning/issues)中提出，第一时间更正，谢谢！

###☑️@TODO 
Core Animation相关，大部分绘制和计算都是系统在后台支持的，我们只需要简单的提供参数，关于系统如何使用硬件加速以及在不增加CPU负担的前提下实现动画的流畅和顺滑的会在下一篇文章中进行整理。

### 相关链接
>* [Apple Core Animation Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html)
>* [facebook pop](https://github.com/facebook/pop)
>* [popping-pop guide](https://github.com/schneiderandre/popping)
>* [AGGeometryKit](https://github.com/agens-no/AGGeometryKit-POP)
>* [本文章demo仓库](https://github.com/imqiuhang/CoreAnimationLearning)

### 本文目录
>* CATransaction-事务，重点揭示core animation偷偷干的那些事
>* 显式事务和隐式事务，CAAction-探讨layer被view支配的恐惧
>* layer的属性修改与呈现，揭示layer树结构
>* CoreAnimation动画整理。
>* 定时器动画 -基于CADisplaylink的Facebook pop框架的整理
>* 粒子系统-CAEmitterCell

### CoreAnimation 目录
######✅表示本文涉及到，‼️表示重点探讨
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
###正文部分
❗️备注1：以下所有的代码，为了精简和突出重点，所有的布局代码以及不太相关的代码都已经去掉，完整代码可以在[本文章demo仓库](https://github.com/imqiuhang/CoreAnimationLearning)中下载查看。所以忽略布局相关，可以直接在GIF中看到效果。

❗️备注2：为了方便更好的看到动画的效果和差异，GIF图片都经过了4倍的缓速。

---

首先，我们来看一段非常非常简单的代码，然后运行它，看一下效果



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
  
