CREATE PROCEDURE [Camp].[usp_GetUserNotifications]
    @UserID INT
AS
BEGIN
    -- Declare a table variable to hold the result
    DECLARE @RecentNotification TABLE (
        notification_id INT,
        Message NVARCHAR(MAX),
        is_read BIT,
        created_at DATETIME
    );
    
    -- Select the most recent notification for the specified user
    INSERT INTO @RecentNotification
    SELECT TOP 1 
        notification_id, 
        Message, 
        is_read, 
        created_at
    FROM Notifications
    WHERE user_id = @UserID
    ORDER BY created_at DESC;

    -- Update all notifications as read (1) for the specified user
    UPDATE Notifications
    SET is_read = 1
    WHERE user_id = @UserID;

    -- Return the most recent notification
    SELECT *
    FROM @RecentNotification;
END;
