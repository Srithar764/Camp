CREATE PROCEDURE [Camp].[InsertRoleSP]
    @role_name NVARCHAR(50),
    @description NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @last_updated_date DATETIME = GETDATE();

    INSERT INTO [Camp].[Role] 
        (
            [role_name], 
            [description], 
            [last_updated_date]
        )
    VALUES 
        (
            @role_name, 
            @description, 
            @last_updated_date
        );
END;

