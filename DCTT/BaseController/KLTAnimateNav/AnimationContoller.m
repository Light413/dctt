//
//  AnimationContoller.m
//  ChongZu
//
//  Created by 孔令涛 on 2016/10/9.
//  Copyright © 2016年 cz10000. All rights reserved.
//

#import "AnimationContoller.h"
@interface AnimationContoller ()

@property(nonatomic,strong)NSMutableArray * screenShotArray;
/**
 所属的导航栏有没有TabBarController
 */
@property (nonatomic,assign)BOOL isTabbarExist;

@end

@implementation AnimationContoller

+ (instancetype)AnimationControllerWithOperation:(UINavigationControllerOperation)operation NavigationController:(UINavigationController *)navigationController
{
    AnimationContoller * ac = [[AnimationContoller alloc]init];
    ac.navigationController = navigationController;
    ac.navigationOperation = operation;
    return ac;
}
+ (instancetype)AnimationControllerWithOperation:(UINavigationControllerOperation)operation
{
    AnimationContoller * ac = [[AnimationContoller alloc]init];
    ac.navigationOperation = operation;
    return ac;
}

- (void)setNavigationController:(UINavigationController *)navigationController
{
    _navigationController = navigationController;
    
    UIViewController *beyondVC = self.navigationController.view.window.rootViewController;
    //判断该导航栏是否有TabBarController
    if (self.navigationController.tabBarController == beyondVC) {
        _isTabbarExist = YES;
    }
    else
    {
        _isTabbarExist = NO;
    }
}

- (NSMutableArray *)screenShotArray
{
    if (_screenShotArray == nil) {
        _screenShotArray = [[NSMutableArray alloc]init];
    }
    return _screenShotArray;
}
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return .4f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    
    UIImageView * screentImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    UIImage * screenImg = [self screenShot];
    screentImgView.image =screenImg;
    
    //取出fromViewController,fromView和toViewController，toView
    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    
    CGRect fromViewEndFrame = [transitionContext finalFrameForViewController:fromViewController];
    fromViewEndFrame.origin.x = ScreenWidth;
    CGRect fromViewStartFrame = fromViewEndFrame;
    CGRect toViewEndFrame = [transitionContext finalFrameForViewController:toViewController];
    CGRect toViewStartFrame = toViewEndFrame;
    
    
    
    UIView * containerView = [transitionContext containerView];
    
    if (self.navigationOperation == UINavigationControllerOperationPush) {
        
        
        [self.screenShotArray addObject:screenImg];
        
        //这句非常重要，没有这句，就无法正常Push和Pop出对应的界面
        [containerView addSubview:toView];
        
        toView.frame = toViewStartFrame;
        
        UIView * nextVC = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight)];
        
        //将截图添加到导航栏的View所属的window上
        [self.navigationController.view.window insertSubview:screentImgView atIndex:0];
        
        nextVC.layer.shadowColor = [UIColor blackColor].CGColor;
        nextVC.layer.shadowOffset = CGSizeMake(-0.8, 0);
        nextVC.layer.shadowOpacity = 0.6;
        
        self.navigationController.view.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            //toView.frame = toViewEndFrame;
            self.navigationController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            screentImgView.center = CGPointMake(-ScreenWidth/2, ScreenHeight / 2);
            //nextVC.center = CGPointMake(ScreenWidth/2, ScreenHeight / 2);
            
            
        } completion:^(BOOL finished) {
            
            [nextVC removeFromSuperview];
            [screentImgView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    }
    if (self.navigationOperation == UINavigationControllerOperationPop) {
        
        
        
        fromViewStartFrame.origin.x = 0;
        [containerView addSubview:toView];
        
        UIImageView * lastVcImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight)];
        //若removeCount大于0  则说明Pop了不止一个控制器
        if (_removeCount > 0) {
            for (NSInteger i = 0; i < _removeCount; i ++) {
                if (i == _removeCount - 1) {
                    //当删除到要跳转页面的截图时，不再删除，并将该截图作为ToVC的截图展示
                    lastVcImgView.image = [self.screenShotArray lastObject];
                    _removeCount = 0;
                    break;
                }
                else
                {
                    [self.screenShotArray removeLastObject];
                }
                
            }
        }
        else
        {
            lastVcImgView.image = [self.screenShotArray lastObject];
        }
        screentImgView.layer.shadowColor = [UIColor blackColor].CGColor;
        screentImgView.layer.shadowOffset = CGSizeMake(-0.8, 0);
        screentImgView.layer.shadowOpacity = 0.6;
        [self.navigationController.view.window addSubview:lastVcImgView];
        [self.navigationController.view addSubview:screentImgView];
        
        // fromView.frame = fromViewStartFrame;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            screentImgView.center = CGPointMake(ScreenWidth * 3 / 2 , ScreenHeight / 2);
            lastVcImgView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
            //fromView.frame = fromViewEndFrame;
            
        } completion:^(BOOL finished) {
            //[self.navigationController setNavigationBarHidden:NO];
            [lastVcImgView removeFromSuperview];
            [screentImgView removeFromSuperview];
            [self.screenShotArray removeLastObject];
            [transitionContext completeTransition:YES];
            
        }];
        
        
    }
    
}
- (void)removeLastScreenShot
{
    [self.screenShotArray removeLastObject];
    
}
- (void)removeAllScreenShot
{
    [self.screenShotArray removeAllObjects];
}
- (void)removeLastScreenShotWithNumber:(NSInteger)number
{
    for (NSInteger  i = 0; i < number ; i++) {
        [self.screenShotArray removeLastObject];
    }
}
- (UIImage *)screenShot
{
    // 将要被截图的view,即窗口的根控制器的view(必须不含状态栏,默认ios7中控制器是包含了状态栏的)
    UIViewController *beyondVC = self.navigationController.view.window.rootViewController;
    // 背景图片 总的大小
    CGSize size = beyondVC.view.frame.size;
    // 开启上下文,使用参数之后,截出来的是原图（YES  0.0 质量高）
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    // 要裁剪的矩形范围
    CGRect rect = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //注：iOS7以后renderInContext：由drawViewHierarchyInRect：afterScreenUpdates：替代
    
    //判读是导航栏是否有上层的Tabbar  决定截图的对象
    if (_isTabbarExist) {
        [beyondVC.view drawViewHierarchyInRect:rect  afterScreenUpdates:NO];
    }
    else
    {
        [self.navigationController.view drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    }
    // 从上下文中,取出UIImage
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    // 千万记得,结束上下文(移除栈顶的基于当前位图的图形上下文)
    UIGraphicsEndImageContext();
    
    
    
    // 返回截取好的图片
    return snapshot;
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
