CREATE PROCEDURE Camp.usp_addapps
	 @appname VARCHAR(50) 
	,@iconurl NVARCHAR(MAX) 
	,@appurl NVARCHAR(MAX) 
	,@description NVARCHAR(MAX)
	,@Section_id INT 
AS
BEGIN 
	SET NOCOUNT ON;

	DECLARE @current_date DATETIME = SWITCHOFFSET(GETDATE(), '+05:30');
	DECLARE @app_id INT;
	DECLARE @is_default BIT;

	SELECT @is_default = CASE WHEN @Section_id = 2 THEN 1 ELSE 0 END 
	FROM Camp.App_Catalog

	MERGE INTO Camp.App_Catalog AS t
	USING (
		SELECT @appname		AS [app_name],
		@iconurl			AS icon_url,
		@appurl				AS app_url,
		@description		AS [description],
		@is_default			AS is_default,
		@current_date		AS last_updated_date,
		1					AS is_active,
		@Section_id			AS section_id ) AS s

	ON t.[app_name] =s.[app_name] 
	AND  t.app_url = s.app_url
	
	WHEN NOT MATCHED THEN
	INSERT 
		(
			[app_name],
			icon_url,
			app_url,
			[description],
			is_default,
			last_updated_date,
			is_active,
			section_id 
		)
	VALUES
		(
			s.[app_name],
			s.icon_url,
			s.app_url,
			s.[description],
			s.is_default,
			s.last_updated_date,
			s.is_active,
			s.section_id 
		)
	WHEN MATCHED THEN
	UPDATE SET
			t.icon_url			= s.icon_url,
			t.app_url			= s.app_url,
			t.[description]		= s.[description],
			t.is_default		= s.is_default,
			t.last_updated_date = s.last_updated_date,
			t.section_id		= s.section_id; 

END;