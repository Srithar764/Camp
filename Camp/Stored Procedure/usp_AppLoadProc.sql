CREATE PROCEDURE [Camp].[usp_AppLoadProc] (
/*
Author: Anushka Parasuraman
Created Date: 23-Jul-2024
About SP: Fetching User App details to App

Sample Execution:

EXEC [Camp].[usp_AppLoadProc] @user_id = 20, @sectionID = 2

*/
/* 
SP Change History Capture
-------------------------------------------------------------------
Date			ChangeBy		Reason
09-07-2024		Anushka P		Initial Write


-------------------------------------------------------------------
*/
	@user_id INT
	,@sectionID INT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @sectionID_Verify INT = NULL

	SELECT @sectionID_Verify = [section_id]
	FROM Camp.Section
	WHERE [section_name] = 'Arus Internals'

	IF @sectionID = @sectionID_Verify
	BEGIN
		SELECT ROW_NUMBER() OVER (
				ORDER BY ASM.[section_app_id] ASC
				) AS [SectionAppId]
			,S.section_id AS [SectionId]
			,S.Section_name AS [SectionName]
			,AC.app_id AS [ApplicationID]
			,AC.[app_name] AS [ApplicationName]
			,AC.icon_url AS [AppImage]
			,AC.app_url AS [AppURL]
			,AC.[description]
			,AC.last_updated_date AS [AppUpdatedDate]
		FROM Camp.App_Section_Mapping ASM
		JOIN Camp.Section S ON ASM.Section_id = S.Section_id
		JOIN Camp.App_Catalog AC ON AC.app_id = ASM.app_id
		WHERE S.section_id = @sectionID
			AND S.is_active = 1
			AND ASM.is_active = 1
			AND AC.is_active = 1
	END
	ELSE IF @sectionID = 1
	BEGIN
		SELECT ROW_NUMBER() OVER (
				ORDER BY ASM.[section_app_id] ASC
				) AS [SectionAppId]
			,S.section_id AS [SectionId]
			,S.Section_name AS [SectionName]
			,AC.app_id AS [ApplicationID]
			,AC.[app_name] AS [ApplicationName]
			,AC.icon_url AS [AppImage]
			,AC.app_url AS [AppURL]
			,AC.[description]
			,AC.last_updated_date AS [AppUpdatedDate]
		FROM Camp.App_Section_Mapping ASM
		JOIN Camp.Section S ON ASM.Section_id = S.Section_id
		JOIN Camp.App_Catalog AC ON AC.app_id = ASM.app_id
		WHERE S.section_id = @sectionID_Verify
			AND S.is_active = 1
			AND ASM.is_active = 1
			AND AC.is_active = 1
		
		UNION ALL
		
		SELECT uasm.section_app_id AS [SectionAppId]
			,S.section_id AS [SectionId]
			,S.Section_name AS [SectionName]
			,AC.app_id AS [ApplicationID]
			,AC.[app_name] AS [ApplicationName]
			,AC.icon_url AS [AppImage]
			,AC.app_url AS [AppURL]
			,AC.[description]
			,AC.last_updated_date AS [AppUpdatedDate]
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
	END
	ELSE
	BEGIN
		SELECT uasm.section_app_id AS [SectionAppId]
			,S.section_id AS [SectionId]
			,S.Section_name AS [SectionName]
			,AC.app_id AS [ApplicationID]
			,AC.[app_name] AS [ApplicationName]
			,AC.icon_url AS [AppImage]
			,AC.app_url AS [AppURL]
			,AC.[description]
			,AC.last_updated_date AS [AppUpdatedDate]
		FROM Camp.[user] U
		JOIN [Camp].[User_AppSection_Mapping] uasm ON uasm.[user_id] = u.[user_id]
		JOIN Camp.App_Section_Mapping ASM ON ASM.section_app_id = uasm.section_app_id
		JOIN Camp.Section S ON ASM.Section_id = S.Section_id
		JOIN Camp.App_Catalog AC ON AC.app_id = ASM.app_id
		WHERE u.[user_id] = @user_id
			AND S.[section_id] = ISNULL(@sectionID, S.[section_id])
			AND S.is_active = 1
			AND ASM.is_active = 1
			AND AC.is_active = 1
			AND UASM.[is_active] = 1
	END
END

