﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp2
{
    internal class Program
    {
        public static double Power(double x, int n)
        {
            if (n == 0)
                return 1.0;
            else if (n > 0)
                return x * Power(x, n - 1); 
            else
                return Power(x, n + 1) / x; 
        }
        static void Main(string[] args)
        {
            Console.Write(Power(-2, 0));
        }
    }
}
