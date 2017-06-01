//
//  a.m
//  SwiftXor
//
//  Created by ZhangLiangZhi on 2017/5/4.
//  Copyright © 2017年 xigk. All rights reserved.
//

#import <Foundation/Foundation.h>

void ocseed(int seed) {
    srand(seed);
}

int ocrand() {
    return rand();
}
