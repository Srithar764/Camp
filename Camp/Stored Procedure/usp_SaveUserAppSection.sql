CREATE PROCEDURE [Camp].[usp_SaveUserAppSection] (
	@userid INT,
	@section_app_id INT,
	@IsDelete BIT = 0
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @current_date DATETIME = GETDATE();

	IF @IsDelete = 0
	BEGIN
		-- Insert or update the User_AppSection table for the specific user
		MERGE INTO [Camp].[User_AppSection_Mapping] AS target
		USING (
			SELECT @userid AS [User_Id],
				   @section_app_id AS section_app_id
		) AS source
		ON (
			target.[User_Id] = source.[User_Id]
			AND target.section_app_id = source.section_app_id
		)
		WHEN NOT MATCHED THEN
			INSERT (
				[User_Id],
				section_app_id,
				is_active,
				last_updated_date
			)
			VALUES (
				source.[User_Id],
				source.section_app_id,
				1,
				GETDATE()
			)
		WHEN MATCHED AND target.is_active = 0 THEN
			UPDATE
			SET target.is_active = 1,
				target.last_updated_date = GETDATE();
	END;
	ELSE IF @IsDelete = 1
	BEGIN
		-- Set is_active to 0 for the specific user and section
		UPDATE [Camp].[User_AppSection_Mapping]
		SET is_active = 0,
			last_updated_date = @current_date
		WHERE [User_Id] = @userid
			AND section_app_id = @section_app_id;

		-- Optionally, delete the specific user-section mapping if needed
		 DELETE FROM [Camp].[User_AppSection_Mapping]
		 WHERE [User_Id] = @userid
		 	AND section_app_id = @section_app_id;

	END;
END;
