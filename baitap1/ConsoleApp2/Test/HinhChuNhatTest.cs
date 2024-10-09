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
    public class HinhChuNhatTests
    {
        [TestMethod]
        public void TestTinhDienTich()
        {
            Diem diem1 = new Diem(1, 5);
            Diem diem2 = new Diem(4, 2);
            HinhChuNhat hinhChuNhat = new HinhChuNhat(diem1, diem2);

            double expectedArea = 9; 
            Assert.AreEqual(expectedArea, hinhChuNhat.TinhDienTich());
        }

        [TestMethod]
        public void TestGiaoNhau()
        {
            Diem diem1 = new Diem(1, 5);
            Diem diem2 = new Diem(4, 2);
            HinhChuNhat hinh1 = new HinhChuNhat(diem1, diem2);

            Diem diem3 = new Diem(3, 6);
            Diem diem4 = new Diem(5, 1);
            HinhChuNhat hinh2 = new HinhChuNhat(diem3, diem4);

            Assert.IsTrue(hinh1.GiaoNhau(hinh2)); 
        }

        [TestMethod]
        public void TestGiaoNhau_NoOverlap()
        {
            Diem diem1 = new Diem(1, 5);
            Diem diem2 = new Diem(4, 2);
            HinhChuNhat hinh1 = new HinhChuNhat(diem1, diem2);

            Diem diem3 = new Diem(5, 6);
            Diem diem4 = new Diem(7, 1);
            HinhChuNhat hinh2 = new HinhChuNhat(diem3, diem4);

            Assert.IsFalse(hinh1.GiaoNhau(hinh2));
        }

        [TestMethod]
        public void TestGiaoNhau_Touching()
        {
            Diem diem1 = new Diem(1, 5);
            Diem diem2 = new Diem(4, 2);
            HinhChuNhat hinh1 = new HinhChuNhat(diem1, diem2);

            Diem diem3 = new Diem(4, 5);
            Diem diem4 = new Diem(6, 1);
            HinhChuNhat hinh2 = new HinhChuNhat(diem3, diem4);

            Assert.IsTrue(hinh1.GiaoNhau(hinh2)); 
        }
    }
}
