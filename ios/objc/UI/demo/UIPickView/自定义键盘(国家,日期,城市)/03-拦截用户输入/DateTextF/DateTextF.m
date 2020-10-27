//
//  DateTextF.m
//  03-拦截用户输入
//
//  Created by xiaomage on 16/1/15.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "DateTextF.h"

@interface DateTextF()

/** <#注释#> */
@property (nonatomic, weak) UIDatePicker *datePick;

@end

@implementation DateTextF


-(void)awakeFromNib{
    //初始化
    [self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self setUp];
    }
    return self;
}

//初始化
- (void)setUp {
    
    UIDatePicker *datePick = [[UIDatePicker alloc] init];
    //修改datePick日期模式
    datePick.datePickerMode = UIDatePickerModeDate;
    datePick.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    
    //监听日期改变
    [datePick addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    //日期键盘
    self.inputView = datePick;
    
    self.datePick = datePick;
}

//当日期改变的时候会调用
- (void)dateChange:(UIDatePicker *)datePick{
    
    //把当前的日期给文本框赋值
    //获取当前选中的日期
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    //把当前日期转成字符串
   self.text = [fmt stringFromDate:datePick.date];
    
    
}



- (void)initWithText{
    [self dateChange:self.datePick];
}




@end
