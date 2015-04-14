//
//  ViewController.m
//  PassMan
//
//  Created by ziggear on 15-4-14.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "ViewController.h"
#import "PasswordGen.h"
@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UILabel *passwordLabel;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *generateOptions;
@property (nonatomic, strong) PasswordGen *generator;

@property (nonatomic, strong) IBOutlet UILabel *otherLabel1;
@property (nonatomic, strong) IBOutlet UILabel *otherLabel2;

@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //self.passwordLabel.text = @"";
    self.otherLabel1.text = @"";
    self.otherLabel2.text = @"";
    
    [self.passwordLabel setAdjustsFontSizeToFitWidth:YES];
    
    self.generator = [[PasswordGen alloc] init];
    
    self.generateOptions = @[
                             @"生成普通密码",
                             @"生成大写密码",
                             @"生成首字母大写密码",
                             ];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleDisplay)];
    self.otherLabel2.userInteractionEnabled = YES;
    [self.otherLabel2 addGestureRecognizer:self.tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.generateOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self.generateOptions objectAtIndex:indexPath.row];
    return cell;
}

BOOL isShow = NO;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    isShow = NO;
    
    switch (indexPath.row) {
        case 0:
            self.passwordLabel.text = [self.generator generate];
            self.otherLabel1.text = @"破解这个密码";
            self.otherLabel2.text = [NSString stringWithFormat:@"需要穷举%e次", [PasswordGen calculateCountComplexOfString:self.passwordLabel.text]];
            break;
        case 1:
            self.passwordLabel.text = [self.generator generateUpper];
            self.otherLabel1.text = @"破解这个密码";
            self.otherLabel2.text = [NSString stringWithFormat:@"需要穷举%e次", [PasswordGen calculateCountComplexOfString:self.passwordLabel.text]];
            break;
        case 2:
            self.passwordLabel.text = [self.generator generateUpperAtFirstChar];
            self.otherLabel1.text = @"破解这个密码";
            self.otherLabel2.text = [NSString stringWithFormat:@"需要穷举%e次", [PasswordGen calculateCountComplexOfString:self.passwordLabel.text]];
            break;
        default:
            break;
    }
}



- (void)toggleDisplay {
    if(self.passwordLabel.text.length <= 0 || [self.passwordLabel.text isEqualToString:@"PASSMAN"]) {
        return;
    }
    
    self.otherLabel1.text = @"破解这个密码";
    
    if(isShow) {
        isShow = NO;
        self.otherLabel2.text = [NSString stringWithFormat:@"需要穷举%e次", [PasswordGen calculateCountComplexOfString:self.passwordLabel.text]];
    } else {
        isShow = YES;
        self.otherLabel2.text = [NSString stringWithFormat:@"相当于一台电脑计算%@", [PasswordGen timeToCr:self.passwordLabel.text]];
    }
}

@end
