//
//  UIViewController+Associate.m
//  AssociatedObject
//
//  Created by DuBenben on 2020/10/16.
//  Copyright © 2020 CNKI. All rights reserved.
//

#import "UIViewController+Associate.h"
#import <objc/runtime.h>


static char sDDwlStrongKey;
static void *sDDwlCopyKey = &sDDwlCopyKey;


@implementation UIViewController (Associate)

#pragma mark - UIViewController Object Associated Objects

- (NSString *)dwlStrong {
    
    return objc_getAssociatedObject(self, &sDDwlStrongKey);
}

- (void)setDwlStrong:(NSString *)dwlStrong {
    
    objc_setAssociatedObject(self, &sDDwlStrongKey, dwlStrong, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)dwlCopy {
    
    return objc_getAssociatedObject(self, sDDwlCopyKey);
}

- (void)setDwlCopy:(NSString *)dwlCopy {
    
    objc_setAssociatedObject(self, sDDwlCopyKey, dwlCopy, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)dwlAssgin {
    
    //_cmd：SEL类型，在一个方法内调用，代表该方法。此处 _cmd = @selector(dwlSize)
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDwlAssgin:(NSString *)dwlAssgin {
    
    //虽然dwlAssgin用assgin修饰，理论上对应 OBJC_ASSOCIATION_ASSIGN 的关联策略；但是为了保证可正常访问，需要持有该属性，所以用 OBJC_ASSOCIATION_RETAIN_NONATOMIC，使用 OBJC_ASSOCIATION_ASSIGN 的话，访问该属性会crash，因为已经被释放了(详细解释请看Test.m)
    objc_setAssociatedObject(self, @selector(dwlAssgin), dwlAssgin, OBJC_ASSOCIATION_ASSIGN);
    
    //注意：测试发现，不同的类，不同的初始化方式，并不是一定都会导致crash，有的可正常访问（获取的值正确），有的不可正常访问（获取的值不正确 \ crash）。但是没关系，至少证明了OBJC_ASSOCIATION_ASSIGN的确存在隐患，应尽量避免使用
}

#pragma mark - UIViewController Class Associated Objects

+ (NSString *)associatedObject {
    return objc_getAssociatedObject([self class], _cmd);
}

+ (void)setAssociatedObject:(NSString *)associatedObject {
    objc_setAssociatedObject([self class], @selector(associatedObject), associatedObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
