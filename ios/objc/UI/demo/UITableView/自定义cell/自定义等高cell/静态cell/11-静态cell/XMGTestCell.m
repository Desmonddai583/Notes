//
//  XMGTestCell.m
//  11-静态cell
//
//  Created by xiaomage on 16/1/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGTestCell.h"

@interface XMGTestCell ()


@property (nonatomic, weak)IBOutlet UISwitch *s;
@end
@implementation XMGTestCell

- (void)awakeFromNib {
    self.s.on = NO;
}



@end
