//
//  ViewController.m
//  10-画板
//
//  Created by xiaomage on 16/1/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"
#import "HandleImageView.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,handleImageViewDelegate>
@property (weak, nonatomic) IBOutlet DrawView *drawView;

@end

@implementation ViewController

//属于谁的东西,应该在谁里面去写.
//清屏
- (IBAction)clear:(id)sender {
    [self.drawView clear];
}

//撤销
- (IBAction)undo:(id)sender {
    [self.drawView undo];
}

//橡皮擦
- (IBAction)erase:(id)sender {
    [self.drawView erase];
}

//设置线的宽度
- (IBAction)setLineWidth:(UISlider *)sender {
    [self.drawView setLineWith:sender.value];
}

//设置线的颜色
- (IBAction)setLineColor:(UIButton *)sender {
    [self.drawView setLineColor:sender.backgroundColor];
}


//照片
- (IBAction)photo:(id)sender {
    //从系统相册当中选择一张图片
    //1.弹出系统相册
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    
    //设置照片的来源
    pickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pickerVC.delegate = self;
    //modal出系统相册
    [self presentViewController:pickerVC animated:YES completion:nil];
}


//保存
- (IBAction)save:(id)sender {
    //把绘制的东西保存到系统相册当中
    
    //1.开启一个位图上下文
    UIGraphicsBeginImageContextWithOptions(self.drawView.bounds.size, NO, 0);
    
    
    //2.把画板上的内容渲染到上下文当中
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    [self.drawView.layer renderInContext:ctx];
    
    //3.从上下文当中取出一张图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //4.关闭上下文
    UIGraphicsEndImageContext();
    
    //5.把图片保存到系统相册当中
    //注意:@selector里面的方法不能够瞎写,必须得是image:didFinishSavingWithError:contextInfo:
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
    
}

//保存完毕时调用
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"success");
    
}
//- (void)saveSuccess {
//    NSLog(@"success");
//}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


//当选择某一个照片时,会调用这个方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    NSLog(@"%@",info);
    UIImage *image  = info[UIImagePickerControllerOriginalImage];

    //NSData *data = UIImageJPEGRepresentation(image, 1);
    NSData *data = UIImagePNGRepresentation(image);
    //[data writeToFile:@"/Users/xiaomage/Desktop/photo.jpg" atomically:YES];
    [data writeToFile:@"/Users/xiaomage/Desktop/photo.png" atomically:YES];
    
    HandleImageView *handleV = [[HandleImageView alloc] init];
    handleV.backgroundColor = [UIColor clearColor];
    handleV.frame = self.drawView.frame;
    handleV.image = image;
    handleV.delegate = self;
    [self.view addSubview:handleV];
    
    
    
    
    //self.drawView.image = image;
    //取消弹出的系统相册 
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


-(void)handleImageView:(HandleImageView *)handleImageView newImage:(UIImage *)newImage {
    
    self.drawView.image = newImage;
    
}



- (void)pan:(UIPanGestureRecognizer *)pan {
    
    CGPoint transP = [pan translationInView:pan.view];
    pan.view.transform = CGAffineTransformTranslate(pan.view.transform, transP.x, transP.y);
    
    //复位
    [pan setTranslation:CGPointZero inView:pan.view];
    
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch {
    
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale,pinch.scale);
    
    [pinch setScale:1];
    
}

- (void)longP:(UILongPressGestureRecognizer *)longP {
    
    if (longP.state == UIGestureRecognizerStateBegan) {
        
        //先让图片闪一下,把图片绘制到画板当中
        [UIView animateWithDuration:0.5 animations:^{
           longP.view.alpha = 0;
        }completion:^(BOOL finished) {
            
           [UIView animateWithDuration:0.5 animations:^{
               longP.view.alpha = 1;
               
           }completion:^(BOOL finished) {
               
               //把图片绘制到画板当中
               UIGraphicsBeginImageContextWithOptions(longP.view.bounds.size, NO, 0);
               CGContextRef ctx = UIGraphicsGetCurrentContext();
               [longP.view.layer renderInContext:ctx];
            
               UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
               UIGraphicsEndImageContext();
               
               self.drawView.image = newImage;
               
               [longP.view removeFromSuperview];
               

           }];
            
        }];
        
        
    }
}









@end
