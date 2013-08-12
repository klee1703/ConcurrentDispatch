//
//  main.m
//  ConcurrentDispatch
//
//  Created by Keith Lee on 6/2/13.
//  Copyright (c) 2013 Keith Lee. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//   1. Redistributions of source code must retain the above copyright notice, this list of
//      conditions and the following disclaimer.
//
//   2. Redistributions in binary form must reproduce the above copyright notice, this list
//      of conditions and the following disclaimer in the documentation and/or other materials
//      provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY Keith Lee ''AS IS'' AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Keith Lee OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those of the
//  authors and should not be interpreted as representing official policies, either expressed
//  or implied, of Keith Lee.

#import <Foundation/Foundation.h>
typedef void (^ComputeTask)(void);

/* Retrieve a block used to download a URL */
ComputeTask getComputeTask(NSInteger *result, NSUInteger computation)
{
  NSInteger *computeResult = result;
  NSUInteger computations = computation;
  return ^{
    [NSThread sleepForTimeInterval:1.0];
    NSLog(@"Performing %ld computations", computations);
    for (int ii=0; ii<computations; ii++)
    {
      *computeResult = *computeResult + 1;
    }
  };
}

int main(int argc, const char * argv[])
{
  @autoreleasepool
  {
    NSInteger computeResult;
    dispatch_queue_t serialQueue = dispatch_queue_create("MySerialQueue",
                                                         DISPATCH_QUEUE_SERIAL);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, serialQueue, getComputeTask(&computeResult, 5));
    dispatch_group_async(group, serialQueue, getComputeTask(&computeResult, 10));
    dispatch_group_async(group, serialQueue, getComputeTask(&computeResult, 20));
    
    // Block until all tasks from group are completed
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"Computation result = %ld", computeResult);
    
  }
  return 0;
}

