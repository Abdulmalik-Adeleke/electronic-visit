create database eVisit;

use eVisit;


-- Note:  Email feld is missing in all Relevant Table Containg User Information add them for fun

create table ApplicationUsersAuthenticationCognito
(
Username varchar(50),
FirstName nvarchar(50),
LastName nvarchar(50),
MobileNumber varchar(15),
Claim varchar(15), 
DeviceToken longtext,
InstitutionID varchar(25),
InstitutionType varchar(20)
);

-- SUPER USERS // for InsitutionType = Residential 
-- JOIN TABLE FOR FINDING ALL SUPER USERS FOR SOME SPECIFIC USE CASES
create table SuperUsers
(
Username varchar(50),
DeviceToken longtext,
InstitutionID varchar(25)
);

-- APP SPECIFIC IDENTIFICATION INFORMATION
create table Institutions
(
ID varchar(10),
InstitutionName longtext,
InstitutionType varchar(20),
BillingPlan varchar(15)
);
-- INSERT INTO Estates (`EstateID`, `EstateName`) VALUES
-- ('BananaISL', 'Banana ISLAND');

-- APP SPECIFIC IDENTIFICATION INFORMATION
create table BillingPlans
(
BillingPlan varchar(10),
BillingAmount decimal(15,2),
InstitutionType varchar(20)
);

create table InstitutionInformation
(
InstitutionID varchar(10),
InstitutionAdmin nvarchar(50),
InstitutionAdminMobile longtext,
InstitutionAdminEmail longtext,
InstitutionAddress nvarchar(250)
);


-- create table InstitutionBilling
-- (
-- InstitutionID varchar(10),
-- BillingPlan varchar(10),
-- BillingStatus varchar(10),
-- FirstBilling date,
-- LastBilling date
-- );

-- ONLY SUPER-USERS 
create table ResidentialSuperUsers
(
Username varchar(50),
FirstName nvarchar(50),
LastName nvarchar(50),
MobileNumber varchar(15),
DeviceToken longtext,
EstateID varchar(10)
);
-- INSERT INTO ResidentSuperUsers (`Username`, `FirstName`,`LastName`,`MobileNumber`,`DeviceToken`,`EstateID`) VALUES
-- ('aadeleke@bananaisland', 'ABDULMALIK','ADELEKE','+2348130008989','AeY384','BananaISL');

-- ALL RESIDENTS INCLUDING SUPER-USERS
-- Username, Email & SuperUser Fields are Registered By Property SuperUser
-- Residents insert into Cognito and Update Corresponding User Details and Device Token for Residents table

create table Residents
(
Username varchar(50),
SuperUser varchar(50),
FirstName nvarchar(50),
LastName nvarchar(50),
MobileNumber varchar(15),
DeviceToken longtext NOT NULL,
InstitutionID varchar(25)
);
create table Employees
(
Username varchar(50),
FirstName nvarchar(50),
LastName nvarchar(50),
MobileNumber varchar(15),
OfficeID int, -- join with CorporateRooms
DeviceToken longtext NOT NULL,
InstitutionID varchar(25)
);
-- INSERT INTO Residents (`Username`, `SuperUser`,`FirstName`,`LastName`,`MobileNumber`,`DeviceToken`,`EstateID`) VALUES
-- ('aadeleke@bananaisland','aadeleke@bananaisland', 'ABDULMALIK','ADELEKE','+2348130008989','AeY384','BananaISL');
-- INSERT INTO Residents (`Username`, `SuperUser`,`FirstName`,`LastName`,`MobileNumber`,`DeviceToken`,`EstateID`) VALUES
-- ('ofola@bananaisland','aadeleke@bananaisland', 'FOLA','ODE','+2348030008989','AeY335','BananaISL');
-- INSERT INTO Residents (`Username`, `SuperUser`,`FirstName`,`LastName`,`MobileNumber`,`DeviceToken`,`EstateID`) VALUES
-- ('pswazey@bananaisland','aadeleke@bananaisland', 'PATRICK','SWAZEY','+2348132308989','AeY005','BananaISL');

						/**QUERY TO SELECT SUB-USERS ATTACHED TO SUPER-USERS**/
-- SELECT s.Username as SuperUser, CONCAT(s.LastName,', ',s.FirstName) AS SuperUserName ,s.MobileNumber AS SuperUserMobile,e.EstateName AS Estate,
-- r.Username AS Resident, CONCAT(r.LastName,', ',r.FirstName) AS ResidentName,r.MobileNumber AS ResidentMobile
-- FROM ResidentSuperUsers AS s INNER JOIN Residents AS r 
-- ON s.Username = r.SuperUser
-- INNER JOIN  Estates AS e ON e.EstateID = s.EstateID
-- WHERE s.Username = 'aadeleke@bananaisland' AND r.Username <> 'aadeleke@bananaisland';

-- SELECT CONCAT('ADELEKE',', ','MALIK') AS SuperUserName;

-- ALL RESIDENTS INCLUDING SUPER-USERS
-- NOTE: REGISTERED ONLY BY ESTATE ADMIN AND PROPERTY SUPER USER
create table ResidentAddressesDB
(
ID  int AUTO_INCREMENT,
Username varchar(50), -- or Email varchar(50),
PropertyAddress nvarchar(250),
EstateID varchar(10)
);

-- WORK ON PROPERTIES TABLES FOR RESIDENTS, CORPORATE EMPLOYEES

-- create table Properties
-- (
-- ID  int AUTO_INCREMENT,
-- PropertyOwner varchar(50),
-- PropertyAddress nvarchar(250),
-- EstateID varchar(10)
-- );

create table EstateAddresses
(
-- no Primary Key ?
InstitutionID varchar(10), -- or EstateID
PropertyAddress nvarchar(250)
);

-- join 
create table CorporateRooms
(
ID  int AUTO_INCREMENT,
InstitutionID varchar(10),
CorporateBranch nvarchar(100),
Floor nvarchar(100),
Room nvarchar(100)
);
-- create table Tokens
-- (
-- ID  int AUTO_INCREMENT,
-- EstateID varchar(10),
-- Token varchar(50)
-- );

--   add some differentiation between resident schedules  and employee schedules (i.e: meetings.). some 'type' field ]
--   ScheduledVisits / History has a TTL before being shipped to S3
create table ScheduledVisits
(
ID  int AUTO_INCREMENT,
EstateID varchar(10),
ResidentUsername varchar(50),
PropertyAddress nvarchar(100),
DateOfVisit datetime,
VisitPeriodInMinutes int, 
VisitorFirstName nvarchar(50),
VisitorLastName nvarchar(50),
VisitorMobile nvarchar(50),
VisitorEmail nvarchar(50),
Token nvarchar(50)  UNIQUE NOT NULL-- make token a unique key
);

-- JOIN ScheduledVisits and DailyEntryLogs to help Institution Admin 
-- CRON job everyday to delete DailyEntryLogs where Status = Out
-- 
create table DailyEntryLogs -- For Scheduled Visits
(
ScheduledVisitID  int,
Token nvarchar(45),
InstitutionID varchar(25),
Status nvarchar(100) , -- scheduled/null, In, Out
TimeIn datetime,
TimeOut datetime
);

create table WalkInVisits
(
ID  int AUTO_INCREMENT,
EstateID varchar(10),
ResidentUsername varchar(50),
PropertyAddress nvarchar(100),
DateOfVisit datetime,
VisitPeriodInMinutes int, 
VisitorFirstName nvarchar(50),
VisitorLastName nvarchar(50),
VisitorMobile nvarchar(50),
VisitorEmail nvarchar(50),
VisitStatus  nvarchar(10)
);

create table ResidentsContacts
(
ID  int AUTO_INCREMENT,
Username varchar(50),
PropertyAddress nvarchar(100),
VisitorFirstName nvarchar(50),
VisitorLastName varchar(10),
VisitorMobile nvarchar(50),
VisitorEmail nvarchar(50),
BlacklistStatus boolean
);

create table EstateServiceMen
(
ID  int AUTO_INCREMENT,
EstateID varchar(10),
FirstName nvarchar(50),
LastName varchar(10),
Mobile nvarchar(50),
Email nvarchar(50),
BlacklistStatus boolean
);

create table PersonalServiceMen
(
ID  int AUTO_INCREMENT,
Username varchar(50),
PropertyAddress nvarchar(100),
FirstName nvarchar(50),
LastName varchar(10),
Mobile nvarchar(50),
Email nvarchar(50)
);

create table GlobalBlacklist
(
VisitorFirstName nvarchar(50),
EstateID varchar(10),
VisitorLastName varchar(10),
VisitorMobile nvarchar(50),
VisitorEmail nvarchar(50)
);

create table PropertyBlacklist
(
VisitorFirstName nvarchar(50),
VisitorLastName varchar(10),
VisitorMobile nvarchar(50),
VisitorEmail nvarchar(50),
PropertyAddress nvarchar(100),
EstateID varchar(10)
);




