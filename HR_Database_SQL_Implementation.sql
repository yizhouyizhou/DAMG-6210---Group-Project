/* ============================================
   GROUP DATABASE PROJECT – PART 4
   HR_Management Database
   ============================================ */

CREATE DATABASE HR_Management;
GO

USE HR_Management;
GO


/* ============================================
   TABLE DEFINITIONS
   ============================================ */

-- Lookup: Employment Status
CREATE TABLE EmploymentStatusLookup (
    StatusID INT IDENTITY(1,1) PRIMARY KEY,
    StatusName VARCHAR(50) NOT NULL UNIQUE
);

-- Lookup: Leave Types
CREATE TABLE LeaveTypeLookup (
    LeaveTypeID INT IDENTITY(1,1) PRIMARY KEY,
    LeaveTypeName VARCHAR(50) NOT NULL UNIQUE
);

-- Lookup: Interview Types
CREATE TABLE InterviewTypeLookup (
    InterviewTypeID INT IDENTITY(1,1) PRIMARY KEY,
    InterviewTypeName VARCHAR(50) NOT NULL UNIQUE
);

-- Lookup: Interview Results
CREATE TABLE InterviewResultLookup (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    ResultName VARCHAR(50) NOT NULL UNIQUE
);

-- Lookup: Training Status
CREATE TABLE TrainingStatusLookup (
    TrainingStatusID INT IDENTITY(1,1) PRIMARY KEY,
    StatusName VARCHAR(50) NOT NULL UNIQUE
);

-- Lookup: Candidate Application Status
CREATE TABLE CandidateApplicationStatusLookup (
    ApplicationStatusID INT IDENTITY(1,1) PRIMARY KEY,
    StatusName VARCHAR(50) NOT NULL UNIQUE
);

-- Lookup: Attendance Status
CREATE TABLE AttendanceStatusLookup (
    AttendanceStatusID INT IDENTITY(1,1) PRIMARY KEY,
    StatusName VARCHAR(50) NOT NULL UNIQUE
);

-- Main: Department
CREATE TABLE Department (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    ManagerEmployeeID INT NULL   -- FK added after Employee exists
);

-- Main: Job Position
CREATE TABLE JobPosition (
    PositionID INT IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    ReportsTo INT NULL,  -- Self-referencing FK
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (ReportsTo) REFERENCES JobPosition(PositionID)
);

-- Main: Employee
CREATE TABLE Employee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender VARCHAR(20) NULL,
    Phone VARCHAR(20) NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Street VARCHAR(100) NULL,
    City VARCHAR(50) NULL,
    State VARCHAR(50) NULL,
    ZipCode VARCHAR(10) NULL,
    EmploymentStatus INT NOT NULL,   -- FK to EmploymentStatusLookup
    HireDate DATE NOT NULL,
    TerminationDate DATE NULL,
    JobPositionID INT NOT NULL,
    FOREIGN KEY (EmploymentStatus) REFERENCES EmploymentStatusLookup(StatusID),
    FOREIGN KEY (JobPositionID) REFERENCES JobPosition(PositionID)
);
GO

-- FK: Department manager must be an Employee
ALTER TABLE Department
ADD CONSTRAINT FK_Department_ManagerEmployee
    FOREIGN KEY (ManagerEmployeeID)
    REFERENCES Employee(EmployeeID);
GO

-- Main: Benefits Catalog
CREATE TABLE Benefits (
    BenefitsID INT IDENTITY(1,1) PRIMARY KEY,
    HealthPlan VARCHAR(100) NOT NULL,
    RetirementPlan VARCHAR(100) NOT NULL,
    EffectiveDate DATE NOT NULL
);

-- Main: Payroll (1:1 with Employee)
CREATE TABLE Payroll (
    PayrollID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL UNIQUE, -- Ensures 1:1 relationship
    Salary DECIMAL(12,2) NOT NULL CHECK (Salary >= 0),
    PayFrequency VARCHAR(20) NOT NULL CHECK (PayFrequency IN ('Weekly','Biweekly','Monthly')),
    BenefitsID INT NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (BenefitsID) REFERENCES Benefits(BenefitsID)
);

-- Main: Performance Evaluation
CREATE TABLE PerformanceEvaluation (
    EvaluationID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    EvaluationDate DATE NOT NULL,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comments VARCHAR(MAX),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Main: Training
CREATE TABLE Training (
    TrainingID INT IDENTITY(1,1) PRIMARY KEY,
    TrainingName VARCHAR(100) NOT NULL,
    Description VARCHAR(MAX),
    ComplianceRequired BIT NOT NULL
);

-- Main: Employee Training (bridge)
CREATE TABLE EmployeeTraining (
    EmployeeID INT NOT NULL,
    TrainingID INT NOT NULL,
    CompletionDate DATE NULL,
    Status INT NOT NULL,   -- FK to TrainingStatusLookup
    CertificateNumber VARCHAR(50) NULL,
    PRIMARY KEY (EmployeeID, TrainingID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (TrainingID) REFERENCES Training(TrainingID),
    FOREIGN KEY (Status) REFERENCES TrainingStatusLookup(TrainingStatusID)
);

-- Main: Recruitment Candidate
CREATE TABLE RecruitmentCandidate (
    CandidateID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20) NULL
);

-- Main: Candidate Application
CREATE TABLE CandidateApplication (
    ApplicationID INT IDENTITY(1,1) PRIMARY KEY,
    CandidateID INT NOT NULL,
    PositionID INT NOT NULL,
    ApplicationDate DATE NOT NULL,
    StatusID INT NOT NULL,   -- FK to CandidateApplicationStatusLookup
    Source VARCHAR(50) NULL,
    Notes VARCHAR(MAX),
    FOREIGN KEY (CandidateID) REFERENCES RecruitmentCandidate(CandidateID),
    FOREIGN KEY (PositionID) REFERENCES JobPosition(PositionID),
    FOREIGN KEY (StatusID) REFERENCES CandidateApplicationStatusLookup(ApplicationStatusID),
    CONSTRAINT UQ_Candidate_Position UNIQUE (CandidateID, PositionID)
);

-- Main: Interview
CREATE TABLE Interview (
    InterviewID INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationID INT NOT NULL,
    InterviewDate DATE NOT NULL,
    InterviewType INT NOT NULL,  -- FK to InterviewTypeLookup
    Result INT NULL,             -- FK to InterviewResultLookup
    Notes VARCHAR(MAX),
    FOREIGN KEY (ApplicationID) REFERENCES CandidateApplication(ApplicationID),
    FOREIGN KEY (InterviewType) REFERENCES InterviewTypeLookup(InterviewTypeID),
    FOREIGN KEY (Result) REFERENCES InterviewResultLookup(ResultID)
);

-- Main: Attendance
CREATE TABLE Attendance (
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    Date DATE NOT NULL,
    CheckIn TIME NULL,
    CheckOut TIME NULL,
    StatusID INT NOT NULL,   -- FK to AttendanceStatusLookup
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (StatusID) REFERENCES AttendanceStatusLookup(AttendanceStatusID),
    CONSTRAINT UQ_Attendance UNIQUE (EmployeeID, Date)
);

-- Main: Leave Request
CREATE TABLE LeaveRequest (
    LeaveID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    LeaveType INT NOT NULL,  -- FK to LeaveTypeLookup
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    ApprovalStatus VARCHAR(50) NOT NULL,
    ApproverID INT NOT NULL,
    RequestDate DATE NOT NULL,
    Notes VARCHAR(MAX),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (LeaveType) REFERENCES LeaveTypeLookup(LeaveTypeID),
    FOREIGN KEY (ApproverID) REFERENCES Employee(EmployeeID),
    CONSTRAINT CHK_NoSelfApproval CHECK (EmployeeID <> ApproverID)
);
GO


/* ============================================
   LOOKUP DATA (ALL TABLES ≥ 10 ROWS)
   ============================================ */

-- Employment Status values (10)
INSERT INTO EmploymentStatusLookup (StatusName) VALUES
('Active'),
('On Leave'),
('Terminated'),
('Suspended'),
('Retired'),
('Probation'),
('Contract'),
('Intern'),
('Part-Time'),
('Consultant');

-- Leave Types (10)
INSERT INTO LeaveTypeLookup (LeaveTypeName) VALUES
('Vacation'),
('Sick Leave'),
('Maternity'),
('Paternity'),
('Bereavement'),
('Unpaid Leave'),
('Study Leave'),
('Sabbatical'),
('Jury Duty'),
('Military Leave');

-- Interview Types (10)
INSERT INTO InterviewTypeLookup (InterviewTypeName) VALUES
('Phone'),
('Virtual'),
('On-Site'),
('Technical'),
('HR'),
('Panel'),
('Case Study'),
('Presentation'),
('Group'),
('Assessment Center');

-- Interview Results (10)
INSERT INTO InterviewResultLookup (ResultName) VALUES
('Pass'),
('Fail'),
('Pending'),
('Hold'),
('Offer Accepted'),
('Offer Declined'),
('No Show'),
('Cancelled'),
('Second Round'),
('Withdrawn');

-- Training Status values (10)
INSERT INTO TrainingStatusLookup (StatusName) VALUES
('Enrolled'),
('In Progress'),
('Completed'),
('Failed'),
('Expired'),
('Not Started'),
('Scheduled'),
('Deferred'),
('Waived'),
('On Hold');

-- Candidate Application Status values (10)
INSERT INTO CandidateApplicationStatusLookup (StatusName) VALUES
('Submitted'),
('Screening'),
('Interviewing'),
('Offer'),
('Rejected'),
('Hired'),
('Background Check'),
('On Hold'),
('Talent Pool'),
('Application Withdrawn');

-- Attendance Status values (10)
INSERT INTO AttendanceStatusLookup (StatusName) VALUES
('Present'),
('Late'),
('Absent'),
('Remote'),
('Excused'),
('Business Trip'),
('Training Day'),
('Holiday'),
('Sick Day'),
('Conference');


/* ============================================
   SAMPLE DATA FOR MAIN TABLES
   ============================================ */

-- Departments created first; managers assigned after employees exist
INSERT INTO Department (DepartmentName, ManagerEmployeeID)
VALUES
('Human Resources', NULL),
('Finance', NULL),
('IT', NULL),
('Marketing', NULL),
('Sales', NULL),
('Operations', NULL),
('Customer Support', NULL),
('Legal', NULL),
('Logistics', NULL),
('R&D', NULL);

-- Job positions aligned to departments
INSERT INTO JobPosition (Title, DepartmentID, ReportsTo)
VALUES
('HR Manager', 1, NULL),
('HR Associate', 1, 1),
('Finance Analyst', 2, NULL),
('IT Support Specialist', 3, NULL),
('Software Engineer', 3, NULL),
('Marketing Coordinator', 4, NULL),
('Sales Representative', 5, NULL),
('Operations Manager', 6, NULL),
('Customer Support Rep', 7, NULL),
('Legal Assistant', 8, NULL);

-- Ten recruitment candidates with unique emails
INSERT INTO RecruitmentCandidate (FirstName, LastName, Email, Phone)
VALUES
('Alex','Chen','alex.chen@email.com','555-111-0001'),
('Maria','Lopez','maria.lopez@email.com','555-111-0002'),
('James','Ward','james.ward@email.com','555-111-0003'),
('Sofia','Nguyen','sofia.nguyen@email.com','555-111-0004'),
('Daniel','Kim','daniel.kim@email.com','555-111-0005'),
('Liam','Patel','liam.patel@email.com','555-111-0006'),
('Ella','Martinez','ella.martinez@email.com','555-111-0007'),
('Noah','Singh','noah.singh@email.com','555-111-0008'),
('Grace','Hughes','grace.hughes@email.com','555-111-0009'),
('Ethan','Brooks','ethan.brooks@email.com','555-111-0010');

-- Applications reflect realistic hiring pipeline; first 5 become employees
INSERT INTO CandidateApplication (CandidateID, PositionID, ApplicationDate, StatusID, Source, Notes)
VALUES
(1, 1, '2024-01-05', 6, 'LinkedIn', 'Hired into HR Manager'),
(2, 2, '2024-01-10', 6, 'Indeed', 'Hired into HR Associate'),
(3, 3, '2024-01-12', 6, 'Referral', 'Hired into Finance Analyst'),
(4, 4, '2024-01-15', 6, 'Company Website', 'Hired into IT Support'),
(5, 5, '2024-01-20', 6, 'LinkedIn', 'Hired into Software Engineer'),
(6, 1, '2024-01-22', 5, 'Indeed', NULL),
(7, 3, '2024-01-25', 3, 'Referral', NULL),
(8, 2, '2024-01-28', 2, 'LinkedIn', NULL),
(9, 4, '2024-02-01', 3, 'Career Fair', NULL),
(10,5, '2024-02-04', 5, 'Indeed', NULL);

-- Interviews aligned to application timeline
INSERT INTO Interview (ApplicationID, InterviewDate, InterviewType, Result, Notes)
VALUES
(1, '2024-01-10', 1, 1, NULL),
(2, '2024-01-15', 2, 1, NULL),
(3, '2024-01-18', 3, 2, NULL),
(4, '2024-01-20', 1, 1, NULL),
(5, '2024-01-25', 2, 1, NULL),
(6, '2024-01-28', 3, 2, NULL),
(7, '2024-02-02', 1, 1, NULL),
(8, '2024-02-05', 2, 1, NULL),
(9, '2024-02-08', 3, 1, NULL),
(10,'2024-02-10', 1, 2, NULL);

-- Hired employees match CandidateApplication notes and positions
INSERT INTO Employee (FirstName, LastName, DateOfBirth, Gender, Phone, Email,
                      Street, City, State, ZipCode, EmploymentStatus,
                      HireDate, TerminationDate, JobPositionID)
VALUES
('Alex','Chen','1990-05-12','Male','555-222-1001','alex.chen@company.com','123 Main','LA','CA','90001',1,'2024-02-01',NULL,1),
('Maria','Lopez','1988-07-21','Female','555-222-1002','maria.lopez@company.com','77 Hill','LA','CA','90002',1,'2024-02-10',NULL,2),
('James','Ward','1992-02-10','Male','555-222-1003','james.ward@company.com','98 Pine','LA','CA','90003',1,'2024-02-12',NULL,3),
('Sofia','Nguyen','1995-03-15','Female','555-222-1004','sofia.nguyen@company.com','101 Oak','LA','CA','90004',1,'2024-02-20',NULL,4),
('Daniel','Kim','1991-09-01','Male','555-222-1005','daniel.kim@company.com','122 Elm','LA','CA','90005',1,'2024-02-25',NULL,5),
('Ella','Martinez','1993-11-08','Female','555-222-1007','ella.martinez@company.com','155 Cedar','LA','CA','90006',1,'2024-03-01',NULL,3),
('Noah','Singh','1989-10-19','Male','555-222-1008','noah.singh@company.com','220 Birch','LA','CA','90007',1,'2024-03-05',NULL,4),
('Grace','Hughes','1994-12-12','Female','555-222-1009','grace.hughes@company.com','300 Palm','LA','CA','90008',1,'2024-03-10',NULL,2),
('Ethan','Brooks','1990-06-30','Male','555-222-1010','ethan.brooks@company.com','455 Sunset','LA','CA','90009',1,'2024-03-12',NULL,5),
('Liam','Patel','1996-08-20','Male','555-222-1006','liam.patel@company.com','600 Vine','LA','CA','90010',1,'2024-03-15',NULL,1);

-- Ten benefits so Payroll FK aligns 1–10
INSERT INTO Benefits (HealthPlan, RetirementPlan, EffectiveDate)
VALUES
('Standard Health',        '401k Basic',       '2024-01-01'),
('Premium Health',         '401k Match',       '2024-01-01'),
('Executive Plan',         'Pension + 401k',   '2024-01-01'),
('Basic Health',           'No Retirement',    '2024-01-15'),
('Dental + Vision',        '401k Basic',       '2024-02-01'),
('High-Deductible Plan',   '401k Basic',       '2024-02-01'),
('Family Coverage',        '401k Match',       '2024-02-15'),
('HMO Health Plan',        '403b Option',      '2024-03-01'),
('PPO Health Plan',        '401k Basic',       '2024-03-01'),
('Wellness Plan',          'Pension Only',     '2024-03-10');

-- Payroll enforces 1:1 relationship with Employee
INSERT INTO Payroll (EmployeeID, Salary, PayFrequency, BenefitsID)
VALUES
(1, 75000, 'Monthly', 1),
(2, 68000, 'Monthly', 2),
(3, 72000, 'Monthly', 3),
(4, 65000, 'Monthly', 4),
(5, 90000, 'Monthly', 5),
(6, 70000, 'Monthly', 6),
(7, 68000, 'Monthly', 7),
(8, 66000, 'Monthly', 8),
(9, 82000, 'Monthly', 9),
(10,60000, 'Monthly', 10);

-- Attendance uses StatusID to match lookup values
INSERT INTO Attendance (EmployeeID, Date, CheckIn, CheckOut, StatusID)
VALUES
(1,'2024-03-20','09:00','17:00',1),
(2,'2024-03-20','09:05','17:00',1),
(3,'2024-03-20','08:55','17:10',1),
(4,'2024-03-20','09:10','17:00',2),
(5,'2024-03-20','09:00','17:00',1),
(6,'2024-03-20','09:00','17:00',1),
(7,'2024-03-20','09:03','17:00',1),
(8,'2024-03-20','09:00','17:00',1),
(9,'2024-03-20','09:15','17:05',2),
(10,'2024-03-20','09:00','17:00',1);

-- Leave requests with realistic durations
INSERT INTO LeaveRequest (EmployeeID, LeaveType, StartDate, EndDate,
                          ApprovalStatus, ApproverID, RequestDate, Notes)
VALUES
(1,1,'2024-03-10','2024-03-12','Approved',2,'2024-03-01',NULL),
(2,2,'2024-03-05','2024-03-06','Approved',1,'2024-02-27',NULL),
(3,1,'2024-03-15','2024-03-18','Pending',4,'2024-03-07',NULL),
(4,3,'2024-03-20','2024-03-22','Approved',3,'2024-03-10',NULL),
(5,1,'2024-03-25','2024-03-27','Approved',1,'2024-03-10',NULL),
(6,2,'2024-03-12','2024-03-14','Pending',2,'2024-03-05',NULL),
(7,4,'2024-03-18','2024-03-18','Approved',5,'2024-03-12',NULL),
(8,1,'2024-03-28','2024-03-29','Pending',4,'2024-03-15',NULL),
(9,5,'2024-03-20','2024-03-22','Approved',6,'2024-03-12',NULL),
(10,2,'2024-03-22','2024-03-23','Pending',3,'2024-03-15',NULL);

-- Trainings catalog
INSERT INTO Training (TrainingName, Description, ComplianceRequired)
VALUES
('Safety Training','Workplace safety basics',1),
('Diversity Training','Inclusivity and diversity program',1),
('Leadership 101','Intro to management',0),
('Advanced Excel','Excel certification prep',0),
('Cybersecurity Basics','Security practices',1),
('Customer Service','Handling customer interactions',0),
('Time Management','Productivity skills',0),
('Project Management','PM fundamentals',1),
('Communication Skills','Effective communication',0),
('Data Privacy','Sensitive data handling',1);

-- Employee training assignments (mix of completed and in progress)
INSERT INTO EmployeeTraining (EmployeeID, TrainingID, CompletionDate, Status, CertificateNumber)
VALUES
(1,1,'2024-03-15',3,'CERT-001'),
(2,2,'2024-03-16',3,'CERT-002'),
(4,4,'2024-03-18',3,'CERT-003'),
(5,5,'2024-03-19',3,'CERT-004'),
(3,3,NULL,2,NULL),
(8,8,NULL,2,NULL),
(6,6,NULL,1,NULL),
(7,7,NULL,1,NULL),
(9,9,NULL,4,NULL),
(10,10,NULL,5,NULL);


/* ============================================
   DATA VALIDATION QUERIES
   ============================================ */

-- Should all return zero rows if data is clean
SELECT Email, COUNT(*) AS DuplicateCount
FROM RecruitmentCandidate
GROUP BY Email
HAVING COUNT(*) > 1;

SELECT EmployeeID, Date, COUNT(*) AS DuplicateCount
FROM Attendance
GROUP BY EmployeeID, Date
HAVING COUNT(*) > 1;

SELECT CandidateID, PositionID, COUNT(*) AS DuplicateCount
FROM CandidateApplication
GROUP BY CandidateID, PositionID
HAVING COUNT(*) > 1;
GO


/* ============================================
   ADVANCED FEATURES & REPORTING
   ============================================ */

USE HR_Management;
GO

-- 1. User-defined functions (support computed column and CHECK constraints)
CREATE FUNCTION dbo.fn_GetFullName
(
    @FirstName VARCHAR(50),
    @LastName  VARCHAR(50)
)
RETURNS VARCHAR(101)
WITH SCHEMABINDING
AS
BEGIN
    RETURN LTRIM(RTRIM(
               ISNULL(@FirstName, '')
        + CASE WHEN @LastName IS NULL OR @LastName = '' THEN ''
               ELSE ' ' + @LastName
          END
    ));
END;
GO

CREATE FUNCTION dbo.fn_ValidateEmploymentDates
(
    @HireDate        DATE,
    @TerminationDate DATE
)
RETURNS BIT
AS
BEGIN
    IF (@TerminationDate IS NULL OR @TerminationDate >= @HireDate)
        RETURN 1;
    RETURN 0;
END;
GO

CREATE FUNCTION dbo.fn_ValidateLeaveDates
(
    @StartDate DATE,
    @EndDate   DATE
)
RETURNS BIT
AS
BEGIN
    IF (@EndDate IS NOT NULL AND @EndDate >= @StartDate)
        RETURN 1;
    RETURN 0;
END;
GO

-- 2. Computed column based on function
ALTER TABLE Employee
ADD FullName AS dbo.fn_GetFullName(FirstName, LastName) PERSISTED;
GO

-- 3. Table-level CHECK constraints based on functions
ALTER TABLE Employee
ADD CONSTRAINT CHK_Employee_ValidEmploymentDates
CHECK (dbo.fn_ValidateEmploymentDates(HireDate, TerminationDate) = 1);
GO

ALTER TABLE LeaveRequest
ADD CONSTRAINT CHK_LeaveRequest_ValidDates
CHECK (dbo.fn_ValidateLeaveDates(StartDate, EndDate) = 1);
GO

-- 4. Column data encryption for sensitive information
ALTER TABLE Employee
ADD SSN_Encrypted VARBINARY(256) NULL;
GO

CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'StrongP@ssw0rd_For_Class_Demo!';
GO

CREATE CERTIFICATE EmployeeSSN_Cert
WITH SUBJECT = 'Certificate for encrypting Employee SSN';
GO

CREATE SYMMETRIC KEY EmployeeSSN_Key
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE EmployeeSSN_Cert;
GO

OPEN SYMMETRIC KEY EmployeeSSN_Key
DECRYPTION BY CERTIFICATE EmployeeSSN_Cert;
GO

UPDATE Employee
SET SSN_Encrypted = EncryptByKey(
        Key_GUID('EmployeeSSN_Key'),
        CONVERT(VARBINARY(50),
            CASE EmployeeID
                WHEN 1 THEN '123-45-6789'
                WHEN 2 THEN '234-56-7890'
                WHEN 3 THEN '345-67-8901'
                WHEN 4 THEN '456-78-9012'
                WHEN 5 THEN '567-89-0123'
                WHEN 6 THEN '678-90-1234'
                WHEN 7 THEN '789-01-2345'
                WHEN 8 THEN '890-12-3456'
                WHEN 9 THEN '901-23-4567'
                WHEN 10 THEN '012-34-5678'
            END
        )
    )
WHERE EmployeeID BETWEEN 1 AND 10;
GO

-- Example decrypt query (for demonstration only)
SELECT
    EmployeeID,
    FullName,
    CONVERT(VARCHAR(50), DecryptByKey(SSN_Encrypted)) AS DecryptedSSN
FROM Employee;
GO

CLOSE SYMMETRIC KEY EmployeeSSN_Key;
GO

-- 5. Reporting views (more than two, used for business reporting)

-- 5.1 Employee + Payroll + Benefits summary
CREATE VIEW vEmployeePayrollSummary
AS
SELECT
    e.EmployeeID,
    e.FullName,
    d.DepartmentName,
    jp.Title        AS JobTitle,
    p.Salary,
    p.PayFrequency,
    b.HealthPlan,
    b.RetirementPlan,
    e.HireDate
FROM Employee e
JOIN JobPosition jp
    ON e.JobPositionID = jp.PositionID
JOIN Department d
    ON jp.DepartmentID = d.DepartmentID
JOIN Payroll p
    ON e.EmployeeID = p.EmployeeID
JOIN Benefits b
    ON p.BenefitsID = b.BenefitsID;
GO

-- 5.2 Candidate recruiting pipeline
CREATE VIEW vCandidatePipeline
AS
SELECT
    ca.ApplicationID,
    c.CandidateID,
    c.FirstName,
    c.LastName,
    c.Email         AS CandidateEmail,
    ca.ApplicationDate,
    cas.StatusName  AS ApplicationStatus,
    jp.Title        AS PositionTitle,
    d.DepartmentName,
    ca.Source
FROM CandidateApplication ca
JOIN RecruitmentCandidate c
    ON ca.CandidateID = c.CandidateID
JOIN JobPosition jp
    ON ca.PositionID = jp.PositionID
JOIN Department d
    ON jp.DepartmentID = d.DepartmentID
JOIN CandidateApplicationStatusLookup cas
    ON ca.StatusID = cas.ApplicationStatusID;
GO

-- 5.3 Employee training progress overview
CREATE VIEW vTrainingProgress
AS
SELECT
    et.EmployeeID,
    e.FullName,
    t.TrainingName,
    ts.StatusName  AS TrainingStatus,
    et.CompletionDate,
    t.ComplianceRequired
FROM EmployeeTraining et
JOIN Employee e
    ON et.EmployeeID = e.EmployeeID
JOIN Training t
    ON et.TrainingID = t.TrainingID
JOIN TrainingStatusLookup ts
    ON et.Status = ts.TrainingStatusID;
GO

-- 5.4 Leave requests with requester/approver names and leave types
CREATE VIEW vLeaveApprovalOverview
AS
SELECT
    lr.LeaveID,
    lr.EmployeeID,
    req.FullName     AS RequesterName,
    lr.ApproverID,
    appr.FullName    AS ApproverName,
    lt.LeaveTypeName,
    lr.StartDate,
    lr.EndDate,
    lr.ApprovalStatus,
    lr.RequestDate
FROM LeaveRequest lr
JOIN Employee req
    ON lr.EmployeeID = req.EmployeeID
JOIN Employee appr
    ON lr.ApproverID = appr.EmployeeID
JOIN LeaveTypeLookup lt
    ON lr.LeaveType = lt.LeaveTypeID;
GO
