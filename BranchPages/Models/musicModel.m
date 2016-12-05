//
//  musicModel.m
//  NoScreenAudio
//
//  Created by S3Graphic on 15/12/8.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import "musicModel.h"

@implementation musicModel

-(instancetype)initWithDictionary:(NSDictionary *)Dictionary{
    self = [super init];
    if (self) {
        self.songName = [Dictionary objectForKey:@"title"];
        self.singerName = [Dictionary objectForKey:@"artist"];
        self.songAlbum = [Dictionary objectForKey:@"album"];
        self.musicID = (int)[Dictionary objectForKey:@"id"];
        self.songIndex = [Dictionary objectForKey:@"index"];
        self.songPhoto = [Dictionary objectForKey:@"photo"];
        self.songURL = [Dictionary objectForKey:@"url"];
        
//        album = "\U7ec8\U8eab\U4f34\U4fa3";
//        artist = "\U738b\U83f2";
//        id = 0;
//        index = 17;
//        photo = "http://imgcache.qq.com/music/photo/album_300/46/300_albumpic_1146_0.jpg";
//        "play_state" = 1;
//        title = "\U7ed9\U81ea\U5df1\U7684\U60c5\U4e66";
//        url = "http://stream16.qqmusic.qq.com/132191320.mp3";
    }
    return self;
}

- (instancetype)initWithSongName:(NSString *)songName singerName:(NSString *)singerName musicID:(int) musicID{
    self = [super init];
    if (self) {
        _songName = songName;
        _singerName = singerName;
        _musicID = musicID;
    }
    return self;
}
- (instancetype)initWithSongName:(NSString *)songName singerName:(NSString *)singerName{
    self = [super init];
    if (self) {
        _songName = songName;
        _singerName = singerName;
    }
    return self;
}
@end
