package anifire.core
{
   import anifire.event.SpeechPitchEvent;
   import anifire.util.UtilFlash;
   import anifire.util.UtilMath;
   import flash.display.MovieClip;
   
   public class GoMouth extends MovieClip
   {
      public var speechMouth:MovieClip;
      
      private var _speechMouthClip:MovieClip;
      
      public function GoMouth()
      {
         super();
         init();
      }
      
      private function get speechMouthClip() : MovieClip
      {
         if(!_speechMouthClip)
         {
            _speechMouthClip = UtilFlash.getInstance(this,"speechMouth");
         }
         return _speechMouthClip;
      }
      
      private function init() : void
      {
         reset();
         addEventListener(SpeechPitchEvent.PITCH,doPitch);
      }
      
      private function reset() : void
      {
         if(speechMouthClip)
         {
            speechMouthClip.visible = true;
            UtilFlash.stopFamilyAt(speechMouthClip,1);
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
         if(speechMouthClip)
         {
            UtilFlash.stopFamilyAt(speechMouthClip,param1);
         }
      }
   }
}

