function love.load()
    -- Load font
    Font = love.graphics.newFont(20)
    
    -- set window title
    love.window.setTitle("Pong Game")
    -- set window size
    love.window.setMode(900, 600)
    -- set background color
    love.graphics.setBackgroundColor(0.2, 0.2, 0.2)

    -- Paddle movement speed
    local pSpeed = 600
    
    -- Game state with two scores and winning score
    Game = {
        state = "start", -- changed from "playing" to "start"
        leftScore = 0,
        rightScore = 0,
        winningScore = 5  -- winning score threshold
    }
    
    -- Left Paddle
    PLeft = {
        x = 30,
        y = 200,
        speed = pSpeed,
        height = 100,
        width = 20
    }
    
    -- Right Paddle
    PRight = {
        x = love.graphics.getWidth() - 50,
        y = 200,
        speed = pSpeed,
        height = 100,
        width = 20
    }
    
    -- Ball
    resetBall()
end

function resetBall()
    -- Play sound on key press

    Ball = {
        x = 400,
        y = 300,
        dx = 300,  -- Ball speed in X direction
        dy = 300,  -- Ball speed in Y direction
        radius = 10
    }
end

function love.update(dt)
    if Game.state == "playing" then
        -- Left Paddle Movement (W/S)
        if love.keyboard.isDown("w") then
            PLeft.y = PLeft.y - PLeft.speed * dt
        elseif love.keyboard.isDown("s") then
            PLeft.y = PLeft.y + PLeft.speed * dt
        end
        PLeft.y = math.min(math.max(PLeft.y, 0), love.graphics.getHeight() - PLeft.height)
        
        -- Right Paddle Movement (Up/Down)
        if love.keyboard.isDown("up") then
            PRight.y = PRight.y - PRight.speed * dt
        elseif love.keyboard.isDown("down") then
            PRight.y = PRight.y + PRight.speed * dt
        end
        PRight.y = math.min(math.max(PRight.y, 0), love.graphics.getHeight() - PRight.height)
        
        -- Ball movement
        Ball.x = Ball.x + Ball.dx * dt
        Ball.y = Ball.y + Ball.dy * dt
        
        -- Top and bottom wall collisions
        if Ball.y - Ball.radius < 0 or Ball.y + Ball.radius > love.graphics.getHeight() then 
            Ball.dy = -Ball.dy 
        end

        if Ball.x + Ball.radius < 0 then
            Game.rightScore = Game.rightScore + 1
            if Game.rightScore >= Game.winningScore then
                Game.state = "gameover"
            else
                Game.state = "restartPrompt"
            end
            return
        elseif Ball.x - Ball.radius > love.graphics.getWidth() then
            Game.leftScore = Game.leftScore + 1
            if Game.leftScore >= Game.winningScore then
                Game.state = "gameover"
            else
                Game.state = "restartPrompt"
            end
            return
        end

        -- Left paddle collision
        if Ball.x - Ball.radius <= PLeft.x + PLeft.width and Ball.x > PLeft.x then
            if Ball.y >= PLeft.y and Ball.y <= PLeft.y + PLeft.height then
                Ball.dx = math.abs(Ball.dx)  -- ensure ball moves right
                Ball.x = PLeft.x + PLeft.width + Ball.radius
                Ball.dy = Ball.dy + (Ball.y - (PLeft.y + PLeft.height / 2)) * 2  -- Add angle variation
            end
        end

        -- Right paddle collision
        if Ball.x + Ball.radius >= PRight.x and Ball.x < PRight.x + PRight.width then
            if Ball.y >= PRight.y and Ball.y <= PRight.y + PRight.height then
                Ball.dx = -math.abs(Ball.dx)  -- ensure ball moves left
                Ball.x = PRight.x - Ball.radius
                Ball.dy = Ball.dy + (Ball.y - (PRight.y + PRight.height / 2)) * 2  -- Add angle variation
            end
        end
    end
end


function love.draw()
    -- Draw Left Paddle
    love.graphics.rectangle("fill", PLeft.x, PLeft.y, PLeft.width, PLeft.height)
    
    -- Draw Right Paddle
    love.graphics.rectangle("fill", PRight.x, PRight.y, PRight.width, PRight.height)
    
    -- Draw Ball
    love.graphics.circle("fill", Ball.x, Ball.y, Ball.radius)
    
    -- Draw Scores
    love.graphics.setFont(Font)
    love.graphics.print("Left Score: " .. Game.leftScore, 10, 10)
    love.graphics.print("Right Score: " .. Game.rightScore, love.graphics.getWidth() - 200, 10)

    if Game.state ~= "playing" then
        local winWidth = love.graphics.getWidth()
        local winHeight = love.graphics.getHeight()
        local msg = ""
        if Game.state == "start" then
            msg = "Press space to start"
        elseif Game.state == "restartPrompt" then
            msg = "Player missed! Press space to continue or escape to quit."
        elseif Game.state == "gameover" then
            if Game.leftScore == Game.rightScore then
                msg = "It's a tie! Press backspace to restart."
            else
                local winner = Game.leftScore > Game.rightScore and "Left" or "Right"
                msg = winner .. " Player wins! Press backspace to restart."
            end
        elseif Game.state == "paused" then
            msg = "Game Paused. Press 'p' to resume."
        end
        -- Darken background
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, winWidth, winHeight)
        love.graphics.setColor(1, 1, 1, 1)
        -- Center the message
        love.graphics.printf(msg, 0, winHeight/2 - Font:getHeight()/2, winWidth, "center")
    end
end

function love.keypressed(key)
    if Game.state == "restartPrompt" then
        if key == "space" then
            resetBall()
            Game.state = "playing"
        elseif key == "escape" then
            -- love.event.quit()
            -- game over and show the winner
            Game.state = "gameover"
        end
        return
    end

    if key == "p" then
        if Game.state == "playing" then
            Game.state = "paused"
        elseif Game.state == "paused" then
            Game.state = "playing"
        end
    elseif key == "space" then
        if Game.state == "start" or Game.state == "gameover" then
            Game.state = "playing"
            Game.leftScore = 0
            Game.rightScore = 0
            resetBall()
        elseif Game.state == "playing" then
            resetBall()  -- retains original behavior in playing state
        end
    elseif key == "backspace" then
        if Game.state == "gameover" then
            Game.state = "playing"
            Game.leftScore = 0
            Game.rightScore = 0
            resetBall()
        end
    end
end