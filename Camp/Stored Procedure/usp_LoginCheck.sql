CREATE PROCEDURE [Camp].[usp_LoginCheck]
/*
Author: Anushka Parasuraman
Created Date: 08-Jul-2024
About SP: Fetching User & Section details to Login Page

Sample Execution:

DECLARE @Email VARCHAR(50) = 'anushka.p@arus.co.in';
DECLARE @result SMALLINT;

EXEC [Camp].[usp_LoginCheck] @Email, @result OUTPUT;

*/
/* 
SP Change History Capture
-------------------------------------------------------------------
Date			ChangeBy		Reason
09-07-2024		Anushka P		Initial Write

-------------------------------------------------------------------
*/
   @Email VARCHAR(50)
	,@result SMALLINT OUT
AS
BEGIN
	DECLARE @Userid INT;
	
	-- Retrieve the user_id based on the provided email
	SELECT @Userid = [user_id]
	FROM [camp].[User]
	WHERE email = @Email;

	IF @Userid IS NOT NULL
	BEGIN
		-- User details with department, designation, and admin role
		SELECT U.[user_id] AS [UserID]
			,U.emp_id AS [EmployeeID]
			,U.full_name AS [EmployeeName]
			,U.email AS [Email]
			,M.email AS [ManagerEmail]
			,M.emp_id AS [ManagerID]
			,M.[full_name] AS [ManagerName]
			,DP.[name] AS [DepartmentName]
			,DG.[title] AS [Designation]
			,IIF(R.[role_name] IS NOT NULL, 1, 0) AS [IsAdmin]
		FROM camp.[User] U WITH (NOLOCK)
		INNER JOIN Camp.[Department] DP WITH (NOLOCK) ON DP.[department_id] = U.[department_id]
		INNER JOIN Camp.[Designation] DG WITH (NOLOCK) ON DG.[designation_id] = U.[designation_id]
		LEFT JOIN Camp.[User] M WITH (NOLOCK) ON U.[manager_id] = M.[user_id]
		LEFT JOIN Camp.[User_Role_Mapping] URM WITH (NOLOCK) ON U.[user_id] = URM.[user_id]
		LEFT JOIN Camp.[Role] R WITH (NOLOCK) ON R.[role_id] = URM.[role_id]
			AND R.[role_name] = 'Admin'
		WHERE U.[user_id] = @Userid;

		SET @result = 1;
			 --Section details with Status
			SELECT [section_id]
				,[section_name]
				,[is_active]
			FROM [Camp].[Section]
	END
	ELSE
	BEGIN
		SET @result = - 1;
	END

	-- Output the result
	SELECT @result AS result;
END
