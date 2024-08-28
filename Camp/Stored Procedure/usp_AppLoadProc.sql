CREATE PROCEDURE [Camp].[usp_AppLoadProc]  
@user_id INT ,
@section_id INT 
AS
BEGIN
	SET NOCOUNT ON;
		WITH Defaults AS (
			SELECT 
				ac.app_id,
				ac.app_name,
				ac.icon_url,
				ac.app_url,
				ac.description,
				ac.is_default,
				s.section_id,
				s.section_name
			FROM camp.App_Catalog AS ac

			JOIN camp.Section AS s 
			ON s.section_id = ac.section_id

			WHERE s.section_id = 2
		),
		UserApps AS (
			SELECT 
				ac.app_id,
				ac.app_name,
				ac.icon_url,
				ac.app_url,
				ac.description,
				ac.is_default,
				s.section_id,
				s.section_name
			FROM camp.App_Catalog AS ac
			JOIN camp.Section AS s ON s.section_id = ac.section_id
			JOIN camp.User_AppSection_Mapping AS am ON ac.app_id = am.app_id
			WHERE am.is_active = 1 AND am.user_id = @user_id
		)
		SELECT * 
		FROM Defaults AS d
		WHERE @section_id = '' OR @section_id = 2

		UNION

		SELECT * 
		FROM UserApps AS u
		WHERE @section_id = '' 
		OR u.section_id = @section_id;
END;