//
//  GLDTweenTween.m
//  GLDTween
//
//  Created by Takayuki Fukatsu on 2014/10/01.
//  Copyright (c) 2014 THE GUILD. All rights reserved.
//

#import "GLDTweenTween.h"


/**
 実際のアニメーションを表現するクラス。
 */
@implementation GLDTweenTween


- (id)init {
    if (self = [super init]) {
        self.properties = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}


@end
