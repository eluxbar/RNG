local webhooks = {
    -- general
    ['join'] = '/1244380863370760314/hV_6wtUBJpfIw-jrX6cHWAeKmEbuNFlvyDNn1eMS6fScLraNQez0T_rVL4VyVGQ8tr5s',
    ['leave'] = '/1244380933101060106/aMqSvLBb6lDuaZENSB4hsRIqA_QryubqtJL21er2EgluxQyMabQtv0TYNHWkt8E08s8F',
    ['steam'] = '/1244380975794753576/K-c2Xf0rhwOx4b31dgCqFHpVutoQ7Ac4jUEwygd9Hkh8JfTPwMD447Hx8PBH4yu4rvps',
    ['store-rob'] = '/1244381027384823869/yDYBoFs7lq9pH5vmEGPda9t8IXU5XBOJscCzr-oSCrhZnTEbhnE4VQWkqQgOiniUEISF',
    ['give-cash'] = '/1244381104719396946/R10oTgVqQ2FoetmVrv49nXFzIaYvXwrMzn4LSc28XOM7g4t5cRwuUReuQHwQ7ByjRPHD', 
    ['bank-transfer'] = '/1244381254376489141/b73nvnCb25jE9W9JdulUZexwnv8QmPjGxRFTZU141az1AviQRpCt36pyPcJ-Qwz9FwhU', 
    ['search-player'] = '/1244381304511004682/45Xv0_XehcZWtswT-JTC-3uUsoFiGwsx-wR14-fpMiGZPGl7p41ImCAqrXkajtqew51N', 
    ['gang'] = '/1244381366972579841/OCtr4GKnCiV74rjV-8dgqIYimIEwu2-vvZ5g3Pyq1u5SdUtBpPUJDU3zKG5uuMyu7nbz',
    ['licenses'] = '/1244381619083542610/wen-BEOPDJQqSxNBEC0PLA_2Hf8wRmAQrRXNEgDo7yIN4bNvWAMD3H6NTDQFT5ukakMz',
    ['rngplatclubkit'] = '/1195517350225645598/jk0lWTC0Wu2qBUaQKki5N_64hM7fHi_I5V3M9htMnpldwCaX_NCriKn8G_gKEOCGbx2l',
    ['rngplusclubkit'] = '/1195517350225645598/jk0lWTC0Wu2qBUaQKki5N_64hM7fHi_I5V3M9htMnpldwCaX_NCriKn8G_gKEOCGbx2l',
    ['addsubscription'] = '',
    ['housingsell'] = '',
    ['housingbuy'] = '',
    ['housingrent'] = '',
    -- chat
    ['ooc'] = '/1244382120453869752/eS2CUv0dpysVLXy3NFauaZZd2u4cCtGVWbhegSkLCUPJr6lfAt5m6FYWFBAWyt6bL0Kv', 
    ['global'] = '/1244382296967217202/pdyf-1kTjrIg7iUlG0Kx1cTowFGjeGokQuDX4JFBAkOrKTse2CmCFRNGpHRNBQF_UcEf', 
    ['staff'] = '/1244382460926492813/d_LWyRZF2G20Ot0w6BqEpCeIX-rFgCDRgCCl3RcmJm_f8df6KxCHi6bQennue5O_51xi',
    ['gang'] = '/1244382791307890809/dqxtnQsgc_ZDVZn--2ynUoVWw0xK1-UniNRLR12ZmK1mDHX9gj0HbnIaJYHRzIu9gCIy',
    ['anon'] = '/1244382930080370789/3heEbOSGSlOpgzDdgJ5AqyLE63QYTubIbiiDIobCjQ81NE574Qfta1Tm2jl7XDpW0fah', 
    ['announce'] = '/1244383380154613900/AlXofNeieTW1eYb_GUBCsHOB91W359Izg1FqDFUcmtsfpwa27xtXpqcJDcuDM2Z2gqrF',
    -- admin menu
    ['kick-player'] = '/1244383904543150150/6zV_jW00JnQhz2x1jzEJO6S8qUrlkGTVA-oDzsCl2JqWsAiyRyz0ctwBN10hMoK_316R', 
    ['ban-player'] = '/1244383983928741979/m79n7srTi7LxCzceJIjsvPJHnbdX35kOMGOIO72f3HMek_I5JOE8PsAsV2yRtjxuIT73', 
    ['spectate'] = '/1244384082612457503/HFUy6_1gwrphz4gw3s0zuwBXpX9kajEW00tFQmVdVOQgSWehlYnpE798eOh3k63VDDmP', 
    ['revive'] = '/1244386084201304107/kXbCJh-ERF1uC6FJtMtVRglIyDNoJ6_VhzSnXZL29BMW-mO7j5f2QkuYYlALlSsRzLeC', 
    ['tp-player-to-me'] = '/1244386213344051290/Hve-akMnca9ofp61qUJAon65OjKvBcKgZKYNBKiW6H-NDvRQeD7y5V_2nL8VUvhwUUjn', 
    ['tp-to-player'] = '/1244386321783459891/aeSR1t6FFynlqoN24hxZR_jtTWnqy2s_vjoWScZoBo5zUVkCF8kUlc026e6fVlXrMy57', 
    ['tp-to-admin-zone'] = '/1244389262523240560/E1V_13erIyw_p1zzR1uJmc2LFH6wUKec2rf_-kLgWN6spfcoNtKaAIopJG2mbqvLvMGB', 
    ['tp-back-from-admin-zone'] = '/1244389361030660147/ALybw5fG3XkmN_dzdPRRVM492_J3BXIumyN2h3CJKU3X6742w1hW4Ajd-osK1eHesgoJ', 
    ['tp-to-legion'] = '/1244389635980001431/Haqluqon1rvZXrtTjbnc9PKc42vsHLUhLLEUnP6yf32dowZ4r51D1puOhM-M9lBtxlcw', 
    ['freeze'] = '/1244389704133251172/92D-OtGkhRfXnq_Mmm496p9sssgncC-DP7oNm1ze_D2NREkYHbkL_HfDyACJdLRdKRnn', 
    ['slap'] = '/1244389782780514394/BE3FIMmlBXV6bMN9X2q5tOFPIznxV3ffuuzcQtGXCn9JeTkn8Xz26ZlcYaVLlT5mhjxu', 
    ['force-clock-off'] = '/1244390206707073086/HH-W8Hwwel2Mj9lyL5TSZ-aOAyZVQdFSrS0Tk4gSrsd9ib0BGjFx3chqxu3miYN2TS4f', 
    ['screenshot'] = '/1244390211782185092/Y9svCDr0pU0tIbxVYiuA-2evodQzhgkjnInK1jLUI0aN_69g2CkNnra4cSeCa7gDS5PT', 
    ['video'] = '/1244391611572555896/G8pS4xNgomoLZOAaGsEhTtvGuCyvyxn_ITazsJNItV8qLrJA94qW36CSEXHY_t16qypW', 
    ['group'] = '/1244395735781474407/OqcHomxHwHux2frc2aJGDMXNxl-xcw2-5u0Bq4QWSoDcuMZVup4Gk8M4PYxhS9cUVSmo', 
    ['unban-player'] = '/1244391724227493961/eoLufZxKGN8KDU1arJEea3sspKEIRrxmH07ijdsGfIxKj6BjLL8vQIrNz8-hzkCpQjld', 
    ['remove-warning'] = '/1244392113714761902/b9JGKzMMg5OevnIQmedeCRRxRPXw1mIsWAgUtm44C55ZfsRw_9Upejzf8UWYPp92tWA7', 
    ['add-car'] = '/1244392493374640238/SvpYCYpE_mgyvqK_HPA9bvU_BZKiiDjNMQF99YgCqZvd0-eHa6knE9XZAtHGZzaBEqM1', 
    ['manage-balance'] = '/1244403539589988462/Yp89FqHa5z-tWge57ciGNGgRvDpe9RP6XA3UZAXs5WDx7gZ0hkePMTA851UwqhNiWa21', 
    ['ticket-logs'] = '/1244393804077858879/FhWh0XFQIfDyCy0NVfktXJxobJfR677BB7z-vCo-BVscgGvOqD-YPfa392QYlv6sC0z8',
    ['com-pot'] = '/1244395959664902184/ZEb3tolBsMZneWseXN9eKGqtGbaAHIXOiZbXmVfOGqY2XsuvdaPy25_jN663mkx-alxt',
    ['staffdm'] = '/1244394013818359839/PMeYzV7es3jUPuYAXzMO8VDx81O_BN-sbvYh_GpkvHQUxsvv_aKfP807vqDo5xPP_m0h',
    -- vehicles
    ['crush-vehicle'] = '/1244394199743336498/cETFl1Oc17JdsbCuwLTlOT8pK-vtCdpPJ9aGXh6PRtQCkAVIqfCwNQxf0Khw0LWdmq-1', 
    ['rent-vehicle'] = '/1244394213370630144/nVk7JqyGgly42g4FGCGYmzWCf2WERj-v-W-MHVVKCdiCcjKIRkdnnQiw1D48mEGNR2_L', 
    ['sell-vehicle'] = '/1244394215534755890/WG_FWB9TjYHODOTQuGyqgxLX2c-booIFe-ylcpws5uLpKbShkwwKOhW328DnPF3SPq4C',
    ['spawn-vehicle'] = '/1244394217061486684/wI6RcJVMmGi5Ykk3_xn95Cm1V3fGZaGRjWGnWZgM2yIVaK3ZHYQUkN9blq_ZO_H5d_2p',

    -- mpd
    ['pd-clock'] = '/1244404926570827806/H9dwVeU_97cOF0ZlrDy2JvM3pqPhQVBM_RbajhP4tYfGT5TlpyP4DvhJ-E69_FfC2XGA',
    ['pd-afk'] = '/1244405179416186952/1kD9pMDscqBo4_I62UMgs6xweIH9849s3kHxeun3f-JnEdg9UoRQwqLdP60tuw3PFcHM',
    ['pd-armoury'] = '/1244405073552085082/28gNBuhvEhcN6bEwLwwtRvae1MmW6wzkuh04TFn51BtHYx_cBVCa3n7caBmT3-go3X-O',
    ['fine-player'] = '/1244406014103781490/4O9xRt39RN8WfXaLPggwKvOd7FmCLWyd6sRgsBA9eDFfPMGQr6AVk05T1hGnxpsDVpIG',
    ['jail-player'] = '/1244406014103781490/4O9xRt39RN8WfXaLPggwKvOd7FmCLWyd6sRgsBA9eDFfPMGQr6AVk05T1hGnxpsDVpIG',
    ['pd-panic'] = '/1244405266179428412/Gkj40VNN2ySeT3vRA48sOc7I6yclQSwYFNMdku1WxJC5joOtvRDDHjsijkJIIkjgVZT2',
    ['seize-boot'] = '/1244405419980361849/K7-vx55queI1c8mREJ-MrEkdxHA-aXMA5xGqgyj7VxODMixwHEwDYdA4L5JwOwSRoe7B',
    ['impound'] = '/1244405472552026133/rdqMadDLvs5azlEN73ESRMhH3NWUIp7G2UZw8phwC95C6gxF_IgB8FLow6F_6UvYA_aj',
    ['police-k9'] = '/1244405538448605324/tQnPVfxFy_KLTYqKDJJ7JO1CX8F101Gq9Gry5MfQ9oMftAG2aTGufBzUOCQ0y4fPNufO',
    ['pd-loadout'] = '1196501205954855123/kYVFv9cm2kauZV1By8yl8OSQGe-4WHSUZoeZkg4oPEVFK0Et2CvmgkxF9vWIwkw2eN7p',

    -- nhs
    ['nhs-clock'] = '',
    ['nhs-panic'] = '',
    ['nhs-afk'] = '',
    ['cpr'] = '',


    ['weapon-shops'] = '/1244382011150438462/abCEcE9E-T-rzdrMkWDFAqNROtfEjh-042JkQXitNrtC14ceP612L3mvtLKFT8K9axya', 
    -- licenses
    ['purchases'] = '/1191735314914488321/4C_AcXKCmb-Qm3p2O__iiPu_Br3trgMQJLE4U3kqUoJB84lX14TUNH7LOoZG2W9J3wWM', 
    -- casino
    ['blackjack-bet'] = '/1244394440387461214/_6xyN5Lu0Fz_tCTgsmvMViFsSoFdIkOrsggyImbnzkYtpLTADppQN1SEsnmLkMRlLE1q',  
    ['coinflip-bet'] = '/1244394443637784657/vXauNZ3jdpffiLpSL0gq6W8J3DgvGbjzPJbA3WdLVFgzIn0WHtiu3y1ePFnxNQ7BGYgi',  
    ['purchase-chips'] = '/1244394446494105640/OuGp4526Zj1wkvryVlSYfrQiyIALfmREjLUYmYgyeXq3Mhn_GNGw8kY4o4RfaUb6olx7',  
    ['sell-chips'] = '/1244394451124752474/_OIxLVOs4QskDdVN8Ofh5GNnjbETuM4s8u7Ev-4IY6_sa7WMGbNeZKDHf3c8arRkfxkv',  
    ['purchase-highrollers'] = '/1244394453507113004/EA3lsbVOOGbup5THvqHVeoAyhPliVCYF7O9RjQ6OMU-0YGF2OfSC3WIpPIc1FsUbHBgO',  

    -- anticheat
    ['anticheat'] = '/1244394889278390383/uEzOu1TVnbjscJMDR-l6dRUobms3fmFzQDJCnMIBeBM4OzYA7pYYslaJ2Az1WLRQ1OW7', 
    ['ban-evaders'] = '/1244394892956925983/HUX7dj5wm-9K30bZ6k3DxkzqCFNDs1lZb-bsTYRf_O1n_gnDO7px2WcXF1R2VkqcAckg',
    ['multi-account'] = '/1244394895242694719/PA1hnDcWpdT71imhD3xYWz7WJkB8FW7Dj7KeTdXSGGyeQe3-WRsr7HezQiWBatHvTi0v', 

    -- general
    ['killvideo'] = '/1244399002531926056/Z_k3XJt1jP3QlDzIW0umO10EpYG8E05nUy0b1YRZH5M3LOtX06c60GCRA94GtgtecDxm',
    ['kills'] = '/1244399033733349377/Y3Vv8fmGscjIrtjE18VRujCIJ02FhSi2G0Sgd_ZzO8NGV8qobR2rS_nmCtWSypdC40fN',
    ['damage'] = '/1244399035620790382/Uo9vuvJGSZwEBCCsGE7DgPS_HlzkUhyvj-i_Jk_GE8EbSnJ7o6xzYY5mhFLCDBAVcVQw',
    ['trigger-bot'] = '/1244399037948493875/5G6weBb__NEod_SzHpbS1WADIbZdeb6O44cC9ySuzqkJnUi_L6WRHH1jPGkL6Rr1ggIS',
    ['headshot'] = '/1244403539468484709/LW0IztEQ_PvkGEDtozvBWGMjqaNnDzYAakbcM9aA1FbILsc0WgO28wCIXKaDtdFuSSnn',
    -- store
    ['store-sell'] = '/1244398512926363751/uu5mBW0F7y1FLe4udqoAta6WwQcaD8lG75cd1NT20dAHTWyK0d6xrvZhQUidL5OEhMFl', 
    ['store-redeem'] = '/1244398519192785007/r_Y5lQVv3hCrZTeZj-uyz2uRL4T3od5H9BAi03slfLST8gCLdKVIBf50_3xrOaNkRYfw',
    ['tebex'] = '/1244398520933421098/a3FI7T8ymHpDRRHmOs2K192tyXGzBViHKTboWWKed3JVnOoxmbo5ItuzkVD6cMs1hwK6',
    ['donation'] = '/1244398522426720386/lC70nt9KfeYQrq-U_dNaeqvGlzB-6fXj6XMJ0-QAMJeeBShPNeYj9UeEFf4YRc0Bgta2',

    --management
    ['serveractions'] = '/1258164441170710709/YX1jOxJ_u9iFD6QCJiejAJeJ8hdQFX7GvRD5GY26mSBnzrAfJTKRVlv-6EHIPWCoNhMp',
}

local webhookQueue = {}
Citizen.CreateThread(function()
    while true do
        if next(webhookQueue) then
            for k,v in pairs(webhookQueue) do
                Citizen.Wait(100)
                if webhooks[v.webhook] ~= nil then
                    PerformHttpRequest(webhooks[v.webhook], function(err, text, headers) 
                    end, "POST", json.encode({username = "RNG Logs", avatar_url = 'https://i.postimg.cc/T1StrJLD/red-RNG.jpg', embeds = {
                        {
                            ["color"] = 0x40b0e7,
                            ["title"] = v.name,
                            ["description"] = v.message,
                            ["footer"] = {
                                ["text"] = "RNG - "..v.time,
                                ["icon_url"] = "",
                            }
                    }
                    }}), { ["Content-Type"] = "application/json" })
                end
                webhookQueue[k] = nil
            end
        end
        Citizen.Wait(0)
    end
end)
local webhookID = 1
function RNG.sendWebhook(webhook, name, message)
    webhookID = webhookID + 1
    webhookQueue[webhookID] = {webhook = webhook, name = name, message = message, time = os.date("%c")}
end

function RNG.getWebhook(webhook)
    if webhooks[webhook] ~= nil then
        return webhooks[webhook]
    end
end