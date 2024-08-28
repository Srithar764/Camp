CREATE PROCEDURE [Camp].[usp_GetUserDetails] @email VARCHAR(50)
AS
BEGIN 
	SET NOCOUNT ON;

		SELECT 
			 u.[user_id]	  AS [UserID]
			,u.emp_id		    AS [EmployeeID]
			,u.full_name	  AS [EmployeeName]
			,u.email		    AS [Email]
			,d.[name]		    AS [DepartmentName]
			,ds.[title]		  AS [Designation]
			,m.emp_id		    AS [ManagerID]
			,m.email		    AS [ManagerEmail]
			,m.[full_name]	AS [ManagerName]
		FROM Camp.[User] AS u

		JOIN Camp.User_Role_Mapping AS ur
		ON u.[user_id] = ur.[user_id]

		JOIN Camp.[User] AS m
		ON u.manager_id = m.[user_id]

		JOIN Camp.Department  AS d
		ON u.department_id = D.department_id

		JOIN Camp.Designation AS ds
		ON u.designation_id = ds.designation_id

		WHERE u.email = @email;
END;
