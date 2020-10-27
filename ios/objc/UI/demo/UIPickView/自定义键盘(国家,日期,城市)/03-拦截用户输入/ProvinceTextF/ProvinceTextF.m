//
//  ProvinceTextF.m
//  03-拦截用户输入
//
//  Created by xiaomage on 16/1/15.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ProvinceTextF.h"
#import "ProvinceItem.h"

@interface ProvinceTextF()<UIPickerViewDataSource,UIPickerViewDelegate>

/** 存放的都是省份模型 */
@property (nonatomic, strong) NSArray *dataArray;

/** 当前选中省份的角标 */
@property (nonatomic, assign) NSInteger proIndex;

/** <#注释#> */
@property (nonatomic, weak) UIPickerView *pick;

@end

@implementation ProvinceTextF


-(NSArray *)dataArray{
    if (_dataArray == nil) {
      NSString *path = [[NSBundle mainBundle] pathForResource:@"provinces.plist" ofType:nil];
        
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            //把字典转模型
           ProvinceItem *item = [ProvinceItem itemWithDict:dict];
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


//总共有多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

//每一列有多少行.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dataArray.count;
    }else{

        //当前选中的省份决定,当前选中省份下有多少个城市
        //当前选中的省份模型,返回当前选中的省份下的城市数量
        ProvinceItem *item = self.dataArray[self.proIndex];
        return item.cities.count;
        
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        ProvinceItem *item =   self.dataArray[row];
        return item.name;
    }else{
        ProvinceItem *item = self.dataArray[self.proIndex];
        return item.cities[row];
    }
    
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        NSLog(@"%ld",row);
        self.proIndex = row;
        
        //第1列选中第0行
        [pickerView selectRow:0 inComponent:1 animated:YES];
        //刷新数据
        [pickerView reloadAllComponents];
    }
    
    //取出当前选中的省份
    ProvinceItem *item = self.dataArray[self.proIndex];
    NSString *provinceName = item.name;
    
    //获取第1列选中的行
    NSInteger cityRow = [pickerView selectedRowInComponent:1];
    NSString *cityName = item.cities[cityRow];
    self.text = [NSString stringWithFormat:@"%@-%@",provinceName,cityName];
}

//初始化文本框文字(选中第0列第0行)
- (void)initWithText{
    [self pickerView:self.pick didSelectRow:0 inComponent:0];
}





@end
