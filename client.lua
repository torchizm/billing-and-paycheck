ESX = nil

local amount = 0
local tax = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	while true do
		player = GetPlayerPed(-1)
		Citizen.Wait(20 * 60000) -- 20 DAKİKA BEKLEME SÜRESİ - MAAŞ ALMA SÜRESİYLE AYNI
		ESX.PlayerData = ESX.GetPlayerData()
		local salary  = ESX.PlayerData.job.grade_salary
		tax = tax + 1
		if tax == 2 then
			ESX.TriggerServerCallback('torchizm:getCars', function(amount)
				if amount > 0 and amount ~= 0 then
					if ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "ambulance" or ESX.PlayerData.job.name == "sheriff" then
						TriggerServerEvent('torchizm:memurPayCheck', amount + 5)
						exports['mythic_notify']:SendAlert("inform", "Maaşından " .. amount + 5 .. "$ vergi kesildi!")
					else
						TriggerServerEvent('esx_billing:sendBill', -1, 'society_devlet', 'Devlet Vergisi (Araç + Motel)', amount + 5)
						exports['mythic_notify']:SendAlert("inform", amount + 5 .. "$ vergi geldi!")
					end
				else
					if ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "ambulance" or ESX.PlayerData.job.name == 'sheriff' then
						TriggerServerEvent('torchizm:memurPayCheck', 5)
						exports['mythic_notify']:SendAlert("inform", "Maaşından " .. 5 .. "$ vergi kesildi!")
					else
						TriggerServerEvent('esx_billing:sendBill', -1, 'society_devlet', 'Devlet Vergisi (Motel)', 5)
						exports['mythic_notify']:SendAlert("inform", "5$ vergi geldi!")
					end
				end
			end, GetPlayerServerId(player))
			tax = 0
		end
		TriggerServerEvent('torchizm:payCheck', -1)
	end
end)