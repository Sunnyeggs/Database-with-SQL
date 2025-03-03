CREATE DEFINER=`root`@`localhost` PROCEDURE `LeaveBenefit`(
    IN p_employeeID VARCHAR(10)
)
BEGIN
SELECT LB.leaveTypeID, LB.noOfDays, LT.leaveTypeName
FROM leavebenefits LB
INNER JOIN leavetype LT ON LT.leaveTypeID = LB.leaveTypeID
WHERE lb.designationID = (select e.designationID From emploYee e where e.employeeID = p_employeeID) 
AND lb.leaveTypeID IN (1, 2);

END