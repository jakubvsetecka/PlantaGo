local composer = require("composer")
local scene = composer.newScene()

local snake
local food
local moveTimer
local score = 0

local function gameLoop()
    -- Move the snake
    for i = #snake, 2, -1 do
        snake[i].x = snake[i-1].x
        snake[i].y = snake[i-1].y
    end

    -- Move the head
    if snake.direction == "up" then
        snake[1].y = snake[1].y - 20
    elseif snake.direction == "down" then
        snake[1].y = snake[1].y + 20
    elseif snake.direction == "left" then
        snake[1].x = snake[1].x - 20
    elseif snake.direction == "right" then
        snake[1].x = snake[1].x + 20
    end

    -- Check for collision with food
    if math.abs(snake[1].x - food.x) < 10 and math.abs(snake[1].y - food.y) < 10 then
        -- Eat food
        score = score + 1
        food.x = math.random(40, display.contentWidth - 40)
        food.y = math.random(40, display.contentHeight - 40)

        -- Grow snake
        local lastPiece = snake[#snake]
        local newPiece = display.newRect(lastPiece.x, lastPiece.y, 20, 20)
        newPiece:setFillColor(0, 1, 0)
        table.insert(snake, newPiece)
    end

    -- Check for collision with walls or self
    if snake[1].x < 0 or snake[1].x > display.contentWidth or
       snake[1].y < 0 or snake[1].y > display.contentHeight then
        composer.gotoScene("menu")
    end

    for i = 2, #snake do
        if math.abs(snake[1].x - snake[i].x) < 10 and math.abs(snake[1].y - snake[i].y) < 10 then
            composer.gotoScene("menu")
        end
    end
end

function scene:create(event)
    local sceneGroup = self.view

    snake = {display.newRect(display.contentCenterX, display.contentCenterY, 20, 20)}
    snake[1]:setFillColor(0, 1, 0)
    snake.direction = "right"

    food = display.newRect(math.random(40, display.contentWidth - 40),
                           math.random(40, display.contentHeight - 40), 20, 20)
    food:setFillColor(1, 0, 0)

    sceneGroup:insert(snake[1])
    sceneGroup:insert(food)

    moveTimer = timer.performWithDelay(150, gameLoop, 0)

    local function onTouch(event)
        if event.phase == "began" then
            local x = event.x - snake[1].x
            local y = event.y - snake[1].y
            if math.abs(x) > math.abs(y) then
                snake.direction = x > 0 and "right" or "left"
            else
                snake.direction = y > 0 and "down" or "up"
            end
        end
    end

    Runtime:addEventListener("touch", onTouch)
end

scene:addEventListener("create", scene)
return scene
