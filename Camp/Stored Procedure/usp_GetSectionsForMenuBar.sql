CREATE PROCEDURE [Camp].[usp_GetSectionsForMenuBar] @user_id INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT @user_id [user_id]
		,s.section_id
		,s.section_name
	FROM Camp.App_Section_Mapping ASM
	JOIN Camp.Section S ON ASM.Section_id = S.Section_id
	JOIN Camp.App_Catalog AC ON AC.app_id = ASM.app_id
	WHERE ASM.is_active = 1
		AND AC.is_active = 1
		AND S.section_id IN (
			SELECT [section_id]
			FROM Camp.Section
			WHERE [section_name] IN (
					'Arus Internals'
					,'All Apps'
					)
				AND [is_active] = 1
			)
	
	UNION
	
	SELECT DISTINCT U.[user_id]
		,s.section_id
		,s.section_name
	FROM Camp.[user] U
	JOIN [Camp].[User_AppSection_Mapping] uasm ON uasm.[user_id] = u.[user_id]
	JOIN Camp.App_Section_Mapping ASM ON ASM.section_app_id = uasm.section_app_id
	JOIN Camp.Section S ON ASM.Section_id = S.Section_id
	JOIN Camp.App_Catalog AC ON AC.app_id = ASM.app_id
	WHERE u.[user_id] = @user_id
		AND S.is_active = 1
		AND ASM.is_active = 1
		AND AC.is_active = 1
		AND UASM.[is_active] = 1

	UNION 
	 
	 SELECT DISTINCT @user_id [user_id]
			, Section_id 
			,Section_name
			FROM Camp.Section 
		    WHERE Section_id = 1

END;
