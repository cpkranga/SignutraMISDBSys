﻿CREATE FUNCTION dbo.fnNumberToWords(@Money AS money) 

    RETURNS VARCHAR(1024)

AS

BEGIN

    DECLARE @Number as BIGINT

    SET @Number = FLOOR(@Money)

    DECLARE @Below20 TABLE (ID int identity(0,1), Word varchar(32))

    DECLARE @Below100 TABLE (ID int identity(2,1), Word varchar(32))

    INSERT @Below20 (Word) VALUES 

              ( 'Zero'), ('One'),( 'Two' ), ( 'Three'),

              ( 'Four' ), ( 'Five' ), ( 'Six' ), ( 'Seven' ),

              ( 'Eight'), ( 'Nine'), ( 'Ten'), ( 'Eleven' ),

              ( 'Twelve' ), ( 'Thirteen' ), ( 'Fourteen'),

              ( 'Fifteen' ), ('Sixteen' ), ( 'Seventeen'),

              ('Eighteen' ), ( 'Nineteen' ) 

     INSERT @Below100 VALUES ('Twenty'), ('Thirty'),('Forty'), ('Fifty'),

                 ('Sixty'), ('Seventy'), ('Eighty'), ('Ninety')

DECLARE @English varchar(1024) = 

(

  SELECT Case 

    WHEN @Number = 0 THEN  ''

    WHEN @Number BETWEEN 1 AND 19 

    THEN (SELECT Word FROM @Below20 WHERE ID=@Number)

   WHEN @Number BETWEEN 20 AND 99

-- SQL Server recursive function    

   THEN  (SELECT Word FROM @Below100 WHERE ID=@Number/10)+ '-' +

       dbo.fnNumberToWords( @Number % 10) 

   WHEN @Number BETWEEN 100 AND 999   

   THEN  (dbo.fnNumberToWords( @Number / 100))+' Hundred '+

     dbo.fnNumberToWords( @Number % 100) 

   WHEN @Number BETWEEN 1000 AND 999999   

   THEN  (dbo.fnNumberToWords( @Number / 1000))+' Thousand '+

     dbo.fnNumberToWords( @Number % 1000)  

   WHEN @Number BETWEEN 1000000 AND 999999999   

   THEN  (dbo.fnNumberToWords( @Number / 1000000))+' Million '+

     dbo.fnNumberToWords( @Number % 1000000) 

   ELSE ' INVALID INPUT' END

)

SELECT @English = RTRIM(@English)

SELECT @English = RTRIM(LEFT(@English,len(@English)-1))

         WHERE RIGHT(@English,1)='-'

IF @@NestLevel = 1

BEGIN

    SELECT @English = @English+' and '

    SELECT @English = @English+ 

    convert(varchar,convert(int,100*(@Money - @Number))) +' Cents'

END

RETURN (@English)

END

