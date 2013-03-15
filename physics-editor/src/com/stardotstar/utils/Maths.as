package com.stardotstar.utils
{
	public class Maths
	{
		public function Maths()
		{
		}
		
		public static function randomIntBetween(a:int, b:int):int
		{
			return Math.round(a + Math.random()*(b-a));
		}
		
		public static function map(v:Number, a:Number, b:Number, x:Number = 0, y:Number = 1):Number {
			return (v == a) ? x : (v - a) * (y - x) / (b - a) + x;
		}
		
		public static function constrain(amt:int, low:int, high:int):int {
			return (amt < low) ? low : ((amt > high) ? high : amt);
		}
	}
}