//
//  HTCourseCellHeaderView.m
//  GMat
//
//  Created by hublot on 17/4/18.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCourseCellHeaderView.h"
#import <UIButton+HTButtonCategory.h>

@interface HTCourseCellHeaderView ()

@property (nonatomic, strong) UIButton *headerLeftButton;

@property (nonatomic, strong) UIButton *headerRightButton;

@property (nonatomic, strong) UIView *separatorLineView;

@end

@implementation HTCourseCellHeaderView

- (void)setHeaderRightDetailTapedBlock:(void (^)(void))headerRightDetailTapedBlock {
	_headerRightDetailTapedBlock = headerRightDetailTapedBlock;
	if (_headerRightDetailTapedBlock) {
		self.headerRightButton.hidden = false;
        [self.headerRightButton ht_whenTap:^(UIView *view) {
            _headerRightDetailTapedBlock();
        }];
	}
}


- (void)setModelArray:(NSMutableArray *)modelArray section:(NSInteger)section {
	NSString *headerLeftTitle = @"";
	UIImage *headerLeftImage = nil;
	if (section == 0) {
		headerLeftTitle = @"免费试听课程";
		headerLeftImage = [UIImage imageNamed:@"CourseTryListenHeaderLeft"];
	}/* else if (section == 2) {
		headerLeftTitle = @"入门课程";
		headerLeftImage = [UIImage imageNamed:@"CourseBeginHeaderLeft"];
	}*/ else if (section == 2) {
		headerLeftTitle = @"专家讲师";
		headerLeftImage = [UIImage imageNamed:@"CourseTeacherHeaderLeft"];
	} else if (section == 3) {
		headerLeftTitle = @"本月热门课程";
		headerLeftImage = [UIImage imageNamed:@"CourseHotHeaderLeft"];
	} else if (section == 4) {
		headerLeftTitle = @"直播课程";
		headerLeftImage = [UIImage imageNamed:@"CourseBeginHeaderLeft"];
	} else if (section == 5) {
		headerLeftTitle = @"视频课程";
		headerLeftImage = [UIImage imageNamed:@"CourseBeginHeaderLeft"];
	}else if (section == 6) {
		headerLeftTitle = @"面授课程";
		headerLeftImage = [UIImage imageNamed:@"CourseBeginHeaderLeft"];
	}
	
	[self.headerLeftButton setTitle:headerLeftTitle forState:UIControlStateNormal];
	[self.headerLeftButton setImage:[headerLeftImage ht_resetSize:CGSizeMake(15, 15)] forState:UIControlStateNormal];
}

- (void)didMoveToSuperview {
	self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.headerLeftButton];
    [self addSubview:self.headerRightButton];
    [self addSubview:self.separatorLineView];
	[self.headerLeftButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionHorizontal imageViewToTitleLabelSpeceOffset:5];
    [self.headerLeftButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(self);
    }];
    [self.headerRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(- 10);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(self);
    }];
    [self.separatorLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
    }];
}

- (UIButton *)headerLeftButton {
    if (!_headerLeftButton) {
        _headerLeftButton = [[UIButton alloc] init];
        [_headerLeftButton setTitleColor:[UIColor ht_colorStyle:HTColorStylePrimaryTitle] forState:UIControlStateNormal];
        _headerLeftButton.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _headerLeftButton;
}

- (UIButton *)headerRightButton {
    if (!_headerRightButton) {
        _headerRightButton = [[UIButton alloc] init];
        [_headerRightButton setTitle:@"查看更多 >" forState:UIControlStateNormal];
        [_headerRightButton setTitleColor:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle] forState:UIControlStateNormal];
        _headerRightButton.titleLabel.font = [UIFont systemFontOfSize:13];
		_headerRightButton.hidden = true;
    }
    return _headerRightButton;
}

- (UIView *)separatorLineView {
    if (!_separatorLineView) {
        _separatorLineView = [[UIView alloc] init];
        _separatorLineView.backgroundColor = [UIColor ht_colorStyle:HTColorStylePrimarySeparate];
    }
    return _separatorLineView;
}

@end
