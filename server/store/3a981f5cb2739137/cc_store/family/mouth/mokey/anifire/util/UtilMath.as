package anifire.util
{
   public class UtilMath
   {
      public function UtilMath()
      {
         super();
      }
      
      public static function boundaryCheck(param1:Number, param2:Number = -9999999, param3:Number = 9999999) : Number
      {
         if(param1 < param2)
         {
            return param2;
         }
         if(param1 > param3)
         {
            return param3;
         }
         return param1;
      }
   }
}

