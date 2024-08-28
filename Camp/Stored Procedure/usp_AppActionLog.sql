CREATE PROCEDURE Camp.usp_AppActionLog
		@app_id INT,
        @user_id INT ,
        @action_id INT 
AS
BEGIN
	SET NOCOUNT ON; 

		DECLARE 
				@comments VARCHAR(1000),
				@app_name VARCHAR(100),
				@name VARCHAR(100),
				@action VARCHAR(30),
				@date DATETIME = SWITCHOFFSET(GETDATE(), '+05:30');


		SELECT @name = full_name 
		FROM camp.[user]
		WHERE [user_id] = @user_id;

		SELECT @action = action_type 
		FROM camp.app_action_type
		WHERE action_type_id = @action_id;

		SELECT @app_name = app_name 
		FROM camp.app_catalog
		WHERE app_id = @app_id;
 
		SET @comments = CONCAT(@app_name, ' has been ', LOWER(@action), ' by ', @name);
 
		INSERT INTO Camp.App_Action_Log
					(
						app_id, 
						action_by, 
						action_type_id, 
						action_date, 
						comments
					)
		VALUES
					(
						@app_id, 
						@user_id,
						@action_id, 
						@date, 
						@comments
					);

END;
