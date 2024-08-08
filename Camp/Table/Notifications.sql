CREATE TABLE [Camp].[Notifications](
	[notification_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NULL,
	[message] [nvarchar](255) NULL,
	[is_read] [bit] NULL DEFAULT 0,
	[created_at] [datetime] NULL DEFAULT (getdate()),
PRIMARY KEY CLUSTERED ([notification_id] ASC)
)