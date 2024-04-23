use QuanLyChuyenBay
go
select*
from LOAIMB
--1. Cho biết lương trung bình của các nhân viên không phải là phi công.
select LOAINV,count(*) as SoLuongNV,sum(luong) as LuongTB,avg(luong) as Luong_Trung_Binh
from NHANVIEN
where loainv='0'
group by LOAINV


--2. Cho biết mức lương trung bình của các phi công.
select LOAINV,count(*) as SoLuongNV,sum(luong) as LuongTB,avg(luong) as Luong_Trung_Binh
from NHANVIEN
where loainv='1'
group by LOAINV
--3. Cho biết số lượng chuyến bay xuất phát từ sân bay MIA vào ngày 11/01/2000.
select SBDI,count(*) as SoLuongCB,NGAYDI
from ChuyenBay cb join LichBay lb on cb.MACB = lb.MACB
where SBDI = 'MIA' and NGAYDI='11-01-2000'
group by SBDI,NGAYDI
--Bài 5: Ngôn ngữ SQL (DML) – Truy vấn dữ liệu thống kê

--Khoa CNTT – Trường ĐH Công Nghệ Sài Gòn Trang 77
--4. Với mỗi sân bay (SBDEN), cho biết số lượng chuyến bay hạ cánh xuống sân
--bay đó. Kết quả được sắp xếp theo thứ tự tăng dần của sân bay đến.
select SBDEN,count(*) as SoLuongCB
from CHUYENBAY cb join LICHBAY lb on cb.macb = lb.macb
group by SBDEN 
order by SoLuongCB asc
--5. Với các sân bay (SBDI) MIA, ORD, SLC, BOS, cho biết số lượng chuyến bay
--xuất phát theo từng ngày. Xuất ra mã sân bay đi, ngày và số lượng.
select cb.macb,SBDI,count(*) as SoLuongCB, NGAYDI
from ChuyenBay cb join LichBay lb on cb.macb = lb.macb
where SBDI<>'DFW' and SBDI<>'CDG' and SBDI<>'DCA'
group by SBDI,NGAYDI,cb.macb

--6. Với mỗi lịch bay, cho biết mã chuyến bay, ngày đi cùng với số lượng nhân
--viên không phải là phi công của chuyến bay đó.

--cach 1
select lb.MACB,lb.NGAYDI,count(nv.manv) as SoLuongNV
from LICHBAY lb join PHANCONG pc on pc.MACB = lb.macb
			join NHANVIEN nv on pc.MANV = nv.manv
where loainv='0'
group by lb.macb,lb.ngaydi,loainv

--cach 2		
select MACB,NGAYDI,count(*) SLNV
from PHANCONG pc join NHANVIEN nv on pc.manv=nv.manv
where LOAINV='0'
group by MACB,NGAYDI
--7. Với mỗi chuyến bay, cho biết mã chuyến bay, ngày đi, cùng với số lượng hành
--khách đã đặt chỗ của chuyến bay đó, sắp theo thứ tự giảm dần của số lượng.
select lb.macb,dc.ngaydi, count(makh) as SoLuongHK
from DATCHO dc join LichBay lb on dc.MACB = lb.MACB			 
group by lb.macb,dc.ngaydi
order by SoLuongHK desc

--8. Với mỗi chuyến bay, cho biết mã chuyến bay, ngày đi, tổng lương của phi hành
--đoàn (các nhân viên được phân công trong chuyến bay), sắp xếp theo thứ tự
--tăng dần của tổng lương.
select macb,ngaydi,sum(luong) as TongLuong
from NhanVien nv join PHANCONG pc on nv.MANV = pc.MANV
group by macb,ngaydi
order by TongLuong asc
--9. Với mỗi loại máy bay, cho biết số lượng chuyến bay đã bay trên loại máy bay
--đó hạ cánh xuống sân bay ORD. Xuất ra mã loại máy bay, số lượng chuyến
--bay.
select mb.MALOAI,SBDEN,count(*) as SoLuongC
from ChuyenBay cb join LichBay lb on cb.macb = lb.macb
				  join MAYBAY mb on mb.SOHIEU = lb.SOHIEU
where SBDEN = 'ORD'
group by mb.maloai,sbden


--10. Cho biết sân bay (SBDI) và số lượng chuyến bay có nhiều hơn 2 chuyến bay
--xuất phát trong khoảng 10 giờ đến 22 giờ.
select sbdi,count(*) as SLCB
from CHUYENBAY
where datepart(hh,GIODI) between 10 and 22
group by sbdi
having count(*) > 2
--11. Cho biết tên phi công được phân công vào ít nhất 2 chuyến bay trong cùng một
--ngày.
select TEN, NGAYDI
from NHANVIEN nv join PHANCONG pc on nv.MANV=pc.MANV
group by TEN,NGAYDI
having count(*)>=2
--12. Cho biết mã chuyến bay và ngày đi của những chuyến bay có ít hơn 3 hành
--khách đặt chỗ.
select dc.MACB,lb.NGAYDI 
from LICHBAY lb join DATCHO dc on lb.MACB=dc.MACB
group by dc.MACB,lb.NGAYDI
having count (MAKH)<3
--13. Cho biết số hiệu máy bay và loại máy bay mà phi công có mã 1001 được phân
--công lái trên 2 lần.
select SOHIEU,maloai
from LICHBAY lb join PHANCONG pc on lb.macb = pc.macb
where manv='1001'
group by sohieu,maloai
having count(*)>=2
--14. Với mỗi hãng sản xuất, cho biết số lượng loại máy bay mà hãng đó đã sản xuất.
--Xuất ra hãng sản xuất và số lượng.
select count(*) as SoLuong,HANGSX
from LOAIMB join MAYBAY on LOAIMB.MALOAI = MAYBAY.MALOAI
group by HANGSX

--15. Với mỗi loại nhân viên có tổng lương trên 600000, cho biết số lượng nhân viên
--trong từng loại nhân viên đó. xuất loại nhân viên, tổng lương và số lượng nhân
--viên tương ứng.
select loainv,sum(luong) as TongLuong, count(*) as SoLuongNV
from NHANVIEN
where luong > 600000
group by loainv
--16. Với mỗi chuyến bay có trên 3 nhân viên, cho biết mã chuyến bay, và số lượng
--khách hàng đã đặt chỗ trên chuyến bay đó.
select cb.MACB, Count (dc.MAKH) as SLKH
from CHUYENBAY cb
join DatCho dc on cb.MACB = dc.MACB
Group by cb.MACB
having count (cb.MACB) > 3
--17. Với mỗi sân bay đi (SBDI), cho biết tổng số chuyến bay cất cánh trong quí 4
--năm 2000, chỉ lấy các thông tin có tổng số chuyến bay >=2. Sắp xếp giảm dần
--theo tổng số chuyến bay.
select sbdi,count(*) as SoCB
from CHUYENBAY cb join LichBay lb on cb.MACB = lb.MACB
group by SBDI

having count(*) > = 2
order by socb desc


--18. Với mỗi loại máy bay có nhiều hơn 1 chiếc, cho biết số lượng chuyến bay đã
--được bố trí bay bằng loại máy bay đó, xuất ra mã loại và số lượng.
SELECT mb.maloai, count(macb) as soLuongcb,COUNT(mb.sohieu) as SOMAYBAY
FROM MAYBAY mb join LichBay lb on mb.MALOAI = lb.MALOAI
GROUP BY mb.maloai
HAVING COUNT(mb.maloai) > 1