DELIMITER //

CREATE PROCEDURE `searchLeaveRecords_Manager` (
    IN p_departmentID INT,
    IN p_leaveTypeID INT,
    IN p_leaveStatusID INT,
    IN p_year YEAR
)
BEGIN
    SELECT 
        lr.recordID AS LeaveID,
        lt.leaveTypeName AS LeaveType,
        e.employeeID AS employeeID,
        e.name AS FullName,
        lr.startDate AS StartDate,
        lr.endDate AS EndDate,
        ls.statusName AS Status,
        (select name from employee where e.managerID = employeeID) AS Approver,
        lr.numberOfDays AS NumberOfDays
    FROM 
        leaveRecord lr
    INNER JOIN 
        employee e ON lr.employeeID = e.employeeID
    INNER JOIN 
        leaveType lt ON lr.leaveTypeID = lt.leaveTypeID
    INNER JOIN 
        leaveStatus ls ON lr.statusID = ls.statusID
    WHERE 
        e.departmentID = p_departmentID
        AND (p_leaveTypeID IS NULL OR lr.leaveTypeID = p_leaveTypeID)
        AND (p_leaveStatusID IS NULL OR lr.statusID = p_leaveStatusID)
        AND (p_year IS NULL OR YEAR(lr.startDate) = p_year);
END //

DELIMITER ;

-- CALL searchLeaveRecords_Manager(3, 1, 1, 2024);
