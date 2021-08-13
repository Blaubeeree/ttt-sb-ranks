local TTTSBRanks = {}
local TTTSBSettings = {}
local TTTSBGroups = {}

net.Receive("ULX_TTTSBRanks", function()
    TTTSBRanks = net.ReadTable()
    TTTSBSettings = net.ReadTable()
    TTTSBGroups = net.ReadTable()

    gamemode.Call("ScoreboardCreate")

    if not input.IsKeyDown(KEY_TAB) then
        gamemode.Call("ScoreboardHide") -- Only hide if player isn't using scoreboard.
    end
end)

-- Based on rejax's "TTT Easy Scoreboard": https://github.com/rejax/TTT-EasyScoreboard
local function rainbow()
    local f = 0.5
    local t = RealTime()
    local r = math.sin(f * t) * 127 + 128
    local g = math.sin(f * t + 2) * 127 + 128
    local b = math.sin(f * t + 4) * 127 + 128

    return Color(r, g, b)
end

function TTTSBRanksDisplay(panel)
    panel:AddColumn(TTTSBSettings["column_name"] or "", function(ply, label)
        local rank = TTTSBRanks[ply:SteamID()] or TTTSBGroups[ply:GetUserGroup()]

        if rank then
            if rank.color == "colors" then
                label:SetTextColor(Color(rank.r, rank.g, rank.b))
            else
                label:SetTextColor(rainbow())
            end

            return rank.text
        else
            local defColor = TTTSBSettings["default_color"]

            if defColor ~= nil then
                label:SetTextColor(Color(defColor.red or 255, defColor.green or 255, defColor.blue or 255))
            else
                label:SetTextColor(Color(255, 255, 255))
            end

            return TTTSBSettings["default_rank"]
        end
    end, TTTSBSettings["column_width"] or 80)
end
hook.Add("TTTScoreboardColumns", "TTTSBRanksDisplay", TTTSBRanksDisplay)
