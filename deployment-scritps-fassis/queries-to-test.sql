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

DECLARE @payload VARCHAR(1000) = '
{
		"DirectionId": 1,
		"RouteId": 100001,
		"VehicleId": 2,
		"Position": {
			"Latitude": 47.61705102765316,
			"Longitude": -122.14291865504012 
		},
		"TimestampUTC": "20201031"
	}'
BEGIN TRAN
EXEC [web].[AddBusData] @payload
ROLLBACK
GO

SELECT *, b.[Location].ToString() FROM GeoFences g
CROSS JOIN BusData b
WHERE g.GeoFence.STContains(b.[Location]) = 1
GO

DECLARE @payload VARCHAR(1000) = '[{"DirectionId": 1, "RouteId": "100113", "VehicleId": "7459", "Position": {"Latitude": 47.61719, "Longitude": -122.143242}, "TimestampUTC": "2023-11-21 21:13:36+00:00"}, {"DirectionId": 0, "RouteId": "100113", "VehicleId": "7360", "Position": {"Latitude": 47.59775, "Longitude": -122.11602}, "TimestampUTC": "2023-11-21 21:13:30+00:00"}, {"DirectionId": 1, "RouteId": "100113", "VehicleId": "7322", "Position": {"Latitude": 47.7038422, "Longitude": -122.114212}, "TimestampUTC": "2023-11-21 21:13:34+00:00"}]'
BEGIN TRAN
EXEC [web].[AddBusData] @payload
ROLLBACK

-- Script to create a second geoFence
INSERT INTO dbo.[GeoFences] 
	([Name], [GeoFence]) 
VALUES
	('Crossroads', 0xE6100000010407000000B4A78EA822CF4740E8D7539530895EC03837D51CEACE4740E80BFBE630895EC0ECD7DF53EACE4740E81B2C50F0885EC020389F0D03CF4740E99BD2A1F0885EC00CB8BEB203CF4740E9DB04FC23895EC068C132B920CF4740E9DB04FC23895EC0B4A78EA822CF4740E8D7539530895EC001000000020000000001000000FFFFFFFF0000000003);
GO

SELECT * FROM Routes WHERE ShortName = '226'

DELETE FROM MonitoredRoutes WHERE RouteId = 102552

INSERT INTO dbo.[MonitoredRoutes] (RouteId) VALUES (102552);

INSERT INTO GeoFences VALUES(2, 'Crossroads 226', GEOGRAPHY::STGeomFromText('POLYGON((-122.1332341432571 47.61568886376273,-122.1313780546188 47.61566716682802,-122.13139951229091 47.61637592870537,-122.12882459163662 47.61637592870537,-122.1288567781448 47.617634318979356,-122.13330924510952 47.61764155101983,-122.1332341432571 47.61568886376273))',4326))

UPDATE GeoFences
SET Name = 'Redmond Transit Center - Eastgate'
WHERE Id = 1

UPDATE GeoFences
SET Name = 'Bellevue Transit Center - Eastgate'
WHERE Id = 2

SELECT * FROM [MonitoredRoutes]

SELECT * FROM GeoFences

