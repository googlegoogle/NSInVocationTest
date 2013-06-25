//
//  TargetProxy.m
//  NSInVocationTest
//
//  Created by opp_cat on 13-6-25.
//  Copyright (c) 2013年 opp_cat. All rights reserved.
//

#import "TargetProxy.h"



@implementation TargetProxy

@synthesize realObject1=_realObject1;
@synthesize realObject2=_realObject2;

-(id)initwithTarget1:(id)t1 target2:(id)t2
{
    _realObject1=t1;
    _realObject2=t2;
    return self;
}

// The compiler knows the types at the call site but unfortunately doesn't
// leave them around for us to use, so we must poke around and find the types
// so that the invocation can be initialized from the stack frame.

// Here, we ask the two real objects, realObject1 first, for their method
// signatures, since we'll be forwarding the message to one or the other
// of them in -forwardInvocation:.  If realObject1 returns a non-nil
// method signature, we use that, so in effect it has priority.
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig;
    sig = [_realObject1 methodSignatureForSelector:aSelector];
    if (sig) return sig;
    sig = [_realObject2 methodSignatureForSelector:aSelector];
    return sig;
}

// Invoke the invocation on whichever real object had a signature for it.
- (void)forwardInvocation:(NSInvocation *)invocation {
    id target = [_realObject1 methodSignatureForSelector:[invocation selector]] ? _realObject1 : _realObject2;
    [invocation invokeWithTarget:target];
}

// Override some of NSProxy's implementations to forward them...
- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([_realObject1 respondsToSelector:aSelector]) return YES;
    if ([_realObject2 respondsToSelector:aSelector]) return YES;
    return NO;
}



- (NSArray *)getAllPropertyNames
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}

- (void *)getPointerOfIvarForPropertyNamed:(NSString *)name
{
    objc_property_t property = class_getProperty([self class], [name UTF8String]);
    
    const char *attr = property_getAttributes(property);
    const char *ivarName = strchr(attr, 'V') + 1;
    
    Ivar ivar = object_getInstanceVariable(self, ivarName, NULL);
    
    return (char *)self + ivar_getOffset(ivar);
}

-(id)getidOfIvarForPropertyNamedIvay:(NSString *)name
{
    objc_property_t property = class_getProperty([self class], [name UTF8String]);
    
    const char *attr = property_getAttributes(property);
    const char *ivarName = strchr(attr, 'V') + 1;
    
    Ivar ivar = object_getInstanceVariable(self, ivarName, NULL);

    return  object_getIvar(self,ivar);
}
-(IMP)pointer
{
    NSArray *properties = [self getAllPropertyNames];
    
    for (id item in properties) {
        if ([item isKindOfClass:[NSMutableString class]]) {
           return [self getPointerOfIvarForPropertyNamed:item];
        }
    }
    return nil;
}
-(id)proxystringValues
{
    NSArray *properties = [self getAllPropertyNames];
    
    for (id item in properties) {
        if ([item isKindOfClass:[NSMutableString class]]) {
            NSLog(@"the item is %@",item);
            return   [self getidOfIvarForPropertyNamedIvay:item];;
        }
    }
    return nil;
   
}
@end
