--Sabyassachi Sahu/Project 2

--1.Extract those employeeID where employee salary is greater than manager salary

Create Table Employee(
	EmpID Int Primary Key,
	Salary Int not null,
	ManagerID Int Foreign Key References Employee(EmpID)
	)

Insert Into Employee
Select		 1, 10000,	Null
Union Select 2, 8000,	1
Union Select 3, 12000,	1
Union Select 4, 5000,	2
Union Select 5, 7000,	2
Union Select 6, 10000,	5
Union Select 7, 3000,	5

Select * from Employee

--Solution
Select Emp.EmpID as Employee_ID, Emp.Salary as Employee_Salary, Mgr.EmpID as Manager_ID, Mgr.Salary as Manager_Salary 
From Employee as Emp
Inner Join Employee as Mgr
on Mgr.EmpID=Emp.ManagerID
Where Emp.Salary > Mgr.Salary

--2.Select Customers who have done net positive shopping in the last 2 years starting from today.

--Table Creation and Insertion 
Create Table Customer(
	CUSTID int,
	SALES int,
	DATE date
	)

Insert Into Customer
Values ( 1011,1000,'2018/12/22'),
( 1012,1011,'2018/05/16'),
( 1033,1081,'2018/01/11'),
( 1043,1056,'2017/09/25'),
( 1087,11111,'2016/09/28'),
( 1019,1789,'2015/10/08'),
( 1116,1590,'2017/06/17'),
( 1043,1056,'2017/09/25'),
( 1011,-11111,'2018/12/22'),
( 1012,1011,'2018/05/16'),
( 1033,1081,'2018/01/11'),
( 1043,-11056,'2017/09/25'),
( 1087,11111,'2016/09/28'),
( 1019,1789,'2015/10/08'),
( 1116,1590,'2017/06/17')

--Solution
Select * from Customer
where sales<0 and DATEDIFF(Month,date,getdate())<24



--3. Append CUST_INFO_TABLE1 and CUST_INFO_TABLE2 TO FORM CUSTINFO TABLE

--Table Creation and Insertion 
Create Table CUST_INFO_TABLE1(
	CUSTID Int,
	CITY Varchar(20),
	ADDRESS Varchar(30)
)

Create Table CUST_INFO_TABLE2(
	CUSTID Int,
	CITY Varchar(20),
	ADDRESS Varchar(30)
)

Insert Into CUST_INFO_TABLE1
Values (1011,'BANGALORE','MARATHALLI'),
(1012,'MUMBAI','BANDRA'),
(1033,'CHENNAI','ADYAR'),
(1043,'KOLKATA','JADAVPUR'),
(1087,'BUBNESHWAR','ASHOK NAGAR'),
(1019,'BANGALORE','VIJAYNAGAR'),
(1116,'MUMBAI','ALTAMOUNT ROAD')

Insert Into CUST_INFO_TABLE2
Values (1043,'CHENNAI','BESANT NAGAR'),
(1011,'KOLKATA','PARK STREET'),
(1012,'BUBNESHWAR','BAPUJI NAGAR'),
(1033,'HYDERABAD','JUBLIEE HILLS'),
(1043,'THIRUVANANTHAPURAM','VARKALA'),
(1087,'CHENNAI','ANNA NAGAR'),
(1019,'BANGALORE','MALLESHWARAM'),
(1116,'DELHI','VASANT KUNJ')

Create Table CUST_INFO_TABLE(
	CUSTID Int,
	CITY Varchar(20),
	ADDRESS Varchar(30)
)

--Inserting Values from Both Tables into CUST_INFO_TABLE directly by Union Vertical Join
Insert into CUST_INFO_TABLE
Select * from CUST_INFO_TABLE1 
Union
Select * from CUST_INFO_TABLE2 


Select * from CUST_INFO_TABLE


--4. Select customerid, address fields along with city who have done shopping in last one
--year starting from today

--Solution
Select Distinct I.CustID as Customer_ID, I.CITY, ADDRESS
from CUST_INFO_TABLE as I
inner join Customer as C
on I.CUSTID=C.CUSTID
Where DATEDIFF(Month,C.Date,getdate())<=12


--5. Create 3 groups with 5 customers in each group with decreasing order of sales

--Solution using Ntile function
Select *, NTILE(3)over(Order by Sales Desc) as Tiles from Customer


--Solution Using Case Expression
Select *,
Case 
When RowNum between  1 and 5 then 'Top5'
When RowNum between  6 and 10 then 'Middle5'
When RowNum between  11 and 15 then 'Bottom5'
Else Null
End as GroupNum
From (
	Select *,ROW_NUMBER() over( Order by Sales Desc) as RowNum
From Customer ) C

--Alternate Solution 
--by grouping by cities
Select *,ROW_NUMBER() over(PARTITION BY CITY Order by Sales Desc) as RowNum
From Customer


--6.update the Address to ‘INDIRANAGR’ where the city is BANGALORE

--Solution
Update CUST_INFO_TABLE 
Set ADDRESS='INDIRANAGR'
Where CITY='BANGALORE'

--7.update CUSTOMER_TABLE with city from CUST_INFO_TABLE

--Solution
Alter Table Customer
add  City Varchar(15)

Update Customer
Set Customer.City = I.City
From Customer as C
Inner Join CUST_INFO_TABLE as I
On I.CUSTID=C.CUSTID

Select * from Customer

--8. find cumulative sum of SALES for each custid

--Solution
Select CustID, Sum(Sales) as Sales_Per_Customer
from Customer
Group by CustID


--9.  Write a query to get top 1 customer with highest SALES amount per day

--Solution
Select *
From(
	Select Distinct *, Rank() over(Partition by Date Order by Sales Desc) as RNO from Customer) C
Where RNO =1
Order by Date


--10.There is a CITIES table which contains population for some of the cities of India. 
--All you need to do is extract 5th most populated city of every state using SQL query. 

--Table Creation
Create Table CITIES (
State Varchar(20), City Varchar(50),Population Int)

--Inserting Values into Cities
Insert Into CITIES Values
('ANDHRA PRADESH','Greater Hyderabad (M Corp.)',6809970),
('ANDHRA PRADESH','GVMC (MC)',1730320),
('ANDHRA PRADESH','Vijayawada (M Corp.)',1048240),
('ANDHRA PRADESH','Guntur (M Corp.)',651382),
('ANDHRA PRADESH','Warangal (M Corp.)',620116),
('ANDHRA PRADESH','Nellore (M Corp.)',505258),
('ANDHRA PRADESH','Kurnool (M Corp.)',424920),
('ANDHRA PRADESH','Rajahmundry (M Corp.)',343903),
('ANDHRA PRADESH','Kadapa (M Corp.)',341823),
('ANDHRA PRADESH','Kakinada (M Corp.)',312255),
('ANDHRA PRADESH','Nizamabad (M Corp.)',310467),
('ANDHRA PRADESH','Tirupati (M Corp.)',287035),
('ANDHRA PRADESH','Anantapur (M Corp.)',262340),
('ANDHRA PRADESH','Karimnagar (M Corp.)',260899),
('ANDHRA PRADESH','Ramagundam (M)',229632),
('ANDHRA PRADESH','Vizianagaram (M)',227533),
('ANDHRA PRADESH','Eluru (M Corp.)',214414),
('ANDHRA PRADESH','Secunderabad (CB)',213698),
('ANDHRA PRADESH','Ongole (M)',202826),
('ANDHRA PRADESH','Nandyal (M)',200746),
('ANDHRA PRADESH','Khammam (M) ',184252),
('ANDHRA PRADESH','Machilipatnam (M)',170008),
('ANDHRA PRADESH','Adoni (M)',166537),
('ANDHRA PRADESH','Tenali (M)',164649),
('ANDHRA PRADESH','Proddatur (M)',162816),
('ANDHRA PRADESH','Mahbubnagar (M)',157902),
('ANDHRA PRADESH','Chittoor (M)',153766),
('ANDHRA PRADESH','Hindupur (M)',151835),
('ANDHRA PRADESH','Bhimavaram (M)',142280),
('ANDHRA PRADESH','Madanapalle (M)',135669),
('ANDHRA PRADESH','Nalgonda (M)',135163),
('ANDHRA PRADESH','Guntakal (M)',126479),
('ANDHRA PRADESH','Srikakulam (M)',126003),
('ANDHRA PRADESH','Dharmavaram (M)',121992),
('ANDHRA PRADESH','Gudivada (M)',118289),
('ANDHRA PRADESH','Adilabad (M)',117388),
('ANDHRA PRADESH','Narasaraopet (M)',116329),
('ANDHRA PRADESH','Tadpatri (M)',108249),
('ANDHRA PRADESH','Suryapet (M)',105250),
('ANDHRA PRADESH','Miryalaguda (M)',103855),
('ANDHRA PRADESH','Tadepalligudem (M)',103577),
('ANDHRA PRADESH','Chilakaluripet (M)',101550),
('BIHAR','Patna (M Corp.)',1683200),
('BIHAR','Gaya (M Corp.)',463454),
('BIHAR','Bhagalpur (M Corp.)',398138),
('BIHAR','Muzaffarpur (M Corp.)',351838),
('BIHAR','Biharsharif (M Corp.)',296889),
('BIHAR','Darbhanga (M Corp.)',294116),
('BIHAR','Purnia (M Corp.)',280547),
('BIHAR','Arrah (M Corp.)',261099),
('BIHAR','Begusarai (M Corp.)',251136),
('BIHAR','Katihar (M Corp.)',225982),
('BIHAR','Munger (M Corp.)',213101),
('BIHAR','Chapra (NP)',201597),
('BIHAR','Dinapur Nizamat (NP)',182241),
('BIHAR','Saharsa (NP)',155175),
('BIHAR','Sasaram (NP)',147396),
('BIHAR','Hajipur (NP)',147126),
('BIHAR','Dehri (NP)',137068),
('BIHAR','Siwan (NP)',134458),
('BIHAR','Bettiah (NP)',132896),
('BIHAR','Motihari (NP)',125183),
('BIHAR','Bagaha (NP)',113012),
('BIHAR','Kishanganj (NP)',107076),
('BIHAR','Jamalpur (NP)',105221),
('BIHAR','Buxar (NP)',102591),
('BIHAR','Jehanabad (NP)',102456),
('BIHAR','Aurangabad (NP)',101520),
('GUJARAT','Ahmadabad (M Corp.)',5570585),
('GUJARAT','Surat (M Corp.)',4462002),
('GUJARAT','Vadodara (M Corp.)',1666703),
('GUJARAT','Rajkot (M. Corp)',1286995),
('GUJARAT','Bhavnagar (M Corp.)',593768),
('GUJARAT','Jamnagar (M Corp.)',529308),
('GUJARAT','Junagadh (M Corp.)',320250),
('GUJARAT','Gandhidham (M)',248705),
('GUJARAT','Nadiad (M)',218150),
('GUJARAT','Gandhinagar (NA)',208299),
('GUJARAT','Anand (M)',197351),
('GUJARAT','Morvi (M)',188278),
('GUJARAT','Mahesana (M)',184133),
('GUJARAT','Surendranagar Dudhrej (M)',177827),
('GUJARAT','Bharuch (M)',168729),
('GUJARAT','Navsari (M)',160100),
('GUJARAT','Veraval (M)',153696),
('GUJARAT','Porbandar (M)',152136),
('GUJARAT','Bhuj (M)',147123),
('GUJARAT','Godhra (M)',143126),
('GUJARAT','Botad (M)',130302),
('GUJARAT','Palanpur (M)',127125),
('GUJARAT','Patan (M)',125502),
('GUJARAT','Jetpur Navagadh (M)',118550),
('GUJARAT','Valsad (M)',114987),
('GUJARAT','Kalol (M)',112126),
('GUJARAT','Gondal (M)',112064),
('GUJARAT','Deesa (M)',111149),
('GUJARAT','Amreli (M)',105980),
('HARYANA','Faridabad (M Corp.)',1404653),
('HARYANA','Gurgaon (M Corp.)',876824),
('HARYANA','Rohtak (M Cl)',373133),
('HARYANA','Hisar (M Cl)',301249),
('HARYANA','Panipat (M Cl)',294150),
('HARYANA','Karnal (M Cl)',286974),
('HARYANA','Sonipat (M Cl)',277053),
('HARYANA','Yamunanagar (M Cl)',216628),
('HARYANA','Panchkula (M Cl) (incl.spl)',210175),
('HARYANA','Bhiwani (M Cl)',197662),
('HARYANA','Ambala (M Cl)',196216),
('HARYANA','Sirsa (M Cl)',183282),
('HARYANA','Bahadurgarh (M Cl)',170426),
('HARYANA','Jind (M Cl)',166225),
('HARYANA','Thanesar (M Cl)',154962),
('HARYANA','Kaithal (M Cl)',144633),
('HARYANA','Rewari (M Cl)',140864),
('HARYANA','Palwal (M Cl)',127931),
('HARYANA','Jagadhri (M Cl)',124915),
('HARYANA','Ambala Sadar (M CL)',104268),
('JHARKHAND','Dhanbad (M Corp.)',1161561),
('JHARKHAND','Ranchi (M Corp.)',1073440),
('JHARKHAND','Jamshedpur (NAC)',629659),
('JHARKHAND','Bokaro Steel City (CT)',413934),
('JHARKHAND','Mango (NAC)',224002),
('JHARKHAND','Deoghar (M Corp.)',203116),
('JHARKHAND','Aditya (NP)',173988),
('JHARKHAND','Hazaribag (NP)',142494),
('JHARKHAND','Chas (NP)',141618),
('JHARKHAND','Giridih (NP)',114447),
('KARNATAKA','BBMP (M Corp.)',8425970),
('KARNATAKA','Hubli-Dharwad *(M Corp.)',943857),
('KARNATAKA','Mysore (M Corp.)',887446),
('KARNATAKA','Gulbarga (M Corp.)',532031),
('KARNATAKA','Belgaum (M Corp.)',488292),
('KARNATAKA','Mangalore (M Corp.)',484785),
('KARNATAKA','Davanagere (M Corp.)',435128),
('KARNATAKA','Bellary (M Corp.)',409644),
('KARNATAKA','Bijapur (CMC)',326360),
('KARNATAKA','Shimoga (CMC)',322428),
('KARNATAKA','Tumkur (CMC)',305821),
('KARNATAKA','Raichur (CMC)',232456),
('KARNATAKA','Bidar (CMC)',211944),
('KARNATAKA','Hospet (CMC)',206159),
('KARNATAKA','Gadag-Betigeri (CMC)',172813),
('KARNATAKA','Bhadravati (CMC)',150776),
('KARNATAKA','Robertson Pet (CMC)',146428),
('KARNATAKA','Chitradurga (CMC)',139914),
('KARNATAKA','Kolar (CMC)',138553),
('KARNATAKA','Mandya (CMC)',137735),
('KARNATAKA','Hassan (CMC)',133723),
('KARNATAKA','Udupi (CMC)',125350),
('KARNATAKA','Chikmagalur (CMC)',118496),
('KARNATAKA','Bagalkot (CMC)',112068),
('KARNATAKA','Ranibennur (CMC)',106365),
('KARNATAKA','Gangawati (CMC)',105354),
('MADHYA PRADESH','Indore (M Corp.)',1960631),
('MADHYA PRADESH','Bhopal (M Corp.)',1795648),
('MADHYA PRADESH','Jabalpur (M Corp.)',1054336),
('MADHYA PRADESH','Gwalior (M Corp.)',1053505),
('MADHYA PRADESH','Ujjain (M Corp.)',515215),
('MADHYA PRADESH','Dewas (M Corp.)',289438),
('MADHYA PRADESH','Satna (M Corp.)',280248),
('MADHYA PRADESH','Sagar (M Corp.)',273357),
('MADHYA PRADESH','Ratlam (M Corp.)',264810),
('MADHYA PRADESH','Rewa (M Corp.)',235422),
('MADHYA PRADESH','Murwara (Katni) (M Corp.)',221875),
('MADHYA PRADESH','Singrauli (M Corp.)',220295),
('MADHYA PRADESH','Burhanpur (M Corp.)',210891),
('MADHYA PRADESH','Khandwa (M Corp.)',200681),
('MADHYA PRADESH','Morena (M)',200506),
('MADHYA PRADESH','Bhind (M)',197332),
('MADHYA PRADESH','Guna (M)',180978),
('MADHYA PRADESH','Shivpuri (M)',179972),
('MADHYA PRADESH','Vidisha (M)',155959),
('MADHYA PRADESH','Mandsaur (M)',141468),
('MADHYA PRADESH','Chhindwara (M)',138266),
('MADHYA PRADESH','Chhattarpur (M)',133626),
('MADHYA PRADESH','Neemuch (M)',128108),
('MADHYA PRADESH','Pithampur (M)',126099),
('MADHYA PRADESH','Damoh (M)',124979),
('MADHYA PRADESH','Hoshangabad (M)',117956),
('MADHYA PRADESH','Sehore (M)',108818),
('MADHYA PRADESH','Khargone (M)',106452),
('MADHYA PRADESH','Betul (M)',103341),
('MADHYA PRADESH','Seoni (M)',102377),
('MADHYA PRADESH','Datia (M)',100466),
('MADHYA PRADESH','Nagda (M)',100036),
('MAHARASHTRA','Greater Mumbai (M Corp.)',12478447),
('MAHARASHTRA','Pune (M Corp.)',3115431),
('MAHARASHTRA','Nagpur (M Corp.)',2405421),
('MAHARASHTRA','Thane (M Corp.)',1818872),
('MAHARASHTRA','Pimpri-Chinchwad (M Corp.)',1729359),
('MAHARASHTRA','Nashik (M Corp.)',1486973),
('MAHARASHTRA','Kalyan-Dombivali (M Corp.)',1246381),
('MAHARASHTRA','Vasai Virar City (M Corp.)',1221233),
('MAHARASHTRA','Aurangabad (M Corp.)',1171330),
('MAHARASHTRA','Navi Mumbai (M Corp.)',1119477),
('MAHARASHTRA','Solapur (M Corp.)',951118),
('MAHARASHTRA','Mira-Bhayander (M Corp.)',814655),
('MAHARASHTRA','Bhiwandi (M Corp.)',711329),
('MAHARASHTRA','Amravati (M Corp.)',646801),
('MAHARASHTRA','Nanded Waghala (M Corp.)',550564),
('MAHARASHTRA','Kolapur (M Corp.)',549283),
('MAHARASHTRA','Ulhasnagar (M Corp.)',506937),
('MAHARASHTRA','Sangli Miraj Kupwad (M Corp.)',502697),
('MAHARASHTRA','Malegoan (M Corp.)',471006),
('MAHARASHTRA','Jalgaon (M Corp.)',460468),
('MAHARASHTRA','Akola (M Corp.)',427146),
('MAHARASHTRA','Latur (M Cl)',382754),
('MAHARASHTRA','Dhule (M Corp.)',376093),
('MAHARASHTRA','Ahmadnagar (M Corp.)',350905),
('MAHARASHTRA','Chandrapur (M Cl)',321036),
('MAHARASHTRA','Parbhani (M Cl)',307191),
('MAHARASHTRA','Ichalkaranji (M Cl)',287570),
('MAHARASHTRA','Jalna (M Cl)',285349),
('MAHARASHTRA','Ambernath (M Cl)',254003),
('MAHARASHTRA','Navi Mumbai Panvel Raigad (CT)',194999),
('MAHARASHTRA','Bhusawal (M Cl)',187750),
('MAHARASHTRA','Panvel (M Cl)',180464),
('MAHARASHTRA','Badalapur (M Cl)',175516),
('MAHARASHTRA','Bid (M Cl)',146237),
('MAHARASHTRA','Gondiya (M Cl)',132889),
('MAHARASHTRA','Satara (M Cl)',120079),
('MAHARASHTRA','Barshi (M Cl)',118573),
('MAHARASHTRA','Yavatmal (M Cl)',116714),
('MAHARASHTRA','Achalpur (M Cl)',112293),
('MAHARASHTRA','Osmanabad (M Cl)',112085),
('MAHARASHTRA','Nandurbar (M Cl)',111067),
('MAHARASHTRA','Wardha (M Cl)',105543),
('MAHARASHTRA','Udgir (M Cl)',104063),
('MAHARASHTRA','Hinganghat (M Cl)',100416),
('NCT OF DELHI','DMC (U) (M Corp.)',11007835),
('NCT OF DELHI','Kirari Suleman Nagar (CT)',282598),
('NCT OF DELHI','NDMC (M Cl) Total',249998),
('NCT OF DELHI','Karawal Nagar (CT)',224666),
('NCT OF DELHI','Nangloi Jat (CT)',205497),
('NCT OF DELHI','Bhalswa Jahangir Pur (CT)',197150),
('NCT OF DELHI','Sultan Pur Majra (CT)',181624),
('NCT OF DELHI','Hastsal (CT)',177033),
('NCT OF DELHI','Deoli (CT)',169410),
('NCT OF DELHI','Dallo Pura (CT)',154955),
('NCT OF DELHI','Burari (CT)',145584),
('NCT OF DELHI','Mustafabad (CT)',127012),
('NCT OF DELHI','Gokal Pur (CT)',121938),
('NCT OF DELHI','Mandoli (CT)',120345),
('NCT OF DELHI','Delhi Cantonment (CB)',116352),
('ORISSA','Bhubaneswar Town (M Corp.)',837737),
('ORISSA','Cuttack (M Corp.)',606007),
('ORISSA','Brahmapur Town (M Corp.)',355823),
('ORISSA','Raurkela Town (M)',273217),
('ORISSA','Raurkela Industrial Township (IT)',210412),
('ORISSA','Puri Town (M)',201026),
('ORISSA','Sambalpur Town (M)',183383),
('ORISSA','Baleshwar Town (M)',118202),
('ORISSA','Baripada Town (M)',110058),
('ORISSA','Bhadrak (M)',107369),
('PUNJAB','Ludhiana (M Corp.)',1613878),
('PUNJAB','Amritsar (M Corp.)',1132761),
('PUNJAB','Jalandhar (M Corp.)',862196),
('PUNJAB','Patiala (M Corp.)',405164),
('PUNJAB','Bathinda (M Corp.)',285813),
('PUNJAB','Hoshiarpur (M Cl)',168443),
('PUNJAB','Batala (M Cl)',156400),
('PUNJAB','Moga (M Cl)',150432),
('PUNJAB','Pathankot (M Cl)',148357),
('PUNJAB','S.A.S. Nagar (M Cl)',146104),
('PUNJAB','Abohar (M Cl)',145238),
('PUNJAB','Malerkotla (M Cl)',135330),
('PUNJAB','Khanna (M Cl)',128130),
('PUNJAB','Muktsar (M Cl)',117085),
('PUNJAB','Barnala (M Cl)',116454),
('PUNJAB','Firozpur (M Cl)',110091),
('PUNJAB','Kapurthala (M Cl)',101654),
('RAJASTHAN','Jaipur (M Corp.)',3073350),
('RAJASTHAN','Jodhpur (M Corp.)',1033918),
('RAJASTHAN','Kota (M Corp.)',1001365),
('RAJASTHAN','Bikaner (M Corp.)',647804),
('RAJASTHAN','Ajmer (M Corp.)',542580),
('RAJASTHAN','Udaipur (M Cl)',451735),
('RAJASTHAN','Bhilwara (M Cl)',360009),
('RAJASTHAN','Alwar (M Cl)',315310),
('RAJASTHAN','Bharatpur (M Cl)',252109),
('RAJASTHAN','Sikar (M Cl)',237579),
('RAJASTHAN','Pali (M Cl)',229956),
('RAJASTHAN','Ganganagar (M Cl)',224773),
('RAJASTHAN','Tonk (M Cl)',165363),
('RAJASTHAN','Kishangarh (M Cl)',155019),
('RAJASTHAN','Hanumangarh (M Cl)',151104),
('RAJASTHAN','Beawar (M Cl)',145809),
('RAJASTHAN','Dhaulpur (M)',126142),
('RAJASTHAN','Sawai Madhopur (M)',120998),
('RAJASTHAN','Churu (M Cl)',119846),
('RAJASTHAN','Gangapur City (M)',119045),
('RAJASTHAN','Jhunjhunun (M Cl)',118966),
('RAJASTHAN','Baran (M)',118157),
('RAJASTHAN','Chittaurgarh (M)',116409),
('RAJASTHAN','Hindaun (M)',105690),
('RAJASTHAN','Bhiwadi (M)',104883),
('RAJASTHAN','Bundi (M)',102823),
('RAJASTHAN','Sujangarh (M)',101528),
('RAJASTHAN','Nagaur (M)',100618),
('RAJASTHAN','Banswara (M)',100128),
('TAMIL NADU','Chennai (M Corp.)',4681087),
('TAMIL NADU','Coimbatore (M Corp.)',1061447),
('TAMIL NADU','Madurai (M Corp.)',1016885),
('TAMIL NADU','Tiruchirappalli (M Corp.)',846915),
('TAMIL NADU','Salem (M Corp.)',831038),
('TAMIL NADU','Ambattur (M)',478134),
('TAMIL NADU','Tirunelveli (M Corp.)',474838),
('TAMIL NADU','Tiruppur (M Corp.)',444543),
('TAMIL NADU','Avadi (M)',344701),
('TAMIL NADU','Tiruvottiyur (M)',248059),
('TAMIL NADU','Thoothukkudi (M Corp.)',237374),
('TAMIL NADU','Nagercoil (M)',224329),
('TAMIL NADU','Thanjavur (M)',222619),
('TAMIL NADU','Pallavaram (M)',216308),
('TAMIL NADU','Dindigul (M)',207225),
('TAMIL NADU','Vellore (M Corp.)',185895),
('TAMIL NADU','Tambaram (M)',176807),
('TAMIL NADU','Cuddalore (M)',173361),
('TAMIL NADU','Kancheepuram (M)',164265),
('TAMIL NADU','Alandur (M)',164162),
('TAMIL NADU','Erode (M Corp.)',156953),
('TAMIL NADU','Tiruvannamalai (M)',144683),
('TAMIL NADU','Kumbakonam (M)',140113),
('TAMIL NADU','Rajapalayam (M)',130119),
('TAMIL NADU','Kurichi (M)',125800),
('TAMIL NADU','Madavaram (M)',118525),
('TAMIL NADU','Pudukkottai (M)',117215),
('TAMIL NADU','Hosur (M)',116821),
('TAMIL NADU','Ambur (M)',113856),
('TAMIL NADU','Karaikkudi (M)',106793),
('TAMIL NADU','Neyveli (TS) (CT)',105687),
('TAMIL NADU','Nagapattinam (M)',102838),
('UTTAR PRADESH','Lucknow (M Corp.)',2815601),
('UTTAR PRADESH','Kanpur (M Corp.)',2767031),
('UTTAR PRADESH','Agra (M Corp.)',1574542),
('UTTAR PRADESH','Meerut (M Corp.)',1309023),
('UTTAR PRADESH','Varanasi (M Corp.)',1201815),
('UTTAR PRADESH','Allahabad (M Corp.)',1117094),
('UTTAR PRADESH','Bareilly (M Corp.)',898167),
('UTTAR PRADESH','Moradabad (M Corp.)',889810),
('UTTAR PRADESH','Aligarh (M Corp.)',872575),
('UTTAR PRADESH','Saharanpur (M Corp.)',703345),
('UTTAR PRADESH','Gorakhpur (M Corp.)',671048),
('UTTAR PRADESH','Noida (CT)',642381),
('UTTAR PRADESH','Firozabad (NPP)',603797),
('UTTAR PRADESH','Loni (NPP)',512296),
('UTTAR PRADESH','Jhansi (M Corp.)',507293),
('UTTAR PRADESH','Muzaffarnagar (NPP)',392451),
('UTTAR PRADESH','Mathura (NPP)',349336),
('UTTAR PRADESH','Shahjahanpur (NPP)',327975),
('UTTAR PRADESH','Rampur (NPP)',325248),
('UTTAR PRADESH','Maunath Bhanjan (NPP)',279060),
('UTTAR PRADESH','Farrukhabad-cum-Fatehgarh (NPP)',275754),
('UTTAR PRADESH','Hapur (NPP)',262801),
('UTTAR PRADESH','Etawah (NPP)',256790),
('UTTAR PRADESH','Mirzapur-cum-Vindhyachal (NPP)',233691),
('UTTAR PRADESH','Bulandshahr (NPP)',222826),
('UTTAR PRADESH','Sambhal (NPP)',221334),
('UTTAR PRADESH','Amroha (NPP)',197135),
('UTTAR PRADESH','Fatehpur (NPP)',193801),
('UTTAR PRADESH','Rae Bareli (NPP)',191056),
('UTTAR PRADESH','Khora (CT)',189410),
('UTTAR PRADESH','Orai (NPP)',187185),
('UTTAR PRADESH','Bahraich (NPP)',186241),
('UTTAR PRADESH','Unnao (NPP)',178681),
('UTTAR PRADESH','Sitapur (NPP)',177351),
('UTTAR PRADESH','Jaunpur (NPP)',168128),
('UTTAR PRADESH','Faizabad (NPP)',167544),
('UTTAR PRADESH','Budaun (NPP)',159221),
('UTTAR PRADESH','Banda (NPP)',154388),
('UTTAR PRADESH','Lakhimpur (NPP)',152010),
('UTTAR PRADESH','Hathras (NPP)',137509),
('UTTAR PRADESH','Lalitpur (NPP)',133041),
('UTTAR PRADESH','Pilibhit (NPP)',130428),
('UTTAR PRADESH','Modinagar (NPP)',130161),
('UTTAR PRADESH','Deoria (NPP)',129570),
('UTTAR PRADESH','Hardoi (NPP)',126890),
('UTTAR PRADESH','Etah (NPP)',118632),
('UTTAR PRADESH','Mainpuri (NPP)',117327),
('UTTAR PRADESH','Basti (NPP)',114651),
('UTTAR PRADESH','Gonda (NPP)',114353),
('UTTAR PRADESH','Chandausi (NPP)',114254),
('UTTAR PRADESH','Akbarpur (NPP)',111594),
('UTTAR PRADESH','Khurja (NPP)',111089),
('UTTAR PRADESH','Azamgarh (NPP)',110980),
('UTTAR PRADESH','Ghazipur (NPP)',110698),
('UTTAR PRADESH','Mughalsarai (NPP)',110110),
('UTTAR PRADESH','Kanpur (C',108035),
('UTTAR PRADESH','Sultanpur (NPP)',107914),
('UTTAR PRADESH','Greater Noida (CT)',107676),
('UTTAR PRADESH','Shikohabad (NPP)',107300),
('UTTAR PRADESH','Shamli (NPP)',107233),
('UTTAR PRADESH','Ballia (NPP)',104271),
('UTTAR PRADESH','Baraut (NPP)',102733),
('UTTAR PRADESH','Kasganj (NPP)',101241),
('WEST BENGAL','Kolkata (M Corp.)',4486679),
('WEST BENGAL','Haora (M Corp.)',1072161),
('WEST BENGAL','Durgapur (M Corp.)',566937),
('WEST BENGAL','Asansol (M Corp.)',564491),
('WEST BENGAL','Siliguri (M Corp.)',509709),
('WEST BENGAL','Maheshtala (M)',449423),
('WEST BENGAL','Rajpur Sonarpur (M)',423806),
('WEST BENGAL','South Dum Dum (M)',410524),
('WEST BENGAL','Rajarhat Gopalpur (M)',404991),
('WEST BENGAL','Bhatpara (M)',390467),
('WEST BENGAL','Panihati (M)',383522),
('WEST BENGAL','Kamarhati (M)',336579),
('WEST BENGAL','Barddhaman (M)',314638),
('WEST BENGAL','Kulti (M)',313977),
('WEST BENGAL','Bally (M)',291972),
('WEST BENGAL','Barasat (M)',283443),
('WEST BENGAL','North Dum Dum (M)',253625),
('WEST BENGAL','Baranagar (M)',248466),
('WEST BENGAL','Uluberia (M)',222175),
('WEST BENGAL','Naihati (M)',221762),
('WEST BENGAL','Bidhan Nagar (M)',218323),
('WEST BENGAL','English Bazar (M)',216083),
('WEST BENGAL','Kharagpur (M)',206923),
('WEST BENGAL','Haldia (M)',200762),
('WEST BENGAL','Madhyamgram (M)',198964),
('WEST BENGAL','Baharampur (M)',195363),
('WEST BENGAL','Raiganj (M)',183682),
('WEST BENGAL','Serampore (M)',183339),
('WEST BENGAL','Hugli-Chinsurah (M)',177209),
('WEST BENGAL','Medinipur (M)',169127),
('WEST BENGAL','Chandannagar (M Corp.)',166949),
('WEST BENGAL','Uttarpara Kotrung (M)',162386),
('WEST BENGAL','Barrackpur (M)',154475),
('WEST BENGAL','Krishnanagar (M)',152203),
('WEST BENGAL','Santipur (M)',151774),
('WEST BENGAL','Balurghat (M)',151183),
('WEST BENGAL','Habra (M)',149675),
('WEST BENGAL','Jamuria (M)',144971),
('WEST BENGAL','Bankura (M)',138036),
('WEST BENGAL','North Barrackpur (M)',134825),
('WEST BENGAL','Raniganj (M)',128624),
('WEST BENGAL','Basirhat (M)',127135),
('WEST BENGAL','Halisahar (M)',126893),
('WEST BENGAL','Nabadwip (M)',125528),
('WEST BENGAL','Rishra (M)',124585),
('WEST BENGAL','Ashokenagar Kalyangarh (M)',123906),
('WEST BENGAL','Kanchrapara (M)',122181),
('WEST BENGAL','Puruliya (M)',121436),
('WEST BENGAL','Baidyabati (M)',121081),
('WEST BENGAL','Darjiling (M)',120414),
('WEST BENGAL','Dabgram (P) (CT)',118464),
('WEST BENGAL','Titagarh (M)',118426),
('WEST BENGAL','Dum Dum (M)',117637),
('WEST BENGAL','Bally (CT)',115715),
('WEST BENGAL','Khardaha (M)',111130),
('WEST BENGAL','Champdani (M)',110983),
('WEST BENGAL','Bongaon (M)',110668),
('WEST BENGAL','Jalpaiguri (M)',107351),
('WEST BENGAL','Bansberia (M)',103799),
('WEST BENGAL','Bhadreswar (M)',101334),
('WEST BENGAL','Kalyani (M)',100620)

--Solution
Select *
From(
	Select *, Rank()over (Partition By State Order By Population Desc) as RNO from CITIES) C
Where RNO = 5


-----------------------------------Project End------------------------------------------
