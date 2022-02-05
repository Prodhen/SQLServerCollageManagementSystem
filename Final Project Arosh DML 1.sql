

Use college
Go
------------Insert data into Gender Table----using SP------

Exec dbo.SP_InsertIntoGender 'Male'
Exec dbo.SP_InsertIntoGender 'Female'
Exec dbo.SP_InsertIntoGender 'Others'


------------Insert data into Student Table-------using SP---

Exec SP_InsertIntoStudent @SFirstName='Arosh',@SLastName='Prodhen',@SBirthDate='06/01/1996',@SGender='1',@SFatherName='Nazrul',@SMotherName='Khurshida',@SMobileNumber='01518395765',@SGMobileNumber='01883410074',@SEmail='aroshprodhen@gmail.com',@SAddress='Rangpur'
Exec SP_InsertIntoStudent @SFirstName='Hashim',@SLastName='Amla',@SBirthDate='06/01/1995',@SGender='1',@SFatherName='Ibrahim',@SMotherName='kulsum',@SMobileNumber='01518395745',@SGMobileNumber='01883410045',@SEmail='Hashim@gmail.com',@SAddress='Khulna'
Exec SP_InsertIntoStudent 'Abbas','Uddin','06/01/1995',1,'Abdullah','minu','01518395745','01883410045','Hashim@gmail.com','Chittagong'
Exec SP_InsertIntoStudent 'Foyzul','karim','06/01/1994',1,'saddam','hossain','01518395744','01883410045','Hashim@gmail.com','Dhaka'
Exec SP_InsertIntoStudent 'Ali','zaker','06/01/1995',1,'kabir','moyshumi','01518395745','01883410045','Hashim@gmail.com','Barishal'
Exec SP_InsertIntoStudent 'lili','Begum','06/01/1993',2,'molla','karimon','01518395745','01883410045','Hashim@gmail.com','lohagara'
Exec SP_InsertIntoStudent 'josna','khatun','06/01/1992',2,'Vobesh','nonibala','01518395745','01883410045','Hashim@gmail.com','oxygen'
Exec SP_InsertIntoStudent 'happy','Alom','06/01/1990',2,'kitish','chobita','01518395745','01883410045','Hashim@gmail.com','feni'
Exec SP_InsertIntoStudent 'Turjo','Islam','06/01/1991',3,'miru','kajla','01518395454','01883410045','Hashim@gmail.com','Gulshan'


------------Insert data into Group Table----using SP------

Exec SP_InsertIntoGroup 'Science'
Exec SP_InsertIntoGroup 'Arts'
Exec SP_InsertIntoGroup 'Commerce'

------------Insert data into Season Table----using SP------

Exec SP_InsertIntoSeason 2020
Exec SP_InsertIntoSeason 2021
Exec SP_InsertIntoSeason 2022
Exec SP_InsertIntoSeason 2023

------------Insert data into Teacher Table----using SP------

Exec SP_TeacherAndSalaryAndSubject 
				    @TeacherID		= 1
				   ,@TeacherName	= 'Mostafizar'	
				   ,@TeacherMobile	= '01783010002'
				   ,@TeacherEmail	= 'Mosta@gmail.com'	
				   ,@TeacherAddress	= 'Barishal'
				   ,@SalaryID		= 1
				   ,@STeacherID 	= 1
				   ,@Salary		= 50000
				   ,@SubjectID		= 1
				   ,@SubjectName	= Bangla	
				   ,@SubTeacherID	= 1
				   ,@tableName		= 'Teacher'
				   ,@operation		= 'Insert'
				
Exec SP_TeacherAndSalaryAndSubject @TeacherID= 2,@TeacherName= 'KamalUddin',@TeacherMobile= '01783010003',@TeacherEmail= 'kamal@gmail.com',@TeacherAddress= 'Rangpur'
				   ,@SalaryID= 1,@STeacherID = 1,@Salary= 45000
				   ,@SubjectID= 1,@SubjectName	= Bangla,@SubTeacherID= 1
				   ,@tableName= 'Teacher',@operation= 'Insert'
Exec SP_TeacherAndSalaryAndSubject @TeacherID= 2,@TeacherName= 'jamalUddin',@TeacherMobile= '01783010004',@TeacherEmail= 'jamal@gmail.com',@TeacherAddress= 'Faridpur'
				   ,@SalaryID= 1,@STeacherID = 1,@Salary= 60000
				   ,@SubjectID= 1,@SubjectName	= Bangla,@SubTeacherID= 1
				   ,@tableName= 'Teacher',@operation= 'Insert'
Exec SP_TeacherAndSalaryAndSubject @TeacherID= 2,@TeacherName= 'FatehUddin',@TeacherMobile= '01783010005',@TeacherEmail= 'Fateh@gmail.com',@TeacherAddress= 'jamalpur'
				   ,@SalaryID= 1,@STeacherID = 1,@Salary= 1000000
				   ,@SubjectID= 1,@SubjectName	= Bangla,@SubTeacherID= 1
				   ,@tableName= 'Teacher',@operation= 'Insert'

				   --Select * from Teacher

