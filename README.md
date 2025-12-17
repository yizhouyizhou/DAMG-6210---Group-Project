🧠👥 HR Management Database

DAMG 6210 – Data Management and Database Design

A fully normalized Human Resources Management Database designed to support the complete HR lifecycle : from 🧑‍💼 recruitment and onboarding to 💰 payroll, 🎓 training, and 🕒 attendance, all while enforcing strong 🔐 security, 🧮 validation, and 📊 analytics.

🎯 Project Goals

Centralize HR data into one reliable system 🗄️

Enforce HR policies and compliance rules at the database level ✅

Reduce redundancy using Third Normal Form (3NF) ✂️

Enable reporting and analytics through reusable SQL views 📈

Protect sensitive employee data using encryption 🔐

✨ Key Features
🧩 Data Integrity & Business Rules

🔑 Primary Keys on all tables

🔗 Foreign Keys enforcing ERD relationships

🚫 UNIQUE constraints (e.g., candidate email, 1:1 payroll profile)

✔️ CHECK constraints (no self-approval, valid dates, non-negative salaries)

📋 Controlled vocabularies via lookup tables for all status fields

🧮 Advanced SQL Components

🧑‍💻 Computed column: FullName using dbo.fn_GetFullName

🛑 Function-based CHECK constraints validating employment and leave dates

🔐 Encrypted SSN storage using:

Master key 🔑

Certificate 📜

Symmetric key 🔒

Sensitive data stays protected and accessible only through authorized decryption.

🏗️ Core Data Model (High-Level)
👥 Core HR

Employee

Department

JobPosition

💰 Compensation

Payroll (1:1 with Employee)

Benefits

🧑‍💼 Recruiting

RecruitmentCandidate

CandidateApplication (supports multiple applications per candidate)

Interview

🎓 Development & Compliance

Training

EmployeeTraining (bridge table)

🕒 Time & Administration

Attendance

LeaveRequest

📚 Lookup Tables (Controlled Vocabularies)

Used to keep data consistent and clean 🧼 (small row counts):

EmploymentStatusLookup

LeaveTypeLookup

InterviewTypeLookup

InterviewResultLookup

TrainingStatusLookup

CandidateApplicationStatusLookup

AttendanceStatusLookup

🛡️ Governance Rules Implemented

📧 Candidate email must be unique

🗓️ Attendance unique per employee per day

💼 Payroll enforced as 1:1 with Employee

❌ Leave requests cannot be self-approved

📋 Status fields use lookup tables

🚫 No duplicate applications per candidate & position

🏢 Department manager must exist (FK + governance rule)

📊 Reporting Views (Analytics Layer)
📈 vEmployeePayrollSummary

Salary, department, position, and benefits in one view

Used for compensation and budgeting insights

🧑‍💼 vCandidatePipeline

Recruitment funnel from application to hire

Supports sourcing and pipeline analysis

🎓 vTrainingProgress

Training completion and compliance tracking

🕒 vLeaveApprovalOverview

Leave requests, approvals, and approvers

▶️ Demo Queries
SELECT TOP 5 * FROM Employee;
SELECT TOP 5 * FROM vEmployeePayrollSummary;
SELECT TOP 5 * FROM vCandidatePipeline;
SELECT TOP 5 * FROM vTrainingProgress;


These confirm that computed columns, joins, and constraints are working as expected ✅

📊 Dashboards (Tableau Public)
📊 Dashboard 1: Salary & Benefits Overview

Average salary by department

Pay frequency slicers

Headcount context

🧑‍💼 Dashboard 2: Recruitment Dashboard

Applications by position

Candidate source distribution (LinkedIn, referrals, job boards)

Recruiting insights at a glance 🔍

⚙️ Tech Stack

🗄️ Microsoft SQL Server

🧰 SQL Server Management Studio (SSMS)

📊 Tableau Public

📁 Excel (data extracts)

🚀 Getting Started

Run the SQL script in SSMS to create the database

Execute demo queries to validate functionality

Open Tableau Public and connect to the Excel extract

Explore dashboards and insights 🎉

👩‍💻👨‍💻 Contributors

Daiyin Yu, Yi Zhou, Rachel Vu

🎓 Course Info

DAMG 6210 – Data Management and Database Design
Northeastern University 🐾

🔮 Future Enhancements

☁️ Cloud deployment (Azure / AWS)

🔌 API integration with HR systems

🔐 Role-based access control

📦 Scalability & performance tuning

📊 Advanced workforce analytics


📁👩‍💻HR DB Project - Final Presentation Contents:
1. Presentation Deck
File: HR Database Presentation Deck Group 7.pdf
A slide deck summarizing the ERD design, SQL implementation, constraints, functions, encryption features, and Tableau/Power BI visualizations.
This deck is used to guide the recorded presentation.

2. Presentation Video
File: HR Database Video Presentation Group 7.mp4
A 13-minute walkthrough explaining our HR database the database design decisions, ERD, SQL implementation highlights, demo queries, and HR analytics dashboards created from the database.

3. SQL Implementation File
File: HR_Database_SQL_Implementation.sql
Contains all DDL statements, constraints, lookup tables, functions, computed columns, encryption setup, and reporting views.

4. HR Database Project ERD
The final Entity-Relationship Diagram illustrating the full HR data model including tables, primary keys, foreign keys, cardinalities, lookup tables, and governance rules.

5.Human Resources Database Design Document.pdf
A comprehensive design specification outlining entities, attributes, normalization, relationships, governance rules, and sample queries supporting HR workflows.

6. HR DB Project Visual.twbx
Two visualizations using a data mining tool Tableau.

