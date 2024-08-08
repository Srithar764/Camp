CREATE PROCEDURE [Camp].[usp_SaveManageSections] (
	 @userid INT
	,@sectionname VARCHAR(100)
	,@sectionid INT = NULL /*Sectionid applicable for UPDATE/DELETE action*/
	,@IsDelete BIT = 0 /*Action (0-Delete, 1-Insert/Update)*/
	,@Result SMALLINT OUTPUT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @current_date DATETIME = GETDATE();

	-- Perform the action based on the input parameter @IsDelete
	IF @IsDelete = 0
	BEGIN
		
		IF EXISTS (
				SELECT 1
				FROM [Camp].[Section]
				WHERE section_name = @sectionname
					AND is_active = 0
				)
		BEGIN
			UPDATE [Camp].[Section]
			SET is_active = 1 
				,last_updated_date = @current_date
			WHERE section_name = @sectionname;

			SET @Result = 2
		END
		ELSE IF NOT EXISTS (
				SELECT 1
				FROM [Camp].[Section]
				WHERE section_name = @sectionname
				)
		BEGIN
			INSERT INTO [Camp].[Section] (
				section_name
				,is_active
				,last_updated_date
				)
			VALUES (
				@sectionname
				,1
				,@current_date
				);

			SET @Result = 1
		END
	END
	ELSE IF @IsDelete = 1
	BEGIN
		-- Set is_active to 0 for the section in Camp.Section
		UPDATE [Camp].[Section]
		SET is_active = 0
			,last_updated_date = @current_date
		WHERE section_id = @sectionid;

		-- Delete the section mapping
	DELETE FROM [Camp].[User_AppSection_Mapping]
WHERE section_app_id IN (
    SELECT [section_app_id]
    FROM [Camp].[App_Section_Mapping]
    WHERE section_id =@sectionid
);

		SET @Result = 3
	END
	ELSE
	BEGIN
		SET @Result = - 1
	END;
END;