------------Insert data into Subject Table----using SP------
Exec SP_TeacherAndSalaryAndSubject 1,'ForidUddin','01783010005','farid@gmail.com','Vola',1,1,50000,1,'Bangla',1,'Subject','Insert'
Exec SP_TeacherAndSalaryAndSubject 2,'ForidUddin','01783010005','farid@gmail.com','Vola',1,1,45000,2,'English',2,'Subject','Insert'
Exec SP_TeacherAndSalaryAndSubject 3,'ForidUddin','01783010005','farid@gmail.com','Vola',1,1,60000,3,'History',3,'Subject','Insert'
Exec SP_TeacherAndSalaryAndSubject 4,'ForidUddin','01783010005','farid@gmail.com','Vola',1,1,1000000,4,'Economics',4,'Subject','Insert'


   
   ------------Insert data into studentAdmission Table----using SP------
Declare @messageout varchar(25)
Exec SP_AdmissionWithOutput
@AdmissionID	=12001
,@AStudentID	=1
,@ASeasionId	=1		
,@AGroupID	=1			
,@operation	='Insert'		
,@message=@messageout  Output
Select @messageout
Go
Declare @messageout varchar(25)
Exec SP_AdmissionWithOutput 12001,2,1,1,'Insert',@messageout  Output
Select @messageout
Go
Declare @messageout varchar(25)
Exec SP_AdmissionWithOutput 12001,3,2,1,'Insert',@messageout  Output
Select @messageout
Go
Declare @messageout varchar(25)
Exec SP_AdmissionWithOutput 12001,4,3,2,'Insert',@messageout  Output
Select @messageout
Go
Declare @messageout varchar(25)
Exec SP_AdmissionWithOutput 12001,5,2,3,'Insert',@messageout  Output
Select @messageout
Go
Declare @messageout varchar(25)
Exec SP_AdmissionWithOutput 12001,6,1,2,'Insert',@messageout  Output
Select @messageout
go
Declare @messageout varchar(25)
Exec SP_AdmissionWithOutput 12001,7,2,2,'Insert',@messageout  Output
Select @messageout
Go
Declare @messageout varchar(25)
Exec SP_AdmissionWithOutput 12001,8,1,2,'Insert',@messageout  Output
Select @messageout
Go
Declare @messageout varchar(25)
Exec SP_AdmissionWithOutput 12001,9,1,2,'Insert',@messageout  Output
Select @messageout

select * From StudentAdmission

--Truncate table StudentAdmission

select * From Season
select * from PaymentHistory

 -----------------Insert data Into Paymenthistory----------------

Insert into PaymentHistory 
(PaymentId,PAdmissionId,AdmissionFee,SeasonFee,LibraryFee,Payment)
Values
(Next Value for dbo.Seq_payment,12001,1000,5000,500,4000),
(Next Value for dbo.Seq_payment,12002,1000,5000,500,3500),
(Next Value for dbo.Seq_payment,12003,1000,5000,500,3000),
(Next Value for dbo.Seq_payment,12004,1000,4000,500,2000),
(Next Value for dbo.Seq_payment,12005,1000,3500,500,2500),
(Next Value for dbo.Seq_payment,12006,1000,4000,500,4200),
(Next Value for dbo.Seq_payment,12007,1000,4000,500,3200),
(Next Value for dbo.Seq_payment,12008,1000,4000,500,2300),
(Next Value for dbo.Seq_payment,12009,1000,4000,500,2400)

select * From Season
select * from PaymentHistory
select * from paymentAudit


-------------------------------------------------------------------------------
-----------------Group By/Having/ Order-Aggreget Function--Join-Table----------
------------------------------------------------------------------------------

Select GroupName,seasonName,count(studentId) As Student
From StudentAdmission
JOin season
On StudentAdmission.ASeasionId=season.seasonId
Join [Group]
On StudentAdmission.AGroupId=[Group].GroupID
Join Student
On StudentAdmission.AstudentID=Student.StudentId
Group By GroupName,seasonName
Having count(studentId)>1
Order by GroupName DESC
------------------------------------------------
-------------------------Marge------------------------
----------------------------------------------
Use College
Drop Table IF Exists GroupArchive
Create Table GroupArchive
(
GroupID			     Int ,
GroupName		     VarChar (25) Unique,
)
Go

Insert GroupArchive Values(1,'G.Science'),(2,'Music'),(3,'Commers'),(4,'Language')


Merge into GroupArchive AS TT
using [Group] AS St
on ST.GroupId = TT.GroupID
when matched 
then
Update set
GroupName= ST.GroupName
   
When not matched Then
Insert (GroupId, GroupName)
Values (ST.GroupId, ST.Groupname)
when not matched by source Then
Delete
    ;
    -------------------------------------------
    ------------------Case---------------------
    -------------------------------------------
Use College
Select PAdmissionId, Payment, Dues,
    Case
        When Dues > 2000
            Then 'No ID card'
        When Dues <= 2000
            Then 'No library Card'
        Else 'contact to Gardian'
    End As RestrictionOfServiec
From PaymentHistory
Where Dues > 1000;
----------------CTA--------------
---------------------------------

With CtaFirst As
(
    Select GroupName, Count(*) As TotalGroup
    From StudentAdmission 
        Join [Group] 
	On StudentAdmission.AGroupID = [Group].GroupID
	
    Group By GroupName
)
Select * From CtaFirst


Select GroupName,seasonName,count(studentId) As Student
From StudentAdmission
JOin season
On StudentAdmission.ASeasionId=season.seasonId
Join [Group]
On StudentAdmission.AGroupId=[Group].GroupID
Join Student
On StudentAdmission.AstudentID=Student.StudentId
Group By GroupName,seasonName
Having count(studentId)>(Select studentid from StudentAdmission where studentId>1 )
Order by GroupName DESC










