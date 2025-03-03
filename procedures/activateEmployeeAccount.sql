DELIMITER //

CREATE PROCEDURE `activateEmployeeAccount` (
	IN p_employeeID VARCHAR(10),
    IN p_name VARCHAR(255),
    IN p_departmentID INT,
    IN p_designationID INT,
    IN p_managerID VARCHAR(10),
    IN p_roleID INT,
    IN p_email VARCHAR(255),
    IN p_createdBy VARCHAR(10)
)
BEGIN
    DECLARE v_password VARCHAR(255);
    
    -- Step 1: Insert into Employee table and get employeeID
    INSERT INTO Employee (employeeID, name, departmentID, designationID, managerID, roleID, email, isActive, startDate, createdBy, modifiedBy)
    VALUES (p_employeeID, p_name, p_departmentID, p_designationID, p_managerID, p_roleID, p_email, TRUE, CURDATE(), p_createdBy, p_createdBy);
    
	SELECT CONCAT(SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ', FLOOR(RAND() * 25) + 1, 1),
                  SUBSTRING('abcdefghijklmnopqrstuvwxyz', FLOOR(RAND() * 25) + 1, 1),
                  SUBSTRING('0123456789', FLOOR(RAND() * 9) + 1, 1),
                  SUBSTRING('!@#$%^&*()', FLOOR(RAND() * 9) + 1, 1)) INTO v_password;
    
    -- Step 3: Insert into Account table
    INSERT INTO Account (employeeID, password, roleID, status, failedLoginAttempts, lastLoginTime, createdOn, modifiedOn)
    VALUES (p_employeeID, v_password, p_roleID, 'active', 0, NULL, NOW(), NOW());
    
    -- Step 4: Insert leave profiles for each leave type based on the employee's designation
    INSERT INTO leaveProfile (employeeID, leaveTypeID, year, carriedForward, previousYear, currentYear, currentYearAdjustment, leaveTaken, leaveBalance)
    SELECT p_employeeID, lb.leaveTypeID, YEAR(CURDATE()), 0, 0, lb.noOfDays, 0, 0, lb.noOfDays
    FROM leaveBenefits lb
    WHERE lb.designationID = p_designationID AND lb.isActive = TRUE;
    
    SELECT p_employeeID AS NewEmployeeID, v_password AS RandomPassword;
END //

DELIMITER ;
