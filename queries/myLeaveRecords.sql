SET @employeeID = 'E0001';
SET @selected_leaveTypeName = 'Annual Leave'; -- Assign value to leave type variable
SET @selected_statusName = 'Pending Approval'; -- Assign value to status name variable
SET @selected_year = '2000'; -- Assign value to year variable

SELECT lr.recordID, lt.leaveTypeName, lr.startDate, lr.endDate, ls.statusName, lr.numberOfDays
FROM leaveRecord lr
JOIN leaveType lt ON lr.leaveTypeID = lt.leaveTypeID
JOIN leaveStatus ls ON lr.statusID = ls.statusID
WHERE lr.employeeID = @employeeID
AND (lt.leaveTypeName = @selected_leaveTypeName OR @selected_leaveTypeName IS NULL) -- Filter by selected leave type name
AND (ls.statusName = @selected_statusName OR @selected_statusName IS NULL) -- Filter by selected status name
AND (YEAR(lr.startDate) = @selected_year OR @selected_year IS NULL); -- Filter by selected year

-- insert for testing--
#INSERT INTO leaveRecord 
#values
#('1001', 'E0001', '1', '2000-01-01', '2000-01-03', '3', 'E0002', '81838386', 'InTown', 'nil', '1', '2000-01-01', null)


