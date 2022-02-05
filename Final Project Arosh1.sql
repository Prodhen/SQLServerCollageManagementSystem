USE master
GO
--drop Database College
--Go
DECLARE @location nvarchar(256);
SET @location = (SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'master.mdf', LOWER(physical_name)) - 1)
FROM master.sys.master_files
WHERE database_id = 1 AND file_id = 1);
EXECUTE ('CREATE DATABASE college
ON PRIMARY(NAME = College_data, FILENAME = ''' + @location + 'College_data.mdf'', SIZE = 25MB, MAXSIZE = Unlimited, FILEGROWTH = 5MB)
LOG ON (NAME = College_log, FILENAME = ''' + @location + 'College_log.ldf'', SIZE = 15MB, MAXSIZE = 520, FILEGROWTH = 2MB)'
);
GO



use college

---------------------------------------------------
---------------------Create Schema--Drop-Schema------------
---------------------------------------------------
Create Schema Pro
Go
DROP Schema Pro
Go
---------------------------------------------------
---------------------Create Table-Identity-Primary key-------------
---------------------------------------------------
Use college
Drop Table IF Exists Gender
Create table Gender
(
GenderID Int Identity Primary key,
GenderName VARCHAR (6)
)
Go
---------------------------------------------------
---------------------Create Sequence---------------
---------------------------------------------------
Create Sequence dbo.Seq_payment
as int
  START WITH 1
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 1000
  NO CYCLE
---------------------------------------------------
-------------------Create Table-Foreign key--Drop-Table-----------
---------------------------------------------------

Use college
Drop Table IF Exists Student
Create Table Student
(
StudentID		      Int Identity	Primary key,
SFirstName		      VarChar (25) Not Null,
SLastName		     VarChar (25) Not Null,
SFullName			As (SFirstName+' '+SLastName),
SBirthDate		     date Not Null,
SGender				Int Foreign key References Gender(GenderID),
SFatherName			VarChar (25),
SMotherName			VarChar (25),
SMobileNumber			VarChar (15) ,
SGMobileNumber			 VarChar (15) Not Null,
SEmail				VarChar (25) Not Null,
SAddress			VarChar(25)
)
Go

---------------------------------------------------
---------------------Create Table--One to many-Relation Ship--with student table----------
---------------------------------------------------

Use college
Drop Table IF Exists [Group]
Create Table [Group]
(
GroupID			     Int Identity Primary key,
GroupName			 VarChar (25) Unique,
)
Go

 
---------------------------------------------------
----------------Create Table--use-of Check Cons.-Like-----------
---------------------------------------------------

Use college
Drop Table IF Exists Season
Create Table Season
(
SeasonId		Int identity Primary key,
SeasonName		Int Unique Check (SeasonName like '20%')
)
Go
---------------------------------------------------
---------------------Create Index---------------
---------------------------------------------------
Create  Nonclustered Index Ix_seasionName
On season(seasonName)



---------------------------------------------------
---------------------Create Table---------------
---------------------------------------------------

Use college
Drop Table IF Exists Teacher
Create Table Teacher
(
TeacherID			Int Identity Primary key,
TeacherName			VarChar (25),
TeacherMobile			VarChar(15),
TeacherEmail			VarChar (15),
TeacherAddress			VarChar (25)
)
Go
------------------Create Table--------------
Create Table [Subject]
(
SubjectID Int Identity Primary key,
SubjectName VarChar (10) Unique,
STeacherID int References Teacher(TeacherID)
)
Go




Use college
Drop Table IF Exists TeacherSalary
Create Table TeacherSalary
(
SalaryID			Int Identity Primary key,
TeacherID			Int Foreign key References Teacher(TeacherID),
Salary				Money
)
Go
---------------------------------------------------
---------------------Create Table--Many to many-Relation Ship------------
---------------------------------------------------


Use college
Drop Table IF Exists StudentAdmission
Create Table StudentAdmission
(
AdmissionID			Int Identity(12001,1) Primary key,
AStudentID			Int Unique Foreign key References Student(StudentID),
ASeasionId			Int Foreign key References Season(SeasonID),
AGroupID			Int Foreign key References [Group](GroupID)
)
Go


---------------------------------------------------
----------------Create Table---Airthmetic-Expression-Calculated column---------
---------------------------------------------------

Use college
Drop Table IF Exists PaymentHistory
Create Table PaymentHistory
(
PaymentID				Int  Primary key,
PAdmissionId				Int Unique Foreign key References StudentAdmission(AdmissionId),
AdmissionFee				Money,
SeasonFee				Money,
LibraryFee				Money,
Payment					Money,
Dues					As ((AdmissionFee+SeasonFee+LibraryFee)-Payment)
)
Go
---------------------------------------------------
---------------Alter-Table-table--Add column---Drop-Column--Change Data type-----
---------------------------------------------------

Alter Table PaymentHistory
Add IdcardFee money
Go

Alter Table PaymentHistory
Alter Column IdcardFee decimal(10,4)
Go
Alter Table PaymentHistory
Drop column IdcardFee
---------------------------------------------------
---------------------Create SP for Insert------------
---------------------------------------------------

if exists (select * from sys.objects where name = 'SP_InsertIntoGender') drop proc SP_InsertIntoGender
go
Create Proc SP_InsertIntoGender
@Gendername VarChar (6)

AS
Set NoCount On
    Begin
	Insert Into dbo.Gender(GenderName)
	Values(@Gendername)

    End
Go

Select *From Gender
Go

---------------------------------------------------
--Create SP for Insert--Error handaling----Try-Catch---Transaction--Rollback
---------------------------------------------------
----
if exists (select * from sys.objects where name = 'SP_InsertIntoStudent') drop proc SP_InsertIntoStudent
go
Create Proc SP_InsertIntoStudent

@SFirstName		    VarChar (25) ,
@SLastName		    VarChar (25) ,
@SBirthDate		    date ,
@SGender			Int ,
@SFatherName		VarChar (25),
@SMotherName		VarChar (25),
@SMobileNumber	    VarChar (15) ,
@SGMobileNumber	    VarChar (15) ,
@SEmail				VarChar (25) ,
@SAddress			VarChar(25)
AS
Set NoCount On
Begin Transaction
  Begin---First

	
		Begin Try
		Insert Into dbo.Student(SFirstName,SLastName,SBirthDate,SGender,SFatherName,SMotherName,SMobileNumber,SGMobileNumber,SEmail,SAddress)
		Values(@SFirstName,@SLastName,@SBirthDate,@SGender,@SFatherName,@SMotherName,@SMobileNumber,@SGMobileNumber,@SEmail,@SAddress)
		Commit Tran
		End Try

				Begin Catch
				Rollback Tran
				PRINT 'Something goes Wrong,Check Column Name and Value'
				End Catch
  End
Go

---------------------------------------------------
--Create SP for retrieving Data
---------------------------------------------------
----

if exists (select * from sys.objects where name = 'SP_RetriveStudent') drop proc SP_RetriveStudent
Go
Create Proc SP_RetriveStudent
As 
set NoCount On
	Begin
	    select * From Student
        End
Go

---------------------------------------------------
--Create SP for inserting ---error-handaling Error Number,ERROR_STATE,ERROR_PROCEDURE ,line ,message
---------------------------------------------------
----
if exists (select * from sys.objects where name = 'SP_InsertIntoGroup') drop proc SP_InsertIntoGroup
Go
Create Proc SP_InsertIntoGroup
@GroupName VarChar (15)

AS
Set NoCount On
    Begin
		Begin Tran
	Begin Try
	    Insert Into dbo.[Group](GroupName)
	    Values(@GroupName)
	    Commit Tran
	End Try
	Begin Catch
	   Rollback Tran
	    Select
	  
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_STATE() AS ErrorState,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage
	End Catch
    End
Go
--------------------------------------------------------------------------
------------------------Sp for Inserting With Throw---user defined error message------------
-------------------------------------------------------------------------------------
Select * from [Group]

if exists (select * from sys.objects where name = 'SP_InsertIntoSeason') drop proc SP_InsertIntoSeason
go
Create Proc SP_InsertIntoSeason
@SeasonName Int

AS
Begin
Set NoCount On
	 If (@SeasonName >2000)
		 Begin 
			Insert Into dbo.Season(SeasonName)
			Values(@SeasonName)
		 End
	 Else
		Begin
		    ;
		    Throw 50001,'Must be year >=2000',16
		End
    End
Go
-------------Create Sp for insert/Update/Delete---------Different Table

Select *From Season
--Truncate Table season
if exists (select * from sys.objects where name = 'SP_TeacherAndSalaryAndSubject') drop proc SP_TeacherAndSalaryAndSubject
Go
Create Proc SP_TeacherAndSalaryAndSubject
@TeacherID			Int,
@TeacherName			VarChar (25),
@TeacherMobile			VarChar(15),
@TeacherEmail			VarChar (15),
@TeacherAddress			VarChar (25),
@SalaryID			Int,
@STeacherID			Int ,
@Salary				Money,
@SubjectID			Int ,
@SubjectName			VarChar (10) ,
@SubTeacherID			int ,
@tableName			VarChar(25),
@operation			VArchar (25)

AS
Begin
Set NoCount On
    Begin Try

    Begin Transaction
		If (@Tablename='Teacher' And @operation='Insert')
		Begin
		Insert into Teacher Values(@TeacherName,@TeacherMobile,@TeacherEmail,@TeacherAddress)
		End

		If (@Tablename='Teacher' And @operation='Update')
		Begin
		Update Teacher Set TeacherName=@TeacherName,TeacherMobile=@TeacherMobile,TeacherEmail=@TeacherEmail,TeacherAddress=@TeacherAddress
		Where TeacherID=@TeacherID
		End

		If (@Tablename='Teacher' And @operation='Delete')
		Begin
		Delete From Teacher 
		Where TeacherID=@TeacherID
		End

		If (@Tablename='TeacherSalary' And @operation='Insert')
		Begin
		Insert into TeacherSalary Values(@STeacherID,@Salary)
		End

		If (@Tablename='TeacherSalary' And @operation='Update')
		Begin
		Update TeacherSalary Set TeacherID=@STeacherID,Salary=@Salary
		Where SalaryID=@SalaryID
		End

		If (@Tablename='TeacherSalary' And @operation='Delete')
		Begin
		Delete From TeacherSalary 
		Where SalaryID=@SalaryID
		End

		If (@Tablename='Subject' And @operation='Insert')
		Begin
		Insert into Subject Values(@SubjectName,@SubTeacherID)
		End

		If (@Tablename='Subject' And @operation='Update')
		Begin
		Update Subject Set SubjectName= @SubjectName
		Where SubjectID=@subjectId
		End

		If (@Tablename='Subject' And @operation='Delete')
		Begin
		Delete From Subject 
		Where SubjectID=@subjectId
		End
		
	    Commit Transaction
   End Try
    Begin Catch
    RollBack Transaction
  print cast (error_number() as varchar) + ' : '+error_message()
    End Catch
End
Go

	--Truncate Table subject
	select* from Subject
Go
-----------Create Sp for insert/update/delete in one table With OutPut peramiter--------------
----------------------------------------------------------------------

if exists (select * from sys.objects where name = 'SP_AdmissionWithOutput') drop proc SP_AdmissionWithOutput
Go
Create Proc SP_AdmissionWithOutput
@AdmissionID			Int ,
@AStudentID			Int,
@ASeasionId			Int ,
@AGroupID			Int,

@operation			VArchar (25),
@message                        VarChar(60) OutPut
With encryption

AS
Begin
Set NoCount On
    Begin Try

    Begin Transaction
		If (@operation='Insert')
		Begin
		Insert into StudentAdmission (AStudentID,ASeasionId,AGroupID) Values(@AStudentID,@ASeasionId,@AGroupID)
		End

		If (@operation='Update')
		Begin
		Update StudentAdmission Set AStudentID=@AStudentID,ASeasionId=@ASeasionId,AGroupID=@AGroupID
		Where AdmissionID=@AdmissionID
		End

		If (@operation='Delete')
		Begin
		Delete From StudentAdmission 
		Where AdmissionID=@AdmissionID
		End
		Set @message='Successfully done'
		
	    Commit Transaction
   End Try
    Begin Catch
    RollBack Transaction
  print cast (error_number() as varchar) + ' : '+error_message()
    End Catch
End
Go


-------------------------------------------------
------------Create TAble for Trigger---------

Create Table paymentAudit
(
Id Int Identity (2000,1),
Audit VarChar (100)
)
Go

------------------------------------------------------
-------------Create Trigger------After Insert---------
------------------------------------------------------
Create Trigger Tr_Audit On dbo.PaymentHistory
After Insert
As
Begin
Declare 
@PaymentID Int
    Select @PaymentID= PaymentID From Inserted

    Insert Into paymentAudit Values('Admission ID: ' +Convert (VarChar,@PaymentID)+' is Inserted'+' Fired After Insert'+' Date: '+cast(GETDATE() As varchar))
End
Go


--Truncate Table PaymentHistory
--Truncate Table paymentAudit
--Select * From paymentAudit
--select * from PaymentHistory

------------------------------------------------------
-------------Create Trigger------After Delete---------
------------------------------------------------------

Go
Create Trigger Tr_Auditdelete On dbo.PaymentHistory
After Delete
As
Begin
Declare 
@PaymentID Int
    Select @PaymentID= PaymentID From deleted

    Insert Into paymentAudit Values('Admission ID: ' +Convert (VarChar,@PaymentID)+' is Deleted'+' Fired After Delete'+' Date: '+cast(GETDATE() As varchar))
End
Go

--Delete from PaymentHistory
--Where PaymentID=2

--Go
------------------------------------------------------
-------------Create Trigger------After Update---------
------------------------------------------------------
Create Trigger Tr_AuditUpdate On dbo.PaymentHistory
After Update
As
Begin
Declare 
@PaymentID				Int ,
@PAdmissionId				Int ,
@AdmissionFee				Money,
@SeasonFee				Money,
@LibraryFee				Money,
@Payment				Money


    Select @PaymentID= PaymentID From inserted
    Select @PAdmissionId= PAdmissionId From inserted
    Select @AdmissionFee= AdmissionFee From inserted
    Select @SeasonFee= SeasonFee From inserted
    Select @LibraryFee= LibraryFee From inserted
    Select @Payment= Payment From inserted

    Insert Into paymentAudit Values('Admission ID: ' +Convert (VarChar,@PaymentID)+' is updated'+' Fired After Update'+' Date: '+cast(GETDATE() As varchar))
End
Go

--Update PaymentHistory
--Set Payment=3001
--Where PaymentID=1
--Go
------------------------------------------------------
-------------Create Trigger------Instead of Insert With Raiserror---------
------------------------------------------------------

Create Trigger tri_InsteadOfInsert on dbo.TeacherSalary
Instead Of Insert
AS
Declare
@SalaryID			Int,
@TeacherID			Int ,
@Salary				Money

Select @SalaryID=SalaryID From Inserted 
Select @TeacherID=TeacherID From Inserted
Select @Salary=Salary From Inserted


Begin
	Begin tran
	If (@Salary<20000)
		Begin
		Raiserror ('Salary must be  Must Be >=20000',16,1)
		Rollback
		End
	Else
		Begin
		Insert Into TeacherSalary(TeacherID,Salary) 
		values (@TeacherID,@Salary)

		Insert Into paymentAudit Values('SalaryID : ' +Convert (VarChar,@@IDENTITY)+' is Inserted'+' Instead of Insert'++' Date: '+cast(GETDATE() As varchar))
		End
	Commit tran

End
Go
--Insert into TeacherSalary Values(1,25000)
--select * from TeacherSalary
--select * from paymentAudit
--Go

------------------------------------------------------
-------------Create Trigger------Instead of Update With Raiserror---------
------------------------------------------------------


Create Trigger tri_InsteadOfUpdate on dbo.TeacherSalary
Instead Of Update
AS
Declare
@SalaryID			Int,
@TeacherID			Int ,
@Salary				Money

Select @SalaryID=SalaryID From Inserted 
Select @TeacherID=TeacherID From Inserted
Select @Salary=Salary From Inserted


Begin
	Begin tran
	If (@Salary<20000)
		Begin
		Raiserror ('Salary must be  Must Be >=20000',16,1)
		Rollback
		End
	Else
		Begin
		Update TeacherSalary set TeacherID=@TeacherID,Salary= @Salary
		Where SalaryID=@SalaryID

		Insert Into paymentAudit Values('SalaryID : ' +Convert (VarChar,@@IDENTITY)+' is Updated'+' Instead of Update'++' Date: '+cast(GETDATE() As varchar))
		End
	Commit tran

End
Go

------------------------------------------------------
-------------Create Trigger------Instead of Delete With Raiserror---------
------------------------------------------------------


Create Trigger tri_InsteadOfDelete on dbo.TeacherSalary
Instead Of Delete
AS
Declare
@SalaryID			Int,
@TeacherID			Int ,
@Salary				Money

Select @salaryID=SalaryID From deleted 
Select @teacherID=TeacherID From deleted 
Select @salary=salary From Deleted 

Begin
	Begin tran
	If (@Salary<100000)
		Begin
		Raiserror ('Salary must be  Must Be >=100000',16,1)
		Rollback
		End
	Else
		Begin
		Delete From TeacherSalary 
		Where SalaryID=@SalaryID

		Insert Into paymentAudit Values('SalaryID : ' +Convert (VarChar,@@IDENTITY)+' is Deleted'+' Instead of Delete'++' Date: '+cast(GETDATE() As varchar))
		End
	Commit tran

End
Go
--Insert into TeacherSalary Values (4,10000000)
--Select * from TeacherSalary
--Select * from paymentAudit

--Delete from TeacherSalary
--Where SalaryID=5
--Go
---------------------------------------------
---------Create---Scaler--Function---------------
-------------------------------------------------


Create FUNCTION fn_Group
(
@Group VarChar (15)
)
RETURNS int
AS
BEGIN

    RETURN (Select count(Groupname)
From StudentAdmission
Join [Group]
On StudentAdmission.AGroupID= [Group].GroupID
Where @Group= GroupName
    )
END
Go
Print dbo.fn_Group('Commers')
Go

---------------------------------------------
---------Create---Tabler--Function---------------
-------------------------------------------------


CREATE FUNCTION fn_season
(
  @season Int 
)
RETURNS TABLE AS RETURN
(
   Select SFullName,GroupName,seasonName
From StudentAdmission
JOin season
On StudentAdmission.ASeasionId=season.seasonId
Join [Group]
On StudentAdmission.AGroupId=[Group].GroupID
Join Student
On StudentAdmission.AstudentID=Student.StudentId
Where @season=seasonName
)
Go

select * from fn_season(2024)
Go
--------------------------------------------------
---------------------Create-----VIEW---------------------
---------------------------------------------------
Create VIEW vw_studentInformation
With Encryption 
AS
    Select SFirstName,SLastName,Sfullname,SBirthDate,SGender,SFatherName,SEmail,SAddress 
    from Student
Go
Select * From vw_studentInformation





	




