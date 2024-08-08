CREATE PROCEDURE [Camp].[usp_addapps] (
	@appname VARCHAR(50)
	,@iconurl NVARCHAR(MAX)
	,@appurl NVARCHAR(MAX)
	,@description NVARCHAR(MAX)
	,@Section_id INT
	,@result SMALLINT OUTPUT
	)
AS
BEGIN
	SET NOCOUNT ON;-- This helps prevent extra result sets from interfering with SELECT statements.

	DECLARE @current_date DATETIME = GETDATE();
	DECLARE @app_id INT;
	DECLARE @sectionID_Internal INT = NULL

	SELECT @sectionID_Internal = [section_id]
	FROM Camp.Section
	WHERE [section_name] = 'Arus Internals'

	SET @sectionID_Internal = ISNULL(@sectionID_Internal, 0)

	-- Check if the app already exists
	IF NOT EXISTS (
			SELECT 1
			FROM [Camp].[App_Catalog]
			WHERE [app_name] = @appname
			)
	BEGIN
		-- Insert new app into App_Catalog
		INSERT INTO [Camp].[App_Catalog] (
			[app_name]
			,[icon_url]
			,[app_url]
			,[description]
			,[is_default]
			,[last_updated_date]
			)
		VALUES (
			@appname
			,@iconurl
			,@appurl
			,@description
			,IIF(@sectionID_Internal = @Section_id, 1, 0)
			,@current_date
			);

		SELECT @app_id = [app_id]
		FROM [Camp].[App_Catalog]
		WHERE [app_name] = @appname

		-- Update existing mapping in App_Section_Mapping
		MERGE INTO [Camp].[App_Section_Mapping] AS TARGET
		USING (
			SELECT @app_id AS [appid]
				,@section_id AS [sectionid]
				,1 AS [isactive]
			) AS SOURCE
			ON TARGET.[app_id] = SOURCE.[appid]
		WHEN MATCHED
			THEN
				UPDATE
				SET TARGET.[section_id] = SOURCE.[sectionid]
					,TARGET.[last_updated_date] = @current_date
		WHEN NOT MATCHED
			THEN
				INSERT (
					[section_id]
					,[app_id]
					,[last_updated_date]
					,[is_active]
					)
				VALUES (
					SOURCE.[sectionid]
					,SOURCE.[appid]
					,@current_date
					,SOURCE.[isactive]
					);

		SET @result = 1
	END
	ELSE
	BEGIN
		SET @result = - 1

		RAISERROR (
				'Appname already exists. Please enter new appname..!'
				,16
				,1
				);
	END
END;
