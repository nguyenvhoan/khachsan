using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp2
{
    public class Diem
    {
        public double HoanhDo { get; set; }
        public double TungDo { get; set; }

        public Diem(double hoanhDo, double tungDo)
        {
            HoanhDo = hoanhDo;
            TungDo = tungDo;
        }
    }
}
