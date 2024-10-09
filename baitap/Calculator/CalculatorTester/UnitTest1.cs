using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using Calculator;

namespace CalculatorTester
{
    [TestClass]
    public class UnitTest1
    {
        public TestContext TestContext { get; set; }
        private Calculation cal;
        [TestInitialize]
        public void SetUp()
        {
            this.cal = new Calculation(10, 5);
        }
        [TestMethod]
        public void TestAddOperator()
        {
            Assert.AreEqual(cal.Execute("+"), 15);
        }
        [TestMethod]
        public void TestSubOperator()
        {
            Assert.AreEqual(cal.Execute("-"), 5);
        }
        [TestMethod]

        public void TestMulOperator()
        {
            Assert.AreEqual(cal.Execute("*"), 50);
        }
        [TestMethod]

        public void TestDivOperator()
        {
            Assert.AreEqual(cal.Execute("/"), 2);
        }
        [TestMethod]
        public void TestDivRound()
        {
            Calculation c = new Calculation(5, 3);
            Assert.AreEqual(c.Execute("/"), 2);
        }
        
        [TestMethod]
        [ExpectedException(typeof(DivideByZeroException))]
        public void TestDivByZero()
        {
            Calculation c = new Calculation(2, 0);
            c.Execute("/");
        }
        [DataSource("Microsoft.VisualStudio.TestTools.DataSource.CSV",
            @"D:\nguyenhoan\baitap\Calculator\Calculator\TestData.csv","TestData#csv",DataAccessMethod.Sequential)]
        [TestMethod]
        public void TestWithDataSource()
        {
            int a = int.Parse(TestContext.DataRow[0].ToString());
            int b = int.Parse(TestContext.DataRow[1].ToString());
            int expected = int.Parse(TestContext.DataRow[2].ToString());
            Calculation c = new Calculation(a, b);
            int actual = c.Execute("+");
            Assert.AreEqual(expected, actual);
        }
    }
}
