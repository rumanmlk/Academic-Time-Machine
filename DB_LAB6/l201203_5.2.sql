create Database l201203_Lab5
go
use l201203_Lab5
go
CREATE TABLE [dbo].[Items](
	[ItemNo] [int] NOT NULL Primary Key,
	[Name] [varchar](10) NULL,
	[Price] [int] NULL,
	[Quantity in Store] [int] NULL
)
GO
INSERT [dbo].[Items] ([ItemNo], [Name], [Price], [Quantity in Store]) VALUES (100, N'A', 1000, 100)
INSERT [dbo].[Items] ([ItemNo], [Name], [Price], [Quantity in Store]) VALUES (200, N'B', 2000, 50)
INSERT [dbo].[Items] ([ItemNo], [Name], [Price], [Quantity in Store]) VALUES (300, N'C', 3000, 60)
INSERT [dbo].[Items] ([ItemNo], [Name], [Price], [Quantity in Store]) VALUES (400, N'D', 6000, 400)

CREATE TABLE [dbo].[Customers](
	[CustomerNo] [varchar](2) NOT NULL Primary Key,
	[Name] [varchar](30) NULL,
	[City] [varchar](3) NULL,
	[Phone] [varchar](11) NULL
	)
GO
INSERT [dbo].[Customers] ([CustomerNo], [Name], [City], [Phone]) VALUES (N'C1', N'AHMED ALI', N'LHR', N'111111')
INSERT [dbo].[Customers] ([CustomerNo], [Name], [City], [Phone]) VALUES (N'C2', N'ALI', N'LHR', N'222222')
INSERT [dbo].[Customers] ([CustomerNo], [Name], [City], [Phone]) VALUES (N'C3', N'AYESHA', N'LHR', N'333333')
INSERT [dbo].[Customers] ([CustomerNo], [Name], [City], [Phone]) VALUES (N'C4', N'BILAL', N'KHI', N'444444')
INSERT [dbo].[Customers] ([CustomerNo], [Name], [City], [Phone]) VALUES (N'C5', N'SADAF', N'KHI', N'555555')
INSERT [dbo].[Customers] ([CustomerNo], [Name], [City], [Phone]) VALUES (N'C6', N'FARAH', N'ISL', '666666')
go

CREATE TABLE [dbo].[Order](
	[OrderNo] [int] NOT NULL Primary Key,
	[CustomerNo] [varchar](2) NULL foreign key References Customers(CustomerNo),
	[Date] [date] NULL,
	[Total_Items_Ordered] [int] NULL
	)
go

INSERT [dbo].[Order] ([OrderNo], [CustomerNo], [Date], [Total_Items_Ordered]) VALUES (1, N'C1', CAST(0x7F360B00 AS Date), 30)
INSERT [dbo].[Order] ([OrderNo], [CustomerNo], [Date], [Total_Items_Ordered]) VALUES (2, N'C3', CAST(0x2A3C0B00 AS Date), 5)
INSERT [dbo].[Order] ([OrderNo], [CustomerNo], [Date], [Total_Items_Ordered]) VALUES (3, N'C3', CAST(0x493C0B00 AS Date), 20)
INSERT [dbo].[Order] ([OrderNo], [CustomerNo], [Date], [Total_Items_Ordered]) VALUES (4, N'C4', CAST(0x4A3C0B00 AS Date), 15)

GO
CREATE TABLE [dbo].[OrderDetails](
	[OrderNo] [int] NOT NULL foreign key References [Order](OrderNo),
	[ItemNo] [int] NOT NULL foreign key References Items(ItemNo),
	[Quantity] [int] NULL,
	Primary Key (OrderNo, ItemNo)
	)
GO
INSERT [dbo].[OrderDetails] ([OrderNo], [ItemNo], [Quantity]) VALUES (1, 200, 20)
INSERT [dbo].[OrderDetails] ([OrderNo], [ItemNo], [Quantity]) VALUES (1, 400, 10)
INSERT [dbo].[OrderDetails] ([OrderNo], [ItemNo], [Quantity]) VALUES (2, 200, 5)
INSERT [dbo].[OrderDetails] ([OrderNo], [ItemNo], [Quantity]) VALUES (3, 200, 20)

select * from Items
select * from Customers
select * from dbo.[Order]
select * from OrderDetails



--task 1
create view OrderCost 
as
select o.orderno as 'Order No', SUM(i.Price * od.Quantity) as 'Total price'
from [order] o join [OrderDetails] od
on o.OrderNo=od.OrderNo join [Items] i
on od.ItemNo=i.ItemNo
group by o.OrderNo


select * from OrderCost

--task 2
create view HotItems
as
select *
from [Items]
where ItemNo in (
select i.ItemNo
from [Items] i join [OrderDetails] od
on i.ItemNo=od.ItemNo
group by i.itemNo
having SUM(od.Quantity)>20
)

select * from HotItems


--task 3
create view StarCustomers
as
select * from [Customers]
where CustomerNo in (
Select c.customerNo
from [Customers] c join [Order] o
on c.CustomerNo=o.CustomerNo join [OrderDetails] od
on od.OrderNo=o.OrderNo join [Items] i
on i.ItemNo=od.ItemNo
where i.Price>2000

)

select * from StarCustomers


--task 4 a
create view CustomerWithMobile
as
Select *
from [Customers]
where Phone is not null

select * from CustomerWithMobile


--task 4 b
create view CustomerWithMobilePlusCheck
as
Select *
from [Customers]
where Phone is not null
with check option

select * from CustomerWithMobilePlusCheck


insert into CustomerWithMobile values (N'C7', N'Ahmed', N'ISL', '777777')

update CustomerWithMobile
set phone=NULL where CustomerNo=N'C7'

delete from CustomerWithMobile
where CustomerNo='C7'

insert into CustomerWithMobilePlusCheck values (N'C8', N'Sana', N'ISL', '888888')

update CustomerWithMobilePlusCheck
set phone=NULL where CustomerNo='C8'

delete from CustomerWithMobilePlusCheck
where CustomerNo='C8'


