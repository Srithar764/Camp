CREATE PROCEDURE Camp.usp_ReportUserLogin
    @login_id INT,
    @reported_by INT,
    @reported_reason VARCHAR(2000)
AS
BEGIN
    SET NOCOUNT ON;
    
		DECLARE @date DATETIME = SWITCHOFFSET(GETDATE(), '+05:30');

		UPDATE Camp.User_Login
		SET is_reported = 1
		WHERE login_id = @login_id;

		INSERT INTO Camp.Reported_login 
			(
				login_id, 
				reported_by, 
				reported_reason, 
				reported_date
			)
		VALUES 
			(
				@login_id,
				@reported_by, 
				@reported_reason,
				@date
			);
    
END;