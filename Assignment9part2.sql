-- XML
-- Cameron Pickle 7/24/2017
-- Assignment 9 Part 2

----------------------------------------------------------------------------------
-- #1 - Apply OPENXML to this document
----------------------------------------------------------------------------------

USE Pickle_FARMS

DECLARE @idoc int
DECLARE @xmldoc nvarchar(4000)


SET @xmldoc = '
<ROOT>
	<GUEST>

		<GuestID>4431</GuestID>
		<GuestFirst>Lacey</GuestFirst>
		<GuestLast>Byington</GuestLast>
		<RESERVATIONDETAIL>
			<CheckInDate>2017-08-02</CheckInDate>
			<Nights>2</Nights>
		</RESERVATIONDETAIL>

	</GUEST>

	<GUEST>

	<GuestID>5563</GuestID>
	<GuestFirst>Jonathan</GuestFirst>
	<GuestLast>Langford</GuestLast>

	<RESERVATIONDETAIL>
		<CheckInDate>2017-08-05</CheckInDate>
		<Nights>2</Nights>
	</RESERVATIONDETAIL>

	</GUEST>

	<GUEST>

	<GuestID>6680</GuestID>
	<GuestFirst>Tanner</GuestFirst>
	<GuestLast>Olson</GuestLast>

	<RESERVATIONDETAIL>
		<CheckInDate>2017-09-11</CheckInDate>
		<Nights>3</Nights>
	</RESERVATIONDETAIL>

	</GUEST>
</ROOT>
'

 
EXEC sp_xml_preparedocument @idoc OUTPUT, @xmldoc
 
SELECT * FROM OPENXML (@idoc, '/ROOT/GUEST', 2)
WITH
(
	GuestID varchar(10) 'GuestID',
	GuestFirst varchar(20) 'GuestFirst',
	GuestLast varchar(20) 'GuestLast',
	CheckInDate date 'RESERVATIONDETAIL/CheckInDate'
)


GO

----------------------------------------------------------------------------------
-- #2 - Insert raw XML into FARMS database
----------------------------------------------------------------------------------

SET IDENTITY_INSERT Pickle_FARMS.dbo.Guest ON


DECLARE @idoc int
DECLARE @xmldoc nvarchar(4000)


SET @xmldoc = '
<ROOT>
	<GUEST>

		<GuestID>4431</GuestID>
		<GuestFirst>Lacey</GuestFirst>
		<GuestLast>Byington</GuestLast>
		<RESERVATIONDETAIL>
			<CheckInDate>2017-08-02</CheckInDate>
			<Nights>2</Nights>
		</RESERVATIONDETAIL>

	</GUEST>

	<GUEST>

	<GuestID>5563</GuestID>
	<GuestFirst>Jonathan</GuestFirst>
	<GuestLast>Langford</GuestLast>

	<RESERVATIONDETAIL>
		<CheckInDate>2017-08-05</CheckInDate>
		<Nights>2</Nights>
	</RESERVATIONDETAIL>

	</GUEST>

	<GUEST>

	<GuestID>6680</GuestID>
	<GuestFirst>Tanner</GuestFirst>
	<GuestLast>Olson</GuestLast>

	<RESERVATIONDETAIL>
		<CheckInDate>2017-09-11</CheckInDate>
		<Nights>3</Nights>
	</RESERVATIONDETAIL>

	</GUEST>
</ROOT>
'
 
EXEC sp_xml_preparedocument @idoc OUTPUT, @xmldoc

INSERT INTO Guest(GuestID, GuestFirst, GuestLast, GuestAddress1, GuestCity, GuestPostalCode, GuestCountry, GuestPhone, GuestEmail)
SELECT *, 'fake street', 'fake city', '88888', 'fakeland', '5555555555', 'fake@fake.com'
FROM
OPENXML(@idoc, '/ROOT/GUEST', 2)
WITH
(
	GuestID smallint 'GuestID',
	GuestFirst varchar(20) 'GuestFirst',
	GuestLast varchar(20) 'GuestLast'
)

GO

-- 2A

SELECT * FROM Guest

GO

----------------------------------------------------------------------------------
-- #3 - Drop database and linked server
----------------------------------------------------------------------------------

USE Master

GO

DROP DATABASE Pickle_FARMS

GO

EXEC sp_dropserver 'TITAN_Pickle', 'droplogins'

GO