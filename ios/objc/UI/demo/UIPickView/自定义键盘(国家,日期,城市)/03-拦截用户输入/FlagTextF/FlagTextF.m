//
//  FlagTextF.m
//  03-拦截用户输入
//
//  Created by xiaomage on 16/1/15.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FlagTextF.h"
#import "FlagItem.h"
#import "FlagView.h"

@interface FlagTextF()<UIPickerViewDataSource,UIPickerViewDelegate>

/** 加载的数据 */
@property (nonatomic, strong) NSArray *dataArray;

/** <#注释#> */
@property (nonatomic, weak)  UIPickerView *pick;


@end

@implementation FlagTextF


-(NSArray *)dataArray{
    
    if (_dataArray == nil) {
        
      NSString *path = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
     NSArray *array = [NSArray arrayWithContentsOfFile:path];
     //把数组当中的字典转成模型
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
          FlagItem *item =  [FlagItem itemWithDict:dict];
            [tempArray addObject:item];
        }
        _dataArray = tempArray;
        
    }
    return _dataArray;
}

-(void)awakeFromNib{
    //初始化文本框
    [self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化文本框
        [self setUp];
    }
    return self;
}

//初始化文本框
- (void)setUp {
    
    //创建UIPickView
    UIPickerView *pick = [[UIPickerView alloc] init];
    pick.delegate  =self;
    pick.dataSource = self;
    //修改文本框弹出键盘类型
    self.inputView = pick;
    self.pick = pick;
}

//实现协议方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    FlagView *flagView =  [FlagView flagView];
    //取出当前行的模型
    FlagItem *item =  self.dataArray[row];
    flagView.item = item;

    return flagView;
}


//返回pickView的行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 80;
}

//把当前选中的内容显示文本框当中
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    FlagItem *item = self.dataArray[row];
    self.text = item.name;
}

//初始化文本框文字(选中第0列第0行)
- (void)initWithText{
    [self pickerView:self.pick didSelectRow:0 inComponent:0];
}



@end
