//
//  TargetProxy.h
//  NSInVocationTest
//
//  Created by opp_cat on 13-6-25.
//  Copyright (c) 2013年 opp_cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"
#import "NSProxy+NewNSProxy.h"

@interface TargetProxy : NSProxy
{
    id _realObject1;
    id _realObject2;
}

@property(retain,nonatomic) id realObject1;

@property(retain,nonatomic) id realObject2;

-(id)initwithTarget1:(id)t1 target2:(id)t2;
@end
