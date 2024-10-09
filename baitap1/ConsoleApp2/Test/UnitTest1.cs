using ConsoleApp2;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;

namespace Test
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void Nlonhon0()
        {
            Assert.AreEqual(8.0, Bai1.Power(2.0, 3)); // 2^3 = 8
        }
        [TestMethod]
        public void Nbang0()
        {
            Assert.AreEqual(1.0, Bai1.Power(2.0, 0)); // 2^3 = 8
        }

        [TestMethod]
        public void Nnhohon0()
        {
            Assert.AreEqual(0.25, Bai1.Power(2.0, -2)); // 2^-2 = 1/4
        }

        
    }
}
