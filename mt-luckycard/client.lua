local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('mt-luckycard:client:UsarCartao', function()
    local pData = QBCore.Functions.GetPlayerData()

    TriggerServerEvent('mt-luckycard:server:DarRecompesa', pData)
end)

RegisterNetEvent('mt-luckycard:client:ComprarCartao', function()
    TriggerServerEvent('mt-luckycard:server:ComprarCartao')
end)

CreateThread(function()
    RequestModel(`csb_isldj_03`)
      while not HasModelLoaded(`csb_isldj_03`) do
      Wait(1)
    end
    PedLottery = CreatePed(2, `csb_isldj_03`, Config.PedLoc, false, false)
      SetPedFleeAttributes(PedLottery, 0, 0)
      SetPedDiesWhenInjured(PedLottery, false)
      TaskStartScenarioInPlace(PedLottery, "missheistdockssetup1clipboard@base", 0, true)
      SetPedKeepTask(PedLottery, true)
      SetBlockingOfNonTemporaryEvents(PedLottery, true)
      SetEntityInvincible(PedLottery, true)
      FreezeEntityPosition(PedLottery, true)

    exports['qb-target']:AddBoxZone("PedLottery", Config.PedTargetLoc, 1, 1, {
        name="PedLottery",
        heading=0,
        debugpoly = false,
    }, {
        options = {
            {
                event = "mt-luckycard:client:ComprarCartao",
                icon = "fas fa-dollar-sign",
                label = "Buy Card",
            },
            {
                event = "mt-luckycard:client:UsarCartao",
                icon = "fas fa-coins",
                label = "Apply Card",
                item = "cartao_sorte"
            },
        },
        distance = 2.5
    })
end)