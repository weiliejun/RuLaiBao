//
//  DetailLabel.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/16.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "DetailLabel.h"

@implementation DetailLabel

- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString *)text
                     fontSize:(CGFloat)font
                    textColor:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        if (text.length) {
            self.text = text;
        } else {
            self.text = @"--";
        }
        self.font = [UIFont systemFontOfSize:font];
        self.textColor = color;
        self.numberOfLines = 0;
        
        CGFloat height = [self heightWithFont:font width:frame.size.width contentText:text];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
    }
    return self;
}

- (CGFloat)heightWithFont:(CGFloat)font width:(CGFloat)width contentText:(NSString *)textStr {
    self.font = [UIFont systemFontOfSize:font];
    CGSize size = CGSizeMake(width, MAXFLOAT);
    NSDictionary *attrDict = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};
    self.numberOfLines = 0;
    CGSize newSize = [textStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrDict context:NULL].size;
    return newSize.height;
}

@end
