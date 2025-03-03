DELIMITER //

CREATE PROCEDURE `submitLeaveApplication` (
    IN p_employeeID VARCHAR(10),
    IN p_leaveTypeID INT,
    IN p_startDate DATE,
    IN p_endDate DATE,
    IN p_numberOfDays INT,
    IN p_coveringEmployeeID VARCHAR(10),
    IN p_emergencyContact VARCHAR(15),
    IN p_location ENUM('InTown', 'OutofTown'),
    IN p_remarks TEXT,
    IN p_statusID INT,
    IN p_fileName VARCHAR(255),
    IN p_fileLocation VARCHAR(255),
    IN p_fileType VARCHAR(50),
    IN p_createdBy INT,
    OUT p_leaveRecordID INT,
    OUT p_attachmentID INT
)
BEGIN
    DECLARE v_currentYear YEAR;

    -- Determine the current year
    SET v_currentYear = YEAR(CURDATE());

    -- Insert into leaveRecord table
    INSERT INTO leaveRecord (
        employeeID, leaveTypeID, startDate, endDate, numberOfDays, coveringEmployeeID, emergencyContact, location, remarks, statusID, CreatedOn
    )
    VALUES (
        p_employeeID, p_leaveTypeID, p_startDate, p_endDate, p_numberOfDays, p_coveringEmployeeID, p_emergencyContact, p_location, p_remarks, p_statusID, NOW()
    );

    -- Get the ID of the newly inserted leave record
    SET p_leaveRecordID = LAST_INSERT_ID();

    -- Check if an attachment is provided
    IF p_fileName IS NOT NULL AND p_fileLocation IS NOT NULL THEN
        -- Insert into attachments table
        INSERT INTO attachments (
            leaveRecordID, fileName, fileLocation, fileType, createdBy, createdOn
        )
        VALUES (
            p_leaveRecordID, p_fileName, p_fileLocation, p_fileType, p_createdBy, NOW()
        );

        -- Get the ID of the newly inserted attachment
        SET p_attachmentID = LAST_INSERT_ID();
        
        -- Update the leaveRecord with the attachmentID
        UPDATE leaveRecord SET attachmentID = p_attachmentID WHERE recordID = p_leaveRecordID;
        
    ELSE
        SET p_attachmentID = NULL; -- No attachment was added
    END IF;

    -- Update the leaveProfile to reflect the leave taken
    UPDATE leaveProfile 
    SET 
        leaveTaken = leaveTaken + p_numberOfDays,
        leaveBalance = leaveBalance - p_numberOfDays
    WHERE employeeID = p_employeeID AND leaveTypeID = p_leaveTypeID AND year = v_currentYear;
    
END //

DELIMITER ;
