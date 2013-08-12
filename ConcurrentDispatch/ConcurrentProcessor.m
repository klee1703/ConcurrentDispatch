//
//  ConcurrentProcessor.m
//  ConcurrentDispatch
//
//  Created by Keith Lee on 6/2/13.
//  Copyright (c) 2013 Keith Lee. All rights reserved.
//

#import "ConcurrentProcessor.h"

@implementation ConcurrentProcessor

{
  NSInteger *computeResult;
}

- (id)initWithData:(NSInteger *)result computations:(NSUInteger)computations
{
  if ((self = [super init]))
  {
    _computations = computations;
    computeResult = result;
  }
  return self;
}

- (void)main
{
  @autoreleasepool
  {
    @try
    {
      if (![self isCancelled])
      {
        NSLog(@"Performing %ld computations", self.computations);
        [NSThread sleepForTimeInterval:1.0];
        for (int ii=0; ii<self.computations; ii++)
        {
          *computeResult = *computeResult + 1;
        }
      }
    }
    @catch (NSException *ex) {}
  }
}

@end
