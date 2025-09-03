package anifire.core
{
   import anifire.event.SpeechPitchEvent;
   import anifire.util.UtilMath;
   import flash.display.MovieClip;
   
   public class GoMouth extends MovieClip
   {
      public var speechMouth:MovieClip;
      
      public function GoMouth()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         reset();
         addEventListener(SpeechPitchEvent.PITCH,doPitch);
      }
      
      private function reset() : void
      {
         if(speechMouth)
         {
            speechMouth.visible = true;
            speechMouth.gotoAndStop(1);
            if(speechMouth.theColor_ccMouthLip)
            {
               speechMouth.theColor_ccMouthLip.gotoAndStop(1);
            }
            if(speechMouth.theColor_ccSkinColor)
            {
               speechMouth.theColor_ccSkinColor.gotoAndStop(1);
            }
         }
      }
      
      private function doPitch(param1:SpeechPitchEvent) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = Math.floor(UtilMath.boundaryCheck(param1.value / 1000,0.1,5) * 20);
         doSpeech(_loc2_);
      }
      
      private function doSpeech(param1:Number) : void
      {
         if(speechMouth)
         {
            speechMouth.gotoAndStop(param1);
            if(speechMouth.theColor_ccMouthLip)
            {
               speechMouth.theColor_ccMouthLip.gotoAndStop(param1);
            }
            if(speechMouth.theColor_ccSkinColor)
            {
               speechMouth.theColor_ccSkinColor.gotoAndStop(param1);
            }
         }
      }
   }
}

