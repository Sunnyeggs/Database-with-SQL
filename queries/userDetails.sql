SET @employeeID = 'E0034';

SELECT 
	e.name AS employee_name,
	m.name AS manager_name, 
	e.employeeID, 
	d.departmentName, 
    e.managerID 
FROM
	Employee e
LEFT JOIN
	Employee m ON e.managerID = m.employeeID
JOIN 
	department d ON d.departmentID = e.departmentID
WHERE 
	e.employeeID = @employeeID;
