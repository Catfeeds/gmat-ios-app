//
//  HTReportSingleFirstCell.m
//  GMat
//
//  Created by hublot on 16/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTReportSingleFirstCell.h"
#import "HTReportExerciseCircleView.h"
#import "HTReportLineTableView.h"
#import "HTReportModel.h"
#import "NSString+HTString.h"
#import <NSObject+HTTableRowHeight.h>

@interface HTReportSingleFirstCell ()

@property (nonatomic, strong) HTReportExerciseCircleView *rightPercentView;

@property (nonatomic, strong) HTReportExerciseCircleView *exerciseTimeView;

@property (nonatomic, strong) HTReportLineTableView *progressTableView;

@property (nonatomic, strong) UILabel *detailNameLabel;

@end

@implementation HTReportSingleFirstCell

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
	[self addSubview:self.rightPercentView];
	[self addSubview:self.exerciseTimeView];
	[self addSubview:self.progressTableView];
	[self addSubview:self.detailNameLabel];
	[self.detailNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(15);
		make.right.mas_equalTo(self).offset(- 15);
	}];
	[self.exerciseTimeView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(160);
		make.height.mas_equalTo(170);
		make.top.mas_equalTo(self);
		make.centerX.mas_equalTo(self).offset(- 100);
	}];
	[self.rightPercentView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(160);
		make.height.mas_equalTo(170);
		make.top.mas_equalTo(self);
		make.centerX.mas_equalTo(self).offset(100);
	}];
	[self.progressTableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(180);
		make.left.right.mas_equalTo(self);
	}];
}

- (void)setModel:(HTReportModel *)model row:(NSInteger)row {
	[self didMoveToSuperview];
	CGFloat circelViewHeight = 170;
	CGFloat tableHeight = 0;
	CGFloat detailLabelHeight = 0;
	
	Cr_Data *numberData = @[@"", model.sc_data, model.rc_data, model.cr_data, model.quant_data][self.reportStyle];
	NSArray *accDataArray = @[@[], model.sc_acc, model.rc_acc, model.cr_acc, model.quant_acc][self.reportStyle];
	self.rightPercentView.bottomDetailName = [NSString stringWithFormat:@"正确率:(%ld%%)", numberData.correctAll];
	self.rightPercentView.progress = numberData.correctAll / 100.0;
	if (numberData.averageTime <= 60) {
		self.exerciseTimeView.bottomDetailName = [NSString stringWithFormat:@"Pace:(%lds)", numberData.averageTime];
	} else {
		self.exerciseTimeView.bottomDetailName = [NSString stringWithFormat:@"Pace:(%ldm%lds)", numberData.averageTime / 60, numberData.averageTime % 60];
	}
	self.exerciseTimeView.progress = numberData.averageTime / 60.0;
	NSMutableArray *modelArray = [@[] mutableCopy];
	[accDataArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if (obj.count > 1) {
			NSDictionary *scDictionary = @{obj[0]:@([obj[1] integerValue] / 100.0)};
			[modelArray addObject:scDictionary];
		}
	}];
	self.progressTableView.modelArray = modelArray;
	tableHeight = self.progressTableView.ht_h;
	[self.progressTableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(tableHeight);
	}];
	
	NSString *reportString = @"";
	if (self.reportStyle == 1) {
		if (model.sc_data.correctAll >= 80) {
			reportString = @"该科掌握得非常好哦，一般，总分700分对于SC的正确率要求就是80%。与其他科目不同的是，SC的正确率越高，得高分的 概率就越大，所以千万不要让自己的正确率掉下来哦~";
		} else if (model.sc_data.correctAll >= 65) {
			reportString = @"该科掌握得还不错，只需要继续总结分析错题原因，熟练考点，提高正确率即可。";
		} else if (model.sc_data.correctAll >= 50) {
			reportString = @"这部分还需要继续努力呀，SC瓶颈区一般会处在正确率50%-60%左右，要想快速提高正确率，还需要总结分析错题原 因，熟练考点。";
		} else {
			reportString = @"这部分需要努力的地方还很多，建议系统学习所有知识点后，再次练习。";
		}
	} else if (self.reportStyle == 2) {
		if (model.rc_data.correctAll >= 60) {
			reportString = @"该科掌握不错，总分700分一般要求RC单篇正确率达到60%以上。若其他科目也能达到此水平，目标分数可以达到700+以上 了哦~";
		} else if (model.rc_data.correctAll >= 40) {
			reportString = @"该科掌握一般，RC正确率瓶颈一般会处在正确率40%左右，要想快速提高正确率，需要练习长难句，学习回文定位、快 速获取文章结构等做题方法。";
		} else {
			reportString = @"该科基本没掌握，建议系统学习所有知识点后，再次练习。";
		}
	} else if (self.reportStyle == 3) {
		if (model.cr_data.correctAll >= 70) {
			reportString = @"该科掌握得不错，总分700分一般要求CR正确率达到70%以上。继续保持这个正确率就可以了!";
		} else if (model.sc_data.correctAll >= 50) {
			reportString = @"该科掌握一般，CR正确率瓶颈一般会处在正确率50%左右，要想快速提高正确率，需要纠正解题思维模式，熟练解题方 法。";
		} else {
			reportString = @"该科基本没掌握，建议系统学习所有知识点后，再次练习。";
		}
	} else if (self.reportStyle == 4) {
		if (model.quant_data.correctAll >= 90) {
			reportString = @"该科掌握不错，总分700分一般要求QUANT正确率达到90%以上。若其他科目也能达到此水平，目标分数可以达到700+以上 了哦~";
		} else if (model.sc_data.correctAll >= 80) {
			reportString = @"该科掌握一般，QUANT正确率比较容易提升，建议熟悉数学词汇，熟悉数学题型，加强题意理解，提高正确率。";
		} else if (model.sc_data.correctAll >= 60) {
			reportString = @"该科掌握较差，需要针对性的学习相关知识点，熟悉考点，再做题，提高正确率。";
		} else {
			reportString = @"该科基本没掌握，建议系统学习所有知识点后，再次练习。";
		}
	}
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"*%@", reportString] attributes:nil];
	[attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(0, 1)];
	self.detailNameLabel.attributedText = attributedString;
    detailLabelHeight = [self.detailNameLabel.text ht_stringHeightWithWidth:HTSCREENWIDTH - 30 font:self.detailNameLabel.font textView:nil] + 20;
	[self.detailNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self).offset(circelViewHeight + tableHeight + 20);
	}];
    CGFloat modelHeight = circelViewHeight + tableHeight + detailLabelHeight;
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (HTReportExerciseCircleView *)rightPercentView {
	if (!_rightPercentView) {
		_rightPercentView = [[HTReportExerciseCircleView alloc] initWithFrame:CGRectMake(0, 0, 160, 170)];
		_rightPercentView.tintColor = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
	}
 	return _rightPercentView;
}

- (HTReportExerciseCircleView *)exerciseTimeView {
	if (!_exerciseTimeView) {
		_exerciseTimeView = [[HTReportExerciseCircleView alloc] initWithFrame:CGRectMake(0, 0, 160, 170)];
		_exerciseTimeView.tintColor = [UIColor orangeColor];
	}
	return _exerciseTimeView;
}

- (HTReportLineTableView *)progressTableView {
	if (!_progressTableView) {
		_progressTableView = [[HTReportLineTableView alloc] init];
	}
	return _progressTableView;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
		_detailNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_detailNameLabel.font = [UIFont systemFontOfSize:14];
		_detailNameLabel.numberOfLines = 0;
	}
	return _detailNameLabel;
}

@end
