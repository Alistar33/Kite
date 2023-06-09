integer gLHandle;
integer gChannel=-8;
key     gHitched;
float   gGravity = -0.05;
float   gStringLen = 4; // actually string length squared.
float   gStringTension = 1.0;
float   gMaxVel = 0.5; //square of the maximum velocity
float   gMaxVelSnap = 0.6; //the lower this is the snappier the air resistance.
                            // bad things will happen if it is above 1.0
float   gTimerFrequency = 0.5;

float   gRotStrength =  3.00;
float   gRotDamping =   0.5;


default
{
    state_entry()
    {
        llSetPhysicsMaterial(15,gGravity,0.5,0.5,1000.0);
        llSetStatus(STATUS_PHYSICS,FALSE);
        
        llParticleSystem([]);
    }
    on_rez(integer i)
    {
        gChannel=i;
        gLHandle = llListen(gChannel,"",NULL_KEY,"HITCH");
    }
    touch_start(integer i)
    {
        llApplyImpulse(-llDetectedTouchNormal(0)*4.5,FALSE);
    }
    listen(integer Channel,string Name,key ID,string Text)
    {   if(Text=="HITCH")
        {
            gHitched=ID;
            llSetStatus(STATUS_PHYSICS|STATUS_BLOCK_GRAB_OBJECT,TRUE);
            llSetTimerEvent(gTimerFrequency);
            llListenRemove(gLHandle);
            gLHandle = llListen(gChannel,"",ID,"DIE");
            llRotLookAt(ZERO_ROTATION,gRotStrength,gRotDamping);
            llParticleSystem(
            [
                PSYS_PART_FLAGS,
                    PSYS_PART_RIBBON_MASK | PSYS_PART_TARGET_POS_MASK,
                PSYS_SRC_PATTERN,
                    PSYS_SRC_PATTERN_DROP,
                PSYS_SRC_TEXTURE,
                    TEXTURE_BLANK,
                PSYS_SRC_TARGET_KEY,
                    gHitched,
                PSYS_PART_START_SCALE,
                    <0.06,0.06,0.0>,
                PSYS_PART_MAX_AGE,
                    2.0
                
            ]);
        }else if(Text=="DIE")
        {
             llDie();
        }
    }
    timer()
    {
        list det = llGetObjectDetails(gHitched,[OBJECT_POS]);
        vector posTo = llList2Vector(det,0);
        vector pos = llGetPos();
        vector diff = posTo-pos;
        if(diff*diff > gStringLen)
        {   /*
            llMoveToTarget(pos,1.0);
            llSleep(0.1);
            llStopMoveToTarget();
            */
            //llApplyImpulse(diff*0.4,0);
            llSetForce(diff* gStringTension ,FALSE);
            llSetTorque(-diff,FALSE);
            //llSay(0,(string)llGetForce());
            llLookAt((2.0*pos)-posTo,gRotStrength,gRotDamping);
        } else
        {
            llSetForce(ZERO_VECTOR,FALSE);
            llRotLookAt(ZERO_ROTATION,gRotStrength,gRotDamping);
        }
        vector vel = llGetVel();
        if(vel*vel>gMaxVel)
        {
            llSetVelocity(vel*gMaxVelSnap,FALSE);
        }
    }

}
