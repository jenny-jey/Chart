/****** Object:  Table [dbo].[StockPrice]    Script Date: 10/07/2020 19:52:03 ******/
CREATE DATABASE SAMPLE
GO

USE [SAMPLE]
GO

/****** Object:  Table [dbo].[StockPrice]    Script Date: 10/07/2020 19:52:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PriceDetails](
    [ID] int identity,
	[HourWindow] [datetime] NOT NULL,
	[MarketPrice] [decimal](15, 8) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Most expensive HourWindow ******/
CREATE PROCEDURE dbo.spGetExpensiveHour
AS
  BEGIN TRY
  
 SELECT * INTO #Temp FROM
(
SELECT
	Id,
	HourWindow,
	MarketPrice,
	DENSE_RANK () OVER ( 
		ORDER BY MarketPrice DESC
	) price_rank 
FROM
	PriceDetails
	) as temp;
	
	select  top 2 ID, HourWindow, MarketPrice from #Temp
	where price_rank in (select price_rank from #Temp group by price_rank having count(price_rank) > 2
	order by price_rank OFFSET 0 ROWS)
	order by price_rank;

  END TRY
  BEGIN CATCH
   SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;
 
  END CATCH
GO