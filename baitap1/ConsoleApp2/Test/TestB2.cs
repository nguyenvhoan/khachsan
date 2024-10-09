using ConsoleApp2;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Test
{
    [TestClass]
    public class TestB2
    {
        private Polymonial pol;
        private List<int> a;
        [TestInitialize]
        public void setUp()
        {
            a =new List<int>{ 1,2,3};
        }
        [TestMethod]
        public void NhapChinhXac()
        {
            Polymonial poly = new Polymonial(2, a);
            Assert.AreEqual(1 + 2 * 2 + 3 * Math.Pow(2, 2), poly.Cal(2)); 
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException), "Invalid Data")]
        public void BacAm()
        {
            Assert.ThrowsException<ArgumentException>(() =>
            {
                Polymonial poly = new Polymonial(-1, a);
            });
            
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException), "Invalid Data")]
        public void NhapKhDuNCong1()
        {
            Assert.ThrowsException<ArgumentException>(() =>
            {
                Polymonial poly = new Polymonial(4, a);
            });
        }           

        
    }
}
