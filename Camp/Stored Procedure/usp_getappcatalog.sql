CREATE PROCEDURE [Camp].[usp_getappcatalog] (@User_Id INT,@isdelete bit =0)
AS
BEGIN
	--DECLARE @User_Id INT = 37;
	--DECLARE @isdelete bit =0;
	SELECT ASM.section_app_id
		,U.[user_id]
		,AC.[app_id]
		,AC.[app_name]
		,AC.icon_url
		,AC.[description]
		,@isdelete as isdelete
		,  CASE 
        WHEN UAM.user_appsection_id IS NULL AND AC.is_default = 0 THEN 1
        ELSE 0
    END AS [is_active]
		--,IIF((UAM.user_appsection_id IS NULL, 1, 0) OR (AC.is_default = 1,0,1)) AS [is_active]
		
	--, UAM.*
	FROM [camp].[App_Catalog] AC WITH (NOLOCK)
	JOIN (
		SELECT *
		FROM [camp].[User] WITH (NOLOCK)
		WHERE [user_id] = @User_Id
		) U ON 1 = 1
	INNER JOIN [camp].[App_Section_Mapping] ASM ON ASM.[app_id] = AC.[app_id]
	LEFT JOIN [Camp].[User_AppSection_Mapping] UAM ON UAM.[section_app_id] = ASM.[section_app_id]
		AND UAM.[user_id] = U.[user_id]
		Where ASM.[is_active] = 1;
		
END;
