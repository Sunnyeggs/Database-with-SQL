CREATE DEFINER=`root`@`localhost` PROCEDURE `LeaveBalance`(
in p_employeeID VARCHAR(10),
in p_year int
)
BEGIN

select leavebalance from leaveprofile where employeeID = p_employeeID and year = p_year;

END