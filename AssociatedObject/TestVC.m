//
//  TestVC.m
//  AssociatedObject
//
//  Created by DuBenben on 2020/10/16.
//  Copyright © 2020 CNKI. All rights reserved.
//

#import "TestVC.h"
#import "UIViewController+Associate.h"


//__weak修饰的指针，在其所指的对象被释放后，指针会自动置nil
__weak NSString *weakDwlStrong = nil;
__weak NSString *weakDwlCopy = nil;
NSString __weak *weakDwlAssgin = nil; //和上面那种写法应该是等效的


@interface TestVC ()

@end


@implementation TestVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    
    self.dwlStrong = [NSString stringWithFormat:@"杜文亮"];
    self.dwlCopy = [NSString stringWithFormat:@"男"];
    self.dwlAssgin = [NSString stringWithFormat:@"uuuuuuuu222"];
    
    weakDwlStrong = self.dwlStrong;
    weakDwlCopy = self.dwlCopy;
    weakDwlAssgin = self.dwlAssgin;
    
    UIViewController.associatedObject = @"类对象也可以进行属性关联";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    NSLog(@"%@ -------- weakPointer:%@", self.dwlStrong, weakDwlStrong);
    NSLog(@"%@ -------- weakPointer:%@", self.dwlCopy, weakDwlCopy);
    NSLog(@"%@", weakDwlAssgin); //1
//    NSLog(@"%@", self.dwlAssgin); //will crash 2
    
    NSLog(@"%@", UIViewController.associatedObject);
}

/*
    由这个实验，我们可以得出以下结论：

    关联对象的释放时机与被移除的时机并不总是一致的。比如上面的 self.dwlAssgin 所指向的对象在 TestVC 出现后就被释放了（1处可证明），但是 self.dwlAssgin 仍然有值，还是保存的原对象的地址(lldb调试可打印该值。self.dwlAssgin是一个指针，在栈中开辟的内存空间，其内存放的是堆区的一段内存地址。只不过当堆区的这段内存地址即对象未被释放时，我们打印该指针得到的是对象的值，而不是指针内存储的那段堆区中的内存地址，这应该是编译器的优化，是符合我们的需求的；对象被释放时，打印该指针就会得到其本身存储的那段堆区的内存地址了)，如果之后再使用 self.dwlAssgin 就会造成 Crash（2处可证明） ，所以我们在使用弱引用的关联对象时要非常小心。

    一个对象的所有关联对象是在这个对象被释放时调用的 _object_remove_assocations 函数中被移除的。
 */

@end

