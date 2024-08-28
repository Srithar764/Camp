CREATE PROCEDURE [Camp].[usp_SaveManageSections] @section_name NVARCHAR(50),@is_deleted BIT
AS
BEGIN
	SET NOCOUNT ON;
		DECLARE
				@date DATETIME = SWITCHOFFSET(GETDATE(), '+05:30'),
				@sectionid INT;

		SELECT @sectionid = section_id 
		FROM Camp.Section
		WHERE section_name = @section_name;

		-- Handle INSERT/UPDATE or DEACTIVATE based on @is_deleted flag
		IF @is_deleted = 0
		BEGIN
			MERGE INTO Camp.Section AS t
			USING (
				SELECT 
					@section_name	AS section_name,
					1				AS is_active,
					@date			AS last_updated_date
			) AS s
			ON t.section_name = s.section_name
			WHEN MATCHED THEN 
				UPDATE 
				SET t.is_active			= s.is_active,
					t.last_updated_date = s.last_updated_date
			WHEN NOT MATCHED THEN 
				INSERT	(
							section_name, 
							is_active, 
							last_updated_date
						)
				VALUES	(
							s.section_name,
							s.is_active, 
							s.last_updated_date
						);
		END
		ELSE IF @is_deleted = 1
		BEGIN 
			UPDATE Camp.Section
			SET is_active = 0,
				last_updated_date = @date
			WHERE section_id = @sectionid;

			-- Reassign apps from the deleted section to a Others section
			UPDATE Camp.App_Catalog
			SET section_id = 3, -- section_id 3 is the 'Others' section
				last_updated_date = @date
			WHERE section_id = @sectionid;
		END;
END;

