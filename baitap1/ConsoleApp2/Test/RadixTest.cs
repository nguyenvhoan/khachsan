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
    public class RadixTests
    {
        [TestMethod]
        public void HeSo2()
        {
            Radix radix = new Radix(10);
            Assert.AreEqual("1010", radix.ConvertDecimalToAnother(2));
        }

        [TestMethod]
        public void HeSo8()
        {
            Radix radix = new Radix(10);
            Assert.AreEqual("12", radix.ConvertDecimalToAnother(8));
        }

        [TestMethod]
        public void HeSo16()
        {
            Radix radix = new Radix(255);
            Assert.AreEqual("FF", radix.ConvertDecimalToAnother(16));
        }

        [TestMethod]
        public void HeSo5()
        {
            Radix radix = new Radix(10);
            Assert.AreEqual("20", radix.ConvertDecimalToAnother(5));
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException), "Incorrect Value")]
        public void HeSoAm()

        {
            Assert.ThrowsException<ArgumentException>(() =>
            {
                Radix radix = new Radix(-1); 
            });
            
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException), "Invalid Radix")]
        public void NhoHon2()
        {
            Assert.ThrowsException<ArgumentException>(() =>
            {
                Radix radix = new Radix(10);
                radix.ConvertDecimalToAnother(1);
            });
            
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentException), "Invalid Radix")]
        public void LonHon16()
        {
            Assert.ThrowsException<ArgumentException>(() =>
            {
                Radix radix = new Radix(10);
                radix.ConvertDecimalToAnother(17);
            });
        }
    }
}
