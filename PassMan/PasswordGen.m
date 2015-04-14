//
//  PasswordGen.m
//  PassMan
//
//  Created by ziggear on 15-4-14.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "PasswordGen.h"

@interface PasswordGen ()
@property (nonatomic, strong) NSArray *wordList;
@end

@implementation PasswordGen

- (instancetype)init {
    if(self = [super init]) {
        self.wordList = @[
                          @[@"cat", @"dog", @"horse", @"rabbit", @"mouse", @"drangon"],             //animals
                          @[@"apple", @"orange", @"lemon", @"berry"],                               //fruits
                          @[@"bike", @"bus", @"train", @"taxi", @"walk", @"run", @"airplane"],      //transport
                          @[@"sun", @"moon", @"star", @"cloud", @"wind", @"rain", @"storm"],        //weather
                          @[@"eye", @"ear", @"nose", @"mouth", @"hair", @"hand", @"leg", @"feet"],  //humanbeing
                          @[@"john", @"tom", @"jack", @"kelly", @"jim", @"james", @"george"],       //name
                          ];
        
        srand((int)time(NULL));
        rand()%100;
    }
    return self;
}

- (NSInteger)numberOfLines {
    return self.wordList.count;
}

- (NSInteger)numberOfRowsOfLine:(NSInteger)lineNum {
    if(lineNum + 1 > self.numberOfLines || lineNum < 0) {
        return -1;
    } else {
        return [[self.wordList objectAtIndex:lineNum] count];
    }
}

- (NSInteger)randomRow {
    return rand() % self.numberOfLines;
}

- (NSInteger)randomColumnAtRow:(NSInteger)row {
    return rand() % [self numberOfRowsOfLine:row];
}

- (NSString *)generateCodeByLength:(int)length andGenType:(PasswordGenType)type {
    NSMutableArray *passList = [NSMutableArray array];
    for(int i = 0; i < length; i ++) {
        NSInteger row = [self randomRow];
        NSInteger col = [self randomColumnAtRow:row];
        NSString *word = [[self.wordList objectAtIndex:row] objectAtIndex:col];
        NSString *anotherWord = [self transFormWord:word byType:type];
        [passList addObject:anotherWord];
    }
    
    NSMutableString *passwordToRet = [NSMutableString string];
    for(NSString *w in passList){
        [passwordToRet appendString:w];
    }
    return [NSString stringWithString:passwordToRet];
}

- (NSString *)transFormWord:(NSString *)word byType:(PasswordGenType)type {
    NSString *anotherWord;
    switch (type) {
        case PasswordGenTypeUpperCase:
            anotherWord = [word uppercaseString];
            break;
        case PasswordGenTypeUpperCaseAtBeginning: {
            NSString *head = [word substringWithRange:NSMakeRange(0, 1)];
            NSString *tail = [word substringWithRange:NSMakeRange(1, word.length - 1)];
            anotherWord = [NSString stringWithFormat:@"%@%@", [head uppercaseString], tail];
            break;
        }
        case PasswordGenTypeRandomCase: {
            BOOL isUp = rand()%2;
            if(isUp) {
                anotherWord = [word uppercaseString];
            }
            break;
        }
        case PasswordGenTypeNormal:
        default:
            anotherWord = word;
            break;
    }
    return anotherWord;
}

#pragma mark - Facade 

- (NSString *)generate {
    return [self generateCodeByLength:3 andGenType:PasswordGenTypeNormal];
}

- (NSString *)generateUpper {
    return [self generateCodeByLength:3 andGenType:PasswordGenTypeUpperCase];
}

- (NSString *)generateUpperAtFirstChar {
    return [self generateCodeByLength:3 andGenType:PasswordGenTypeUpperCaseAtBeginning];
}

#pragma mark - Class Method

+ (NSString *)timeToCr:(NSString *)str {
    double minSec = 0.000001;
    long long seconds = (long long)(minSec * [PasswordGen calculateCountComplexOfString:str]);
    if(seconds < 60) {
        return [NSString stringWithFormat:@"%lld秒", seconds];
    } else if (seconds < 60 * 60) {
        return [NSString stringWithFormat:@"%lld分钟", seconds / 60];
    } else if (seconds < 60 * 60 * 24) {
        return [NSString stringWithFormat:@"%lld小时", seconds / 3600];
    } else if (seconds < 60 * 60 * 24 * 7) {
        return [NSString stringWithFormat:@"%lld天", seconds / (3600 * 24)];
    } else if (seconds < 60 * 60 * 24 * 7 * 4) {
        return [NSString stringWithFormat:@"%lld周", seconds / (3600 * 24 * 7)];
    } else if (seconds < 60 * 60 * 24 * 7 * 4 * 12) {
        return [NSString stringWithFormat:@"%lld月", seconds / (3600 * 24 * 7 * 4)];
    } else {
        return [NSString stringWithFormat:@"%lld年", seconds / (3600 * 24 * 365)];
    }
}

+ (double)calculateCountComplexOfString:(NSString *)str {
    BOOL hasUpper = NO;
    BOOL hasNum = NO;
    if ([PasswordGen strIncludeUpperCase:str]) {
        hasUpper = YES;
    }
    if([PasswordGen strIncludeNum:str]) {
        hasNum = YES;
    }
    
    int sizeOfMultiple = 26;
    if(hasUpper) {
        sizeOfMultiple += 26;
    }
    if(hasNum) {
        sizeOfMultiple += 10;
    }
    
    NSInteger length = str.length;
    return pow(sizeOfMultiple, length);
}

+ (BOOL)strIncludeNum:(NSString *)str {
    NSString *regex = @"[0-9]";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:str] == YES) {
        return YES;
    }
    return NO;
}

+ (BOOL)strIncludeUpperCase:(NSString *)str {
    NSString *regex = @"[A-Z]";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:str] == YES) {
        return YES;
    }
    return NO;
}

@end
