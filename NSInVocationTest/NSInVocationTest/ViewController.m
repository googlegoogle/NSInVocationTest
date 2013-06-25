//
//  ViewController.m
//  NSInVocationTest
//
//  Created by opp_cat on 13-6-25.
//  Copyright (c) 2013年 opp_cat. All rights reserved.
//

#import "ViewController.h"


#import "TargetProxy.h"

@interface ViewController ()

@end

@implementation ViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
    
    
//    TargetProxy声明中是没有appendString与addObject消息的，在这儿却可以正常发送，不crash，原因就是发送消息的时候，如果原本类没有这个消息响应的时候，转向询问methodSignatureForSelector，接着在forwardInvocation将消息重定向。 上面也说了多参数的消息是不能重定向的。这我还没测过。
    
    // Create a proxy to wrap the real objects.  This is rather
    // artificial for the purposes of this example -- you'd rarely
    // have a single proxy covering two objects.  But it is possible.
  
    
    
    id proxy = [[TargetProxy alloc] initwithTarget1:[NSMutableString string] target2:[NSMutableArray array]];
    
    // Note that we can't use appendFormat:, because vararg methods
    // cannot be forwarded!
    
    //string
    [proxy appendString:@"This "];
    [proxy appendString:@"is "];
    //array
    [proxy addObject:@"!!!!"];
    [proxy appendString:@"a "];
    [proxy appendString:@"test!"];
    
    NSLog(@"count should be 1, it is: %d", [proxy count]);
    
    if ([[proxy objectAtIndex:0] isEqualToString:@"!!!!"]) {
        
        NSLog(@"Appending successful.");
    
        NSLog(@"the string pointer is %p",[proxy pointer]);
        
        NSLog(@"the string is %@",[proxy proxystringValues]);
        
    } else {
        NSLog(@"Appending failed, got: '%@'", proxy);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
