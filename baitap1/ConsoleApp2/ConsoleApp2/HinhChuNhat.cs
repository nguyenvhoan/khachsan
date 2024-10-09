using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp2
{
    public class HinhChuNhat
    {
        public Diem DiemTrenBenTrai { get; set; }
        public Diem DiemDuoiBenPhai { get; set; }

        public HinhChuNhat(Diem diemTrenBenTrai, Diem diemDuoiBenPhai)
        {
            DiemTrenBenTrai = diemTrenBenTrai;
            DiemDuoiBenPhai = diemDuoiBenPhai;
        }

        public double TinhDienTich()
        {
            double width = DiemDuoiBenPhai.HoanhDo - DiemTrenBenTrai.HoanhDo;
            double height = DiemTrenBenTrai.TungDo - DiemDuoiBenPhai.TungDo;
            return Math.Abs(width * height);
        }

        public bool GiaoNhau(HinhChuNhat hinhKhac)
        {
            return !(DiemDuoiBenPhai.HoanhDo < hinhKhac.DiemTrenBenTrai.HoanhDo ||
                     DiemTrenBenTrai.HoanhDo > hinhKhac.DiemDuoiBenPhai.HoanhDo ||
                     DiemDuoiBenPhai.TungDo > hinhKhac.DiemTrenBenTrai.TungDo ||
                     DiemTrenBenTrai.TungDo < hinhKhac.DiemDuoiBenPhai.TungDo);
        }
    }
}
