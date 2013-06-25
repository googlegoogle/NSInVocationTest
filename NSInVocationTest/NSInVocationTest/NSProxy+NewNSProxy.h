//
//  NSProxy+NewNSProxy.h
//  NSInVocationTest
//
//  Created by opp_cat on 13-6-25.
//  Copyright (c) 2013年 opp_cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSProxy (NewNSProxy)
//return 'pointer'
-(IMP)pointer;
//return instance
//according to
//获取NSProxy 属性列表里的NSString
//!!! for index 0
-(id)proxystringValues;

@end
