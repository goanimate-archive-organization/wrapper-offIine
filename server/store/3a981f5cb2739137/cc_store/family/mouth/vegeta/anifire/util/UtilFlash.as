package anifire.util
{
   import flash.display.MovieClip;
   
   public class UtilFlash
   {
      public function UtilFlash()
      {
         super();
      }
      
      public static function transverseFamily(param1:MovieClip, param2:Function, param3:Array = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         param2(param1);
         if(param1 is MovieClip)
         {
            _loc6_ = MovieClip(param1);
            _loc4_ = 0;
            while(_loc4_ < _loc6_.numChildren)
            {
               if(_loc6_.getChildAt(_loc4_) is MovieClip)
               {
                  _loc5_ = MovieClip(_loc6_.getChildAt(_loc4_));
                  if(!(Boolean(param3) && Boolean(_loc5_) && param3.indexOf(_loc5_.name) > -1))
                  {
                     UtilFlash.transverseFamily(_loc5_,param2,param3);
                  }
               }
               _loc4_++;
            }
         }
      }
      
      public static function stopFamilyAt(param1:MovieClip, param2:Number) : void
      {
         var n:Number = NaN;
         var treatment:Function = null;
         var iObj:MovieClip = param1;
         n = param2;
         treatment = function(param1:MovieClip):void
         {
            var _loc2_:MovieClip = null;
            if(param1 is MovieClip)
            {
               _loc2_ = MovieClip(param1);
               _loc2_.gotoAndStop(n);
            }
         };
         UtilFlash.transverseFamily(iObj,treatment);
      }
      
      public static function getInstance(param1:MovieClip, param2:String) : MovieClip
      {
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         if(param1.name == param2)
         {
            return param1;
         }
         _loc5_ = 0;
         while(_loc5_ < param1.numChildren)
         {
            if(param1.getChildAt(_loc5_) is MovieClip)
            {
               _loc4_ = MovieClip(param1.getChildAt(_loc5_));
               _loc3_ = UtilFlash.getInstance(_loc4_,param2);
               if(_loc3_ != null)
               {
                  return _loc3_;
               }
            }
            _loc5_++;
         }
         return null;
      }
   }
}

