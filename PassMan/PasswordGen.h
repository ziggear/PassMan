//
//  PasswordGen.h
//  PassMan
//
//  Created by ziggear on 15-4-14.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PasswordGenType) {
    PasswordGenTypeNormal,               //全小写
    PasswordGenTypeUpperCase,            //全大写
    PasswordGenTypeRandomCase,           //大小写随机（单词间）
    PasswordGenTypeUpperCaseAtBeginning  //首字母大写
};

@interface PasswordGen : NSObject
- (NSString *)generate;
- (NSString *)generateUpper;
- (NSString *)generateUpperAtFirstChar;

+ (double)calculateCountComplexOfString:(NSString *)str;
+ (NSString *)timeToCr:(NSString *)str;

@end
