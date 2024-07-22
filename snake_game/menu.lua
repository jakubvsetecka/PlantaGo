local composer = require("composer")
local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    local title = display.newText({
        text = "Snake Game",
        x = display.contentCenterX,
        y = display.contentCenterY - 50,
        fontSize = 40
    })
    sceneGroup:insert(title)

    local playButton = display.newText({
        text = "Play",
        x = display.contentCenterX,
        y = display.contentCenterY + 50,
        fontSize = 30
    })
    sceneGroup:insert(playButton)

    playButton:addEventListener("tap", function()
        composer.gotoScene("game")
    end)
end

scene:addEventListener("create", scene)
return scene
