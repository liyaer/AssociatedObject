//
//  UIViewController+Associate.h
//  AssociatedObject
//
//  Created by DuBenben on 2020/10/16.
//  Copyright © 2020 CNKI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//以系统类演示（最常用），也可以是自定义的任何其他类（比如这里的TestVC、ViewController）
@interface UIViewController (Associate)

@property (nonatomic, strong) NSString *dwlStrong;
@property (nonatomic, copy) NSString *dwlCopy;
@property (nonatomic, assign) NSString *dwlAssgin;


+ (NSString *)associatedObject;
+ (void)setAssociatedObject:(NSString *)associatedObject;

@end

NS_ASSUME_NONNULL_END

/*
 三个值得思考的问题
 
    1，关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？
        关联对象与被关联对象本身的存储并没有直接的关系，它是存储在单独的哈希表中的；

    2，关联对象的五种关联策略有什么区别，有什么坑？
        关联对象的五种关联策略与属性的限定符非常类似，在绝大多数情况下，我们都会使用 OBJC_ASSOCIATION_RETAIN_NONATOMIC 的关联策略，这可以保证我们持有关联对象；

    3，关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？
        关联对象的释放时机与移除时机并不总是一致，比如实验中用关联策略 OBJC_ASSOCIATION_ASSIGN 进行关联的对象，很早就已经被释放了，但是并没有被移除，而再使用这个关联对象时就会造成 Crash 
 */

/*
 使用场景

     1，为现有的类添加私有变量以帮助实现细节；

     2，为现有的类添加公有属性；

     3，为 KVO 创建一个关联的观察者。
   
 从本质上看，第 1 、2 个场景其实是一个意思，唯一的区别就在于新添加的这个属性是公有的还是私有的而已。就目前来说，我在实际工作中使用得最多的是第 2 个场景，而第 3 个场景我还没有使用过。
 */

/*
 相关系统函数
        
    void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
    id objc_getAssociatedObject(id object, const void *key);
    void objc_removeAssociatedObjects(id object);

    1，objc_setAssociatedObject 用于给对象添加关联对象，传入 nil 则可以移除已有的关联对象；

    2，objc_getAssociatedObject 用于获取关联对象；

    3，objc_removeAssociatedObjects 用于移除一个对象的所有关联对象。
 
 注意：3一般是用不上的，因为这个函数会移除一个对象的所有关联对象，将该对象恢复成“原始”状态。这样做就很有可能把别人添加的关联对象也一并移除，这并不是我们所希望的。所以一般的做法是通过给 objc_setAssociatedObject 函数传入 nil 来移除某个已有的关联对象
 
 
 关于前两个函数中的 key 值是我们需要重点关注的一个点，这个 key 值必须保证是一个“对象级别的唯一常量”。一般来说，有以下三种推荐的 key 值：

     1，声明 static char kAssociatedObjectKey; ，使用 &kAssociatedObjectKey 作为 key 值;

     2，声明 static void *kAssociatedObjectKey = &kAssociatedObjectKey; ，使用 kAssociatedObjectKey 作为 key 值；

     3，用 selector ，使用 getter 方法的名称作为 key 值。

 我个人最喜欢的（没有之一）是第 3 种方式，因为它省掉了一个变量名，非常优雅地解决了计算科学中的两大世界难题之一（命名）。
 */
