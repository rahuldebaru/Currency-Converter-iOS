//
//  NSString+Additions.m
//  Sample
//
//  Created by Aru, Rahul on 2/10/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (BOOL) isPalindrome
{
    if (!self.length) return NO;
    if (self.length == 1) return YES;
    for(unsigned i = 0; i < self.length / 2; ++i)
        if ([self characterAtIndex:i] != [self characterAtIndex:self.length - i - 1])
            return NO;
    return YES;
}

- (BOOL) isDecimal
{
    NSString *regex = @"^([0-9]*|[0-9]*[.][0-9]*)$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [test evaluateWithObject:self];
    return isValid;
}

- (BOOL) isNumeric
{
    NSString *regex = @"^([0-9]*)";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [test evaluateWithObject:self];
    return isValid;
}

// A utility function to check if num has all 9s
- (BOOL) areAll9s
{
    NSString *regex = @"^([9]*)";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [test evaluateWithObject:self];
    return isValid;
}

- (NSString*) findNextPalindrome
{
    // All the digits are 9, simply output 1 followed by n-1 0's followed by 1.
    if([self areAll9s])
    {
        NSMutableString* result = [NSMutableString stringWithFormat:@"1"];
        for(int i = 1; i < self.length; i++ )
            [result appendString:@"0"];
        [result appendString:@"1"];
        return result;
    }
    
    // Other cases
    return [self generateNextPalindromeUtilFound];
}

- (NSString*) generateNextPalindromeUtilFound
{
    char *str = (char *)[self UTF8String];
    long n = self.length;
    int* num = malloc(sizeof(int)*n);
    for(int count=0; count<n; count++)
    {
        num[count] = (int)(str[count] - '0');
    }
    
    long mid = n/2;
    bool leftsmaller = false;
    long i = mid - 1;
    long j = (n % 2)? mid + 1 : mid;
    while (i >= 0 && num[i] == num[j])
        i--,j++;
    if ( i < 0 || num[i] < num[j])
        leftsmaller = true;
    while (i >= 0)
    {
        num[j] = num[i];
        j++;
        i--;
    }
    
    if (leftsmaller == true)
    {
        int carry = 1;
        i = mid - 1;
        if (n%2 == 1)
        {
            num[mid] += carry;
            carry = num[mid] / 10;
            num[mid] %= 10;
            j = mid + 1;
        }
        else
            j = mid;

        while (i >= 0)
        {
            num[i] += carry;
            carry = num[i] / 10;
            num[i] %= 10;
            num[j++] = num[i--];
        }
    }
    
    for(int count=0; count<n; count++)
    {
        str[count] = (char)(num[count] + '0');
    }
    
    NSString* result = [NSString stringWithUTF8String:str];
    return result;
}


@end
