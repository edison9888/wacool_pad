//
//  PhoneUtil.m
//  wacool_pad
//
//  Created by dengshengjin on 13-1-17.
//  Copyright (c) 2013年 wacool. All rights reserved.
//

#import "PhoneUtil.h"

@implementation PhoneUtil


+(BOOL)isUserInterfaceIdiomPhone
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){//iphone平台
        return true;
    } else { //pad平台
        return false;
    }
}

+ (NSString *)getCurrentIOSVersion
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    return [NSString stringWithFormat:@"iPhone OS %.1f",version];//精确到1位小数
}

+ (NSString *)getDeviceVersion
{
    NSString* platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (China, no WiFi possibly)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (AT+T)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (Other carrier)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (Other carrier)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod2,2"])   return @"iPod Touch 2.5G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G WiFi";
    if ([platform isEqualToString:@"iPad1,2"])   return @"iPad 1G 3G";
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 2G";
    
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    return platform;
}

+ (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

+ (NSString *)getOpenUDID
{
    NSString *openUDIDStr = [OpenUDID value];
    return openUDIDStr;
}

+ (NSString *)getMacAddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

+ (NSString *)getCurrentIpAddress
{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    return [NSString stringWithFormat:@"%s", ip_names[1]];
}

+ (CGFloat) getScreenWidth{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    return width;
}

+ (CGFloat) getScreenHeight{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat height = size.height;
    return height;
}


@end
