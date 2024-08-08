CREATE TABLE [dbo].[Employee](
	[user_id] [smallint] NOT NULL,
	[emp_id] [nvarchar](50) NOT NULL,
	[full_name] [nvarchar](50) NOT NULL,
	[email] [nvarchar](100) NOT NULL,
	[profile_url] [nvarchar](max) NULL,
	[Designation] [varchar](50) NOT NULL,
	[Department] [varchar](50) NOT NULL,
	[Manager] [nvarchar](50) NOT NULL,
	[last_updated_date] [datetime] NOT NULL,
	[teams_name] [varchar](200) NULL,
	[gender] [varchar](1) NULL,
	[is_active] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

