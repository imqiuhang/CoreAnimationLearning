# CoreAnimation相关学习的愉快探讨
##### 本篇文章主要是CoreAnimation行为层面的一些探讨以及和第三方动画库的原理和效果的一些对比，和介绍用法不同，本文旨在通过各种小demo为更好的理解动画实现的一些机制做探讨，用的更加从容。作者才疏学浅，有错误的地方以及补充欢迎在[issues](https://github.com/imqiuhang/CoreAnimationLearning/issues)中提出，第一时间更正。


# 相关链接
>* [Apple Core Animation Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html)
>* [facebook pop](https://github.com/facebook/pop)
>* [popping-pop guide](https://github.com/schneiderandre/popping)
>* [AGGeometryKit](https://github.com/agens-no/AGGeometryKit-POP)
>* [本文章demo仓库](https://github.com/imqiuhang/CoreAnimationLearning)

# 本文目录
>* Apple对于动画交互的偏爱
>* CATransaction-事务，重点揭示core animation偷偷干的那些事！
>* 显式事务和隐式事务，动画action-探讨layer被view支配的恐惧
>* layer的属性修改与呈现，揭示layer树结构
>* CoreAnimation动画整理。
>* 定时器动画 -基于CADisplaylink的Facebook pop框架的整理
>* 粒子系统-CAEmitterCell

# CoreAnimation 目录
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
  
