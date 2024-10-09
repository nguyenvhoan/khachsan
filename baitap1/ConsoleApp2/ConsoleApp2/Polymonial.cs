using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp2
{
    public class Polymonial
    {
        private int n;
        private List<int> a;
        public Polymonial(int n, List<int> a)
        {
            if (a.Count() != n + 1)
            {
                throw new ArgumentException("invalid data");

            }
            this.n = n;
            this.a = a;

        }
        public int Cal(double x)
        {
            int result = 0;
            for (int i = 0; i <= this.n; i++)
            {
                result += (int)(a[i] * Math.Pow(x, i));
            }
            return result;
        }
    }
}
