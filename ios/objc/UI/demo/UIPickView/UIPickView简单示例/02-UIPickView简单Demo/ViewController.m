//
//  ViewController.m
//  02-UIPickView简单Demo
//
//  Created by xiaomage on 16/1/15.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** 存放加载的数据 */
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController


-(NSArray *)dataArray{
    
    if (_dataArray == nil) {
      NSString *path =  [[NSBundle mainBundle] pathForResource:@"foods.plist" ofType:nil];
        _dataArray = [NSArray arrayWithContentsOfFile:path];
        
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pickView.dataSource = self;
    self.pickView.delegate = self;
    
    [self pickerView:self.pickView didSelectRow:0 inComponent:0];
    
}

//展示多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.dataArray.count;
}

//每一列展示多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray *array = self.dataArray[component];
    return array.count;
}

//每一列的每一行展示什么内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSArray *array = self.dataArray[component];
    return array[row];
}

//当前选中的是哪一列的哪一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSString *title = self.dataArray[component][row];
    self.titleLabel.text = title;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
