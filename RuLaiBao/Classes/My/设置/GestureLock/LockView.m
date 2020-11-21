//
//  LockView.m
//  LockViewDemo
//
//  Created by qiu on 2017/6/26.
//  Copyright © 2017年 QiuFairy. All rights reserved.
//

#import "LockView.h"
#import "LockBtnItem.h"

#define ITEMTAG 122 //tag值

@interface LockView ()

@property(nonatomic,strong)NSMutableArray *btnArray;
//定义一个属性，记录当前点
@property(nonatomic,assign)CGPoint currentPoint;

@end

@implementation LockView

#pragma mark-懒加载
- (NSMutableArray *)btnArray
{
    if (_btnArray==nil) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}
//界面搭建
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
//在界面上创建9个按钮
-(void)setup
{
    self.backgroundColor = BACKGROUNDCOLOR;
    /****** 9个大点的布局 *****/
    [self createPoint_nine];
}

#pragma mark - total method

/**
 *  下面的9个划线的点   init
 */
- (void)createPoint_nine
{
    
    for (int i=0; i<9; i++)
    {
        int row    = i / 3;
        int column = i % 3;
        
        CGFloat spaceFloat = (self.frame.size.width-3*ITEMWH)/4;             //每个item的间距是等宽的
        CGFloat pointX     = spaceFloat*(column+1)+ITEMWH*column;   //起点X
        CGFloat pointY     =  (ITEMWH +spaceFloat)*row;     //起点Y
        
        /**
         *  对每一个item的frame的布局
         */
        LockBtnItem *item = [[LockBtnItem alloc] initWithFrame:CGRectMake( pointX  , pointY , ITEMWH, ITEMWH)];
        item.userInteractionEnabled = YES;
        item.backgroundColor = [UIColor clearColor];
        item.isSelect = NO;
        item.tag = ITEMTAG + i ;
        [self addSubview:item];
    }
}

#pragma mark - Touch Event
/**
 *  begin
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint point = [self touchLocation:touches];
    [self isContainItem:point];
}


/**
 *  touch Move
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    CGPoint point = [self touchLocation:touches];
    
    [self isContainItem:point];
    
    [self touchMove_triangleAction];
    
    [self setNeedsDisplay];
    
}


/**
 *  touch End
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self touchEndAction];
    
    [self setNeedsDisplay];
    
    
}

/**
 *  touch  begin move
 */

- (CGPoint)touchLocation:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _currentPoint = point;
    
    return point;
}

- (void)isContainItem:(CGPoint)point
{
    for (LockBtnItem *item  in self.subviews)
    {
        if ([item isKindOfClass:[LockBtnItem class]])
        {
            BOOL isContain = CGRectContainsPoint(item.frame, point);
            if (isContain && item.isSelect==NO)
            {
                [self.btnArray addObject:item];
                item.isSelect = YES;
                item.model = selectStyle;
            }
        }
    }
}

- (void)touchMove_triangleAction
{
    NSString *resultStr = [self getResultPwd];
    if (resultStr&&resultStr.length>0   )
    {
        NSArray *resultArr = [resultStr componentsSeparatedByString:@"A"];
        if ([resultArr isKindOfClass:[NSArray class]]  &&  resultArr.count>2 )
        {
            NSString *lastTag    = resultArr[resultArr.count-1];
            NSString *lastTwoTag = resultArr[resultArr.count-2];
            
            CGPoint lastP ;
            CGPoint lastTwoP;
            LockBtnItem *lastItem;
            
            for (LockBtnItem *item  in self.btnArray)
            {
                if (item.tag-ITEMTAG == lastTag.intValue)
                {
                    lastP = item.center;
                }
                if (item.tag-ITEMTAG == lastTwoTag.intValue)
                {
                    lastTwoP = item.center;
                    lastItem = item;
                }
                
                CGFloat x1 = lastTwoP.x;
                CGFloat y1 = lastTwoP.y;
                CGFloat x2 = lastP.x;
                CGFloat y2 = lastP.y;
                
                [lastItem judegeDirectionActionx1:x1 y1:y1 x2:x2 y2:y2 isHidden:NO];
            }
        }
    }
}

/**
 *  touch end
 */
- (void)touchEndAction
{
    for (LockBtnItem *itemssss in self.btnArray)
    {
        [itemssss judegeDirectionActionx1:0 y1:0 x2:0 y2:0 isHidden:NO];
    }
   
    NSString *result = [[self getResultPwd] stringByReplacingOccurrencesOfString:@"A" withString:@""];
    NSLog(@"用户输入的密码为：%@",result);
    //通知代理，告知用户输入的密码
    if ([self.delegate respondsToSelector:@selector(LockViewDidClick:andPwd:)]) {
        [self.delegate LockViewDidClick:self andPwd:result];
    }
    
    // 数组清空
    [self.btnArray removeAllObjects];
    
    
    // 选中样式
    for (LockBtnItem *item  in self.subviews)
    {
        if ([item isKindOfClass:[LockBtnItem class]])
        {
            item.isSelect = NO;
            item.model = normalStyle;
            [item judegeDirectionActionx1:0 y1:0 x2:0 y2:0 isHidden:YES];
        }
    }
}

/**
 *  对密码str进行处理,此处可换
 */
- (NSString *)getResultPwd
{
    NSMutableString *resultStr = [NSMutableString string];
    
    for (LockBtnItem *item  in self.btnArray)
    {
        if ([item isKindOfClass:[LockBtnItem class]])
        {
            [resultStr appendString:@"A"];
            [resultStr appendString:[NSString stringWithFormat:@"%ld", (long)item.tag-ITEMTAG]];
        }
    }
    
    return (NSString *)resultStr;
}


#pragma mark - drawRect
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i=0; i<self.btnArray.count; i++)
    {
        LockBtnItem *item = (LockBtnItem *)self.btnArray[i];
        if (i==0)
        {
            [path moveToPoint:item.center];
        }
        else
        {
            [path addLineToPoint:item.center];
        }
    }
    
    if (_currentPoint.x!=0 && _currentPoint.y!=0 && NSStringFromCGPoint(_currentPoint))
    {
        [path addLineToPoint:_currentPoint];
    }
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineWidth:1.0f];
    [SELECTCOLOR setStroke];
    [path stroke];
}


@end
