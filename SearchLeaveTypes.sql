-- create a table
CREATE PROCEDURE 'SearchLeaveTypes' (
    IN 'adminRole_ID' INT,
    IN 'input_leaveTypeID' INT 
)
BEGIN
--Ensure only an admin can perform the search
    if adminRole_ID = 1 THEN 
    SELECT
        LeaveTypeName,
        LeaveTypeCode,
        AttachmentRequired,
        IsActive,
        CreatedBy,
        CreatedOn
    FROM
        LeaveType
    WHERE
    ('LeaveTypeID' = input_leaveTypeID OR input_leaveTypeID is null );
    ELSE
--If not andmin, provide an error message
SELECT 'Unauthorized Access' AS ErrorMessage;
END IF;
END//


        