CREATE PROCEDURE [Camp].[usp_GetSectionsForMenuBar] @user_id INT
AS
BEGIN
	SET NOCOUNT ON;

		WITH Defaults AS (
			SELECT 
				s.section_id,
				s.section_name
			FROM Camp.Section AS s 
			WHERE s.section_id IN (1, 2)
		),
		UserApps AS (
			SELECT DISTINCT
				s.section_id,
				s.section_name
			FROM camp.App_Catalog AS ac

			JOIN camp.Section AS s 
			ON s.section_id = ac.section_id

			JOIN camp.User_AppSection_Mapping AS am
			ON ac.app_id = am.app_id

			WHERE am.is_active = 1 
			  AND s.is_active = 1
			  AND am.user_id = @user_id
		)
		SELECT section_id, section_name
		FROM Defaults

		UNION

		SELECT section_id, section_name
		FROM UserApps AS u

		ORDER BY section_name
END;
