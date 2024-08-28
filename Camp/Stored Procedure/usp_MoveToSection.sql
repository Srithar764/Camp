CREATE PROCEDURE [Camp].[usp_MoveToSection] @section_id INT,@app_id INT 
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @date DATETIME = SWITCHOFFSET(GETDATE(), '+05:30');

		UPDATE Camp.App_Catalog
		SET section_id = @section_id,
			last_updated_date = @date
		WHERE app_id = @app_id
END;
