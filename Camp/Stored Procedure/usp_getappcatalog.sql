CREATE PROCEDURE [Camp].[usp_getappcatalog] @user_id INT 
AS
BEGIN
	SET NOCOUNT ON;
		SELECT 
			ac.app_id,
			ac.app_name,
			ac.icon_url,
			ac.app_url,
			ac.description,
			ac.is_default,
			s.section_name,
			CASE 
			 WHEN ac.section_id = 2 OR am.is_active = 1 AND am.user_id = @user_id THEN 1
			 ELSE 0
			END AS IsAdded
		FROM camp.App_Catalog AS ac

		JOIN camp.Section AS s
		ON s.section_id = ac.section_id

		LEFT JOIN camp.User_AppSection_Mapping AS am
		ON ac.app_id = am.app_id 
		AND am.user_id = @user_id

		WHERE ac.is_active = 1 

		ORDER BY IsAdded,s.section_name;
END;