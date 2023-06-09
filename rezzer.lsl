//Change on line 12 "Kite" to your object name. Add your Kite object inside the rezzer object.

integer gChannel=-8;
default
{
    attach(key ID)
    {   if(ID==NULL_KEY)
        {
            llShout(gChannel,"DIE");
        }else
        {
            llRezAtRoot("Kite",
                llGetPos()+<0,0,0.5>,ZERO_VECTOR,ZERO_ROTATION,gChannel);
        }
    }
    object_rez(key ID)
    {
        llRegionSayTo(ID,gChannel,"HITCH");
    }
    /*
    touch_start(integer total_number)
    {
        llRegionSay(gChannel,"HITCH"); //testing only
    }*/
}
