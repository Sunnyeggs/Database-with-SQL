INSERT INTO Department (departmentName)
VALUES 
('Human Resources'),
('Finance'),
('Information Technology'), 
('Marketing'),
('Sales'),
('Operations');
select * from Department;

INSERT INTO Designation (designationName)
VALUES 
('Analyst'),
('Senior Analyst'),
('Manager'),
('Director'),
('Vice President'),
('CTO');
select * from designation;

INSERT INTO Role (roleName)
VALUES 
('Administrator'),
('User'),
('Manager');
select * from role;

INSERT INTO Employee (employeeID, name, departmentID, designationID, managerID, roleID, email, isActive, startDate, createdBy, modifiedBy)
VALUES
('E0001', 'Berlina Chan', 1, 3, NULL, 1, 'Berlina.chan@example.com', TRUE, '2021-01-10', 'E0001', 'E0001'),
('E0002', 'Jake Tan', 3, 3, NULL, 3, 'Jake.Tan@example.com', TRUE, '2021-02-15', 'E0001', 'E0001');
select * from Employee;

INSERT INTO Account (employeeID, password, roleID, status, failedLoginAttempts, lastLoginTime, createdOn, modifiedOn)
VALUES 
('E0001', 'hashed_password1', 1, 'active', 0, '2023-03-15 08:00:00', '2023-01-10 08:00:00', '2023-03-15 08:00:00'),
('E0002', 'hashed_password2', 3, 'active', 3, '2023-03-16 09:30:00', '2023-02-15 09:00:00', '2023-03-16 09:30:00');
select * from Account;
-- delete from Account where EmployeeID = 'E0003'

INSERT INTO leaveStatus (statusName, description) 
VALUES 
('Pending Approval', 'The leave request has been submitted and is awaiting approval.'),
('Approved', 'The leave request has been approved.'),
('Rejected', 'The leave request has been rejected.');
select * from leaveStatus;
--

CALL AuthenticateUser('E0001', 'hashed_password1', @p_status, @p_message);
SELECT @p_status, @p_message;

INSERT INTO leaveType (leaveTypeName, leaveTypeCode, attachmentRequired, isActive, createdBy, modifiedBy) 
VALUES 
('Annual Leave', 'AL', FALSE, TRUE, 'E0001', 'E0001'),
('Sick Leave', 'SL', TRUE, TRUE, 'E0001', 'E0001'),
('Maternity Leave', 'ML', TRUE, TRUE, 'E0001', 'E0001'),
('Paternity Leave', 'PL', TRUE, TRUE, 'E0001', 'E0001'),
('Casual Leave', 'CL', FALSE, TRUE, 'E0001', 'E0003'),
('Business Trip', 'BT', FALSE, TRUE, 'E0001', 'E0003'),
('Unpaid Leave', 'UL', FALSE, TRUE, 'E0001', 'E0001'),
('Study Leave', 'STL', TRUE, TRUE, 'E0001', 'E0001'),
('Volunteer Leave', 'VL', FALSE, TRUE, 'E0001', 'E0001'),
('Child Care Leave', 'SBL', TRUE, TRUE, 'E0001', 'E0001');
select * from leaveType;

INSERT INTO leaveBenefits (designationID, leaveTypeID, noOfDays, createdBy, modifiedBy) 
VALUES 
(1, 1, 20, 'E0001', 'E0001'), 
(1, 2, 30, 'E0001', 'E0001');
select * from leaveBenefits;

CALL activateEmployeeAccount('E0003', 'Junan He', 3, 1, 'E0002', 2, 'junnan.he@example.com', 'E0001');
select * from Employee;
select * from leaveProfile;
select * from Account;
-- delete from Account where EmployeeID = 'E0003'
-- delete from Employee where EmployeeID = 'E0003'
-- delete from leaveProfile where EmployeeID = 'E0003'

CALL AuthenticateUser('E0003', 'Rr4@', @p_status, @p_message);
SELECT @p_status, @p_message;

-- View Balance

CALL submitLeaveApplication(
    'E0003', -- p_employeeID for Junnan
    1, -- p_leaveTypeID for Vacation Leave
    '2024-02-012', -- p_startDate
    '2024-02-015', -- p_endDate
    3, -- p_numberOfDays
    'E0002', -- p_coveringEmployeeID for Ajit
    '85237644', -- p_emergencyContact
    'InTown', -- p_location
    'Family trip', -- p_remarks
    1,
    'vacation_request.pdf', -- p_fileName (if an attachment was provided)
    'https://file-storage.com/vacation_request.pdf', -- p_fileLocation (URL or file path)
    'application/pdf', -- p_fileType (MIME type)
    1, -- p_createdBy (assuming Junnan created this record)
    @leaveRecordID, -- Output parameter for leaveRecordID
    @attachmentID -- Output parameter for attachmentID
);

-- To retrieve the output of the stored procedure
SELECT @leaveRecordID AS LeaveRecordID, @attachmentID AS AttachmentID;

SELECT * FROM leaveRecord;
SELECT * FROM attachments;
select * from leaveProfile;



