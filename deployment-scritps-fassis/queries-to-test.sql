--Rotas monitoradas pelo usuário
SELECT * FROM dbo.MonitoredRoutes

--Descrição das rotas
SELECT * FROM dbo.Routes WHERE Id = 100113

--Posição dos ônibus das rotas monitoradas
SELECT *, Location.ToString() FROM dbo.BusData

--Descrição dos poligonos monitorados
SELECT TOP (1000) [Id]
      ,[Name]
      ,[GeoFence]
      ,[GeoFence].ToString()
  FROM [dbo].[GeoFences]

SELECT * FROM [dbo].[GeoFencesActive]

SELECT TOP 10 * FROM [dbo].[GeoFencesActiveHistory] ORDER BY SysEndTime DESC

SELECT TOP 30 * FROM [dbo].[GeoFenceLog] WHERE VehicleId = 7459 ORDER BY Id DESC

DECLARE @payload VARCHAR(1000) = "
{
		"DirectionId": 1,
		"RouteId": 100001,
		"VehicleId": 2,
		"Position": {
			"Latitude": 47.61705102765316,
			"Longitude": -122.14291865504012 
		},
		"TimestampUTC": "20201031"
	}"
BEGIN TRAN
EXEC [web].[AddBusData] @payload
ROLLBACK
GO

SELECT *, b.[Location].ToString() FROM GeoFences g
CROSS JOIN BusData b
WHERE g.GeoFence.STContains(b.[Location]) = 1
POINT (-122.143242 47.61719)

DECLARE @payload VARCHAR(1000) = '[{"DirectionId": 1, "RouteId": "100113", "VehicleId": "7459", "Position": {"Latitude": 47.61719, "Longitude": -122.143242}, "TimestampUTC": "2023-11-21 21:13:36+00:00"}, {"DirectionId": 0, "RouteId": "100113", "VehicleId": "7360", "Position": {"Latitude": 47.59775, "Longitude": -122.11602}, "TimestampUTC": "2023-11-21 21:13:30+00:00"}, {"DirectionId": 1, "RouteId": "100113", "VehicleId": "7322", "Position": {"Latitude": 47.7038422, "Longitude": -122.114212}, "TimestampUTC": "2023-11-21 21:13:34+00:00"}]'
BEGIN TRAN
EXEC [web].[AddBusData] @payload
ROLLBACK