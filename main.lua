-- Game objects
local paddle1 = {
    x = 50,
    y = 250,
    width = 20,
    height = 100,
    speed = 400,
    score = 0
}

local paddle2 = {
    x = 730,
    y = 250,
    width = 20,
    height = 100,
    speed = 400,
    score = 0
}

local ball = {
    x = 400,
    y = 300,
    size = 10,
    speed_x = 300,
    speed_y = 300
}

-- Font for score display
local scoreFont

function love.load()
    -- Set the default filter to nearest for crisp pixel rendering
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    -- Load font for score display
    scoreFont = love.graphics.newFont(40)
end

function love.update(dt)
    -- Paddle 1 movement (W/S keys)
    if love.keyboard.isDown('w') then
        paddle1.y = math.max(0, paddle1.y - paddle1.speed * dt)
    end
    if love.keyboard.isDown('s') then
        paddle1.y = math.min(love.graphics.getHeight() - paddle1.height, paddle1.y + paddle1.speed * dt)
    end
    
    -- Paddle 2 movement (Up/Down arrows)
    if love.keyboard.isDown('up') then
        paddle2.y = math.max(0, paddle2.y - paddle2.speed * dt)
    end
    if love.keyboard.isDown('down') then
        paddle2.y = math.min(love.graphics.getHeight() - paddle2.height, paddle2.y + paddle2.speed * dt)
    end
    
    -- Ball movement
    ball.x = ball.x + ball.speed_x * dt
    ball.y = ball.y + ball.speed_y * dt
    
    -- Ball collision with top and bottom walls
    if ball.y <= 0 or ball.y >= love.graphics.getHeight() - ball.size then
        ball.speed_y = -ball.speed_y
    end
    
    -- Ball collision with paddles
    -- Paddle 1
    if checkCollision(ball, paddle1) then
        ball.speed_x = math.abs(ball.speed_x) -- Make sure it moves right
        ball.x = paddle1.x + paddle1.width -- Prevent sticking
        -- Add some variation to the return angle
        ball.speed_y = (ball.y - (paddle1.y + paddle1.height/2)) * 5
    end
    
    -- Paddle 2
    if checkCollision(ball, paddle2) then
        ball.speed_x = -math.abs(ball.speed_x) -- Make sure it moves left
        ball.x = paddle2.x - ball.size -- Prevent sticking
        -- Add some variation to the return angle
        ball.speed_y = (ball.y - (paddle2.y + paddle2.height/2)) * 5
    end
    
    -- Score points and reset ball
    if ball.x <= 0 then
        paddle2.score = paddle2.score + 1
        resetBall()
    end
    if ball.x >= love.graphics.getWidth() then
        paddle1.score = paddle1.score + 1
        resetBall()
    end
end

function love.draw()
    -- Draw paddles
    love.graphics.rectangle("fill", paddle1.x, paddle1.y, paddle1.width, paddle1.height)
    love.graphics.rectangle("fill", paddle2.x, paddle2.y, paddle2.width, paddle2.height)
    
    -- Draw ball
    love.graphics.rectangle("fill", ball.x, ball.y, ball.size, ball.size)
    
    -- Draw scores
    love.graphics.setFont(scoreFont)
    love.graphics.print(paddle1.score, love.graphics.getWidth()/4, 50)
    love.graphics.print(paddle2.score, 3*love.graphics.getWidth()/4, 50)
    
    -- Draw center line
    for i = 0, love.graphics.getHeight(), 20 do
        love.graphics.rectangle("fill", love.graphics.getWidth()/2 - 5, i, 10, 10)
    end
end

-- Helper function to check collision between ball and paddle
function checkCollision(ball, paddle)
    return ball.x < paddle.x + paddle.width and
           ball.x + ball.size > paddle.x and
           ball.y < paddle.y + paddle.height and
           ball.y + ball.size > paddle.y
end

-- Reset ball to center with random direction
function resetBall()
    ball.x = love.graphics.getWidth()/2 - ball.size/2
    ball.y = love.graphics.getHeight()/2 - ball.size/2
    ball.speed_x = 300 * (math.random(2) == 1 and 1 or -1)
    ball.speed_y = 300 * (math.random(2) == 1 and 1 or -1)
end