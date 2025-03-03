CREATE DATABASE IF NOT EXISTS leavemanagementsystem;
USE leavemanagementsystem;

-- Creating the Department table
CREATE TABLE Department (
    departmentID INT AUTO_INCREMENT PRIMARY KEY,
    departmentName VARCHAR(100) UNIQUE NOT NULL 
);

-- Creating the Designation table
CREATE TABLE Designation (
    designationID INT AUTO_INCREMENT PRIMARY KEY,
    designationName VARCHAR(100) UNIQUE NOT NULL 
);

-- Creating the Role table
CREATE TABLE Role (
    roleID INT AUTO_INCREMENT PRIMARY KEY,
    roleName VARCHAR(100) UNIQUE NOT NULL 
);

-- Creating the Employee table
CREATE TABLE Employee (
    employeeID VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    departmentID INT,
    designationID INT,
    managerID VARCHAR(10),
    roleID INT,
    email VARCHAR(255) UNIQUE NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    startDate DATE,
    endDate DATE,
    createdOn DATETIME DEFAULT current_timestamp,
    createdBy VARCHAR(10), 
    modifiedOn DATETIME DEFAULT current_timestamp,
    modifiedBy VARCHAR(10),
    FOREIGN KEY (departmentID) REFERENCES department(departmentID),
    FOREIGN KEY (managerID) REFERENCES Employee(employeeID),
    FOREIGN KEY (designationID) REFERENCES Designation(designationID),
    FOREIGN KEY (roleID) REFERENCES Role(roleID)
);

-- Creating the Account table
CREATE TABLE Account (
    accountID INT AUTO_INCREMENT PRIMARY KEY,
    employeeID VARCHAR(10) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL, -- Assuming hashed passwords 
    roleID INT,
    status ENUM('active', 'locked', 'deactivated') DEFAULT 'active',
    failedLoginAttempts INT DEFAULT 0,
    lastLoginTime DATETIME,
    createdOn DATETIME DEFAULT CURRENT_TIMESTAMP,
    modifiedOn DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employeeID) REFERENCES Employee(employeeID),
    FOREIGN KEY (roleID) REFERENCES Role(roleID)
);

-- Creating the LeaveType table
CREATE TABLE leaveType (
    leaveTypeID INT AUTO_INCREMENT PRIMARY KEY,
    leaveTypeName VARCHAR(255) NOT NULL,
    leaveTypeCode VARCHAR(10) NOT NULL UNIQUE,
    attachmentRequired BOOLEAN NOT NULL DEFAULT FALSE,
    isActive BOOLEAN NOT NULL DEFAULT TRUE,
    createdBy VARCHAR(10) NULL,
    createdOn DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modifiedOn DATETIME DEFAULT current_timestamp,
    modifiedBy VARCHAR(10) NULL,
    FOREIGN KEY (createdBy) REFERENCES employee(employeeID)
);

 CREATE TABLE leaveStatus (
    statusID INT AUTO_INCREMENT PRIMARY KEY,
    statusName VARCHAR(255) NOT NULL UNIQUE,
    description TEXT
);

 CREATE TABLE leaveRecord (
    recordID INT AUTO_INCREMENT PRIMARY KEY,
    employeeID VARCHAR(10) NOT NULL,
    leaveTypeID INT NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    numberOfDays INT NOT NULL,
    coveringEmployeeID VARCHAR(10),
    emergencyContact VARCHAR(15),
    location ENUM('InTown', 'OutofTown') NOT NULL,
    remarks TEXT,
    statusID INT NOT NULL DEFAULT 1,
    CreatedOn DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employeeID) REFERENCES employee(employeeID),
    FOREIGN KEY (leaveTypeID) REFERENCES leaveType(leaveTypeID),
    FOREIGN KEY (coveringEmployeeID) REFERENCES employee(employeeID),
    FOREIGN KEY (statusID) REFERENCES leaveStatus(statusID)
);

 CREATE TABLE attachments (
    attachmentID INT AUTO_INCREMENT PRIMARY KEY,
    leaveRecordID INT NOT NULL,
    fileName VARCHAR(255) NOT NULL,
    fileLocation VARCHAR(255) NOT NULL, -- This could be a URL or file path
    fileType VARCHAR(50), -- MIME type like 'application/pdf'
    createdBy VARCHAR(10) NULL,
    createdOn DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modifiedOn DATETIME DEFAULT current_timestamp,
    modifiedBy VARCHAR(10) NULL,
    FOREIGN KEY (leaveRecordID) REFERENCES leaveRecord(recordID)
);

ALTER TABLE leaveRecord
ADD COLUMN attachmentID INT NULL,
ADD CONSTRAINT fk_attachmentID 
FOREIGN KEY (attachmentID) REFERENCES attachments(attachmentID);

CREATE TABLE leaveBenefits (
    benefitID INT AUTO_INCREMENT PRIMARY KEY,
    designationID INT NOT NULL,
    leaveTypeID INT NOT NULL,
    noOfDays INT NOT NULL,
    isActive BOOLEAN NOT NULL DEFAULT TRUE,
    createdBy VARCHAR(10) NULL,
    createdOn DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modifiedOn DATETIME DEFAULT current_timestamp,
    modifiedBy VARCHAR(10) NULL,
    FOREIGN KEY (leaveTypeID) REFERENCES leaveType(leaveTypeID),
    FOREIGN KEY (designationID) REFERENCES designation(designationID)
);

-- Creating the LeaveProfile table
CREATE TABLE leaveProfile (
    leaveProfileID INT AUTO_INCREMENT PRIMARY KEY,
    employeeID  VARCHAR(10) NOT NULL,
    leaveTypeID INT NOT NULL,
    year YEAR NOT NULL,
    carriedForward DECIMAL(5,1) NOT NULL DEFAULT 0.0,
    previousYear DECIMAL(5,1) NOT NULL DEFAULT 0.0,
    currentYear DECIMAL(5,1) NOT NULL DEFAULT 0.0,
    currentYearAdjustment DECIMAL(5,1) NOT NULL DEFAULT 0.0,
    leaveTaken DECIMAL(5,1) NOT NULL DEFAULT 0.0,
    leaveBalance DECIMAL(5,1) NOT NULL DEFAULT 0.0,
    FOREIGN KEY (employeeID) REFERENCES employee(employeeID),
    FOREIGN KEY (leaveTypeID) REFERENCES leaveType(leaveTypeID)
);




