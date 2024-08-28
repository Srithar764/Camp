CREATE PROCEDURE [Camp].[usp_LoginCheck] @email VARCHAR(50)
AS
BEGIN 
	SET NOCOUNT ON;
 
		SELECT r.role_name AS [UserRole]
		FROM Camp.[User] AS u
 
		JOIN Camp.User_Role_Mapping AS ur
		ON u.[user_id] = ur.[user_id]
 
		JOIN Camp.[Role] AS r
		ON r.role_id = ur.role_id
 
		WHERE u.email = @email;
END;