CREATE PROCEDURE [Camp].[usp_UpdateReportedLoginAction]
    @report_id INT,
    @user_id INT,
    @comments VARCHAR(2000),
	@status_id INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @date DATETIME = SWITCHOFFSET(GETDATE(), '+05:30')

		UPDATE Camp.Reported_login
		SET 
			action_taken_by		= CASE WHEN @status_id <> 3 THEN  @user_id ELSE NULL END,
			comments			= @comments,
			action_date			= CASE WHEN @status_id <> 3 THEN  @date ELSE NULL END,
			status_id			= @status_id
		WHERE report_id = @report_id;
END;