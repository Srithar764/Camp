CREATE PROCEDURE [Camp].[usp_SaveUserAppSection]
@user_id INT,
@app_id INT ,
@is_listed BIT
AS 
BEGIN
	DECLARE @date DATETIME = SWITCHOFFSET(GETDATE(), '+05:30');

	SET NOCOUNT ON;
		IF @is_listed = 1
		BEGIN
			-- Add or update application in the user's list
			MERGE INTO Camp.User_AppSection_Mapping AS t
			USING (
				SELECT 
					@user_id	AS user_id,
					@app_id		AS app_id,
					1			AS is_active,
					@date		AS last_updated_date
			) AS s
			ON t.user_id = s.user_id 
			AND t.app_id = s.app_id

			WHEN NOT MATCHED THEN 
				INSERT 
					(
						user_id, 
						app_id, 
						is_active, 
						last_updated_date
					)
				VALUES 
					(
						s.user_id,
						s.app_id, 
						s.is_active,
						s.last_updated_date
					)
			WHEN MATCHED THEN 
				UPDATE SET
					t.is_active			= s.is_active,
					t.last_updated_date = s.last_updated_date;
		END
		ELSE IF @is_listed = 0
		BEGIN
			-- Remove application from the user's list
			UPDATE Camp.User_AppSection_Mapping
			SET
				is_active			= 0,
				last_updated_date	= @date
			WHERE user_id = @user_id
			AND app_id = @app_id;
		END;
END;
