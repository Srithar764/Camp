CREATE PROCEDURE [Camp].[usp_GetAndMarkUserNotifications]
    @UserID INT
AS
BEGIN
    -- Select the notifications for the user
    SELECT 
        notification_id, 
        Message, 
        is_read, 
        created_at
    FROM 
        Notifications
    WHERE 
        user_id = @UserID
    ORDER BY 
        created_at DESC;

    -- Mark the notifications as read
    --UPDATE Notifications
    --SET is_read = 0
    --WHERE user_id = @UserID;
END;
