DELIMITER $$

CREATE PROCEDURE AuthenticateUser(
    IN p_employeeCode VARCHAR(10),
    IN p_password VARCHAR(255),
    OUT p_status VARCHAR(20),
    OUT p_message VARCHAR(100)
)
BEGIN
    DECLARE v_password VARCHAR(255);
    DECLARE v_status ENUM('active', 'locked', 'deactivated');
    DECLARE v_failedLoginAttempts INT;

    -- Attempt to retrieve the account based on the employeeCode
    SELECT password, status, failedLoginAttempts INTO v_password, v_status, v_failedLoginAttempts
    FROM Account
    WHERE employeeID = p_employeeCode;

    -- Check if account exists
    IF v_password IS NULL THEN
        SET p_status = 'Not Found';
        SET p_message = 'No account exists for the given employee code.';
    ELSE
        -- Check if account is locked or deactivated
        IF v_status = 'locked' THEN
            SET p_status = 'Locked';
            SET p_message = 'Your account is locked due to too many failed login attempts.';
        ELSEIF v_status = 'deactivated' THEN
            SET p_status = 'Deactivated';
            SET p_message = 'Your account has been deactivated. Please contact support.';
        ELSE
            -- Account is active; proceed with password check
            IF p_password = v_password THEN
                -- Password is correct, reset failedLoginAttempts and set lastLoginTime
                UPDATE Account SET failedLoginAttempts = 0, lastLoginTime = NOW()
                WHERE employeeID = p_employeeCode;
                
                SET p_status = 'Success';
                SET p_message = 'You have successfully logged in.';
            ELSE
                -- Password is incorrect, increment failedLoginAttempts
                UPDATE Account SET failedLoginAttempts = v_failedLoginAttempts + 1
                WHERE employeeID = p_employeeCode;
                
                -- Check if account should be locked
                IF v_failedLoginAttempts + 1 >= 5 THEN -- assuming 5 attempts allowed
                    UPDATE Account SET status = 'locked' WHERE employeeID = p_employeeCode;
                    SET p_status = 'Locked';
                    SET p_message = 'Your account has been locked due to too many failed login attempts.';
                ELSE
                    SET p_status = 'Fail';
                    SET p_message = 'The password you have entered is incorrect.';
                END IF;
            END IF;
        END IF;
    END IF;
END$$

DELIMITER ;
