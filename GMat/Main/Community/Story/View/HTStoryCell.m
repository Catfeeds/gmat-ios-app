//
//  HTStoryCell.m
//  GMat
//
//  Created by hublot on 2017/8/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTStoryCell.h"
#import "HTStoryModel.h"

@interface HTStoryCell ()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *nicknameLabel;

@property (nonatomic, strong) UILabel *scoreDateLabel;

@end

@implementation HTStoryCell

- (void)didMoveToSuperview {
    [self addSubview:self.headImageView];
    [self addSubview:self.titleNameLabel];
    [self addSubview:self.nicknameLabel];
    [self addSubview:self.scoreDateLabel];
    [self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(- 15);
        make.width.mas_equalTo(self.headImageView.mas_height).multipliedBy(4.0 / 3.0);
    }];
    [self.nicknameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).offset(15);
        make.bottom.mas_equalTo(self.headImageView);
        make.right.mas_equalTo(self.scoreDateLabel.mas_left);
    }];
    [self.scoreDateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(- 15);
        make.centerY.mas_equalTo(self.nicknameLabel);
    }];
    [self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).offset(15);
        make.right.mas_equalTo(- 15);
        make.bottom.mas_lessThanOrEqualTo(self.nicknameLabel.mas_top).offset(- 20).priority(200);
        make.top.mas_equalTo(self.headImageView);
    }];
}

- (void)setModel:(HTStoryModel *)model row:(NSInteger)row {
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:GmatResourse(model.image1)] placeholderImage:HTPLACEHOLDERIMAGE];
    self.titleNameLabel.text = model.contenttitle;
    self.nicknameLabel.text = model.fullName;
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy.MM.dd";
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.contentinputtime.integerValue];
//    NSString *scoreDateString = [dateFormatter stringFromDate:date];
    self.scoreDateLabel.text = model.outTime;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
    }
    return _headImageView;
}

- (UILabel *)titleNameLabel {
    if (!_titleNameLabel) {
        _titleNameLabel = [[UILabel alloc] init];
        _titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
        _titleNameLabel.font = [UIFont systemFontOfSize:15];
        _titleNameLabel.numberOfLines = 0;
        [_titleNameLabel setContentHuggingPriority:100 forAxis:UILayoutConstraintAxisVertical];
        [_titleNameLabel setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisVertical];
    }
    return _titleNameLabel;
}

- (UILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
        _nicknameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _nicknameLabel;
}

- (UILabel *)scoreDateLabel {
    if (!_scoreDateLabel) {
        _scoreDateLabel = [[UILabel alloc] init];
        _scoreDateLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
        _scoreDateLabel.font = [UIFont systemFontOfSize:13];
        _scoreDateLabel.textAlignment = NSTextAlignmentRight;
        [_scoreDateLabel setContentHuggingPriority:100 forAxis:UILayoutConstraintAxisHorizontal];
        [_scoreDateLabel setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _scoreDateLabel;
}



@end
