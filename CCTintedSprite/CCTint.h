//
//  CCTint.h
//
//  Copyright (c) 2013 Davor Bauk. All rights reserved.
//

#ifdef __cplusplus
extern "C" {
#endif
    
    /** RGBA Tint composed of a color multiplier and color offset
     pixels are tinted according to the following function:
     originalColor * multiplier + offset
     */
    typedef struct _ccTint4F
    {
        ccColor4F multiplier;
        ccColor4F offset;
    } ccTint4F;
    
    //! helper macro that creates an ccTint4F type
    static inline ccTint4F
    cct4f(const GLfloat rM, const GLfloat gM, const GLfloat bM, const GLfloat oM, const GLfloat rO, const GLfloat gO, const GLfloat bO, const GLfloat oO)
    {
        ccTint4F t = {{rM, gM, bM, oM},{rO,gO,bO,oO}};
        return t;
    }
    static const ccTint4F cctDEFAULT = {{1,1,1,1},{0,0,0,0}};
    static const ccTint4F cctWHITE = {{0,0,0,1},{1,1,1,0}};
    static const ccTint4F cctBLACK = {{0,0,0,1},{0,0,0,0}};
    static const ccTint4F cctINVERTED = {{-1,-1,-1,1},{1,1,1,0}};
    
    
#ifdef __cplusplus
}
#endif


#pragma mark - CCRGBATintProtocol

/// CC RGBATint protocol
@protocol CCRGBATintProtocol <NSObject>
/** sets Tint
 */
-(void) setTint:(ccTint4F)tint;
/** returns the tint
 */
-(ccTint4F) tint;

@end


