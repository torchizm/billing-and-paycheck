ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('torchizm:getCars', function(source, cb, target)
	local identifier = GetPlayerIdentifiers(source)[1]
	
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @identifier", {
		['@identifier'] = identifier
	}, function(result)
		local count = 0
		if result ~= nil then
			for k,v in pairs(result) do
				if result[k].job == nil then
					count = count + 1
				end
			end
			cb(count)
		else
			cb(0)
		end
	end)
end)

RegisterServerEvent('torchizm:payCheck')
AddEventHandler('torchizm:payCheck', function()

	local xPlayer = ESX.GetPlayerFromId(source)
	local jobName = xPlayer.job.name
	local job     = xPlayer.job.grade_name
	local salary  = xPlayer.job.grade_salary
		
	if salary > 0 then
		if job == 'unemployed' then -- unemployed
			xPlayer.addAccountMoney('bank', salary)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = salary .. '$ işsizlik maaşın yatırıldı!'})
		else
			TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
				if society ~= nil then
					TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
						if jobName == 'police' or jobName == 'ambulance' or jobName == 'sheriff' then
							xPlayer.addAccountMoney('bank', salary)
							TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = salary .. '$ maaşın yatırıldı!'})
						else
							if account.money >= salary then
								xPlayer.addAccountMoney('bank', salary)
								account.removeMoney(salary)
								TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = salary .. '$ maaşın yatırıldı!'})
							else
								TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Şirketin maaşını ödeyemicek kadar kötü durumda!'})
							end
						end
						
					end)
				else
					xPlayer.addAccountMoney('bank', salary)
					TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = salary .. '$ maaşın yatırıldı!'})
				end
			end)
		end
	end
end)

RegisterServerEvent('torchizm:memurPayCheck')
AddEventHandler('torchizm:memurPayCheck', function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeAccountMoney('bank', amount)
end)