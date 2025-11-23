-- main.lua - Flying Panel Complete System for Delta Runner
function love.load()
    -- ตั้งค่าพื้นฐาน
    love.window.setTitle("Flying Panel - Delta Runner")
    font = love.graphics.newFont(12)
    love.graphics.setFont(font)
    
    -- ค่าคงที่
    screenWidth, screenHeight = love.graphics.getDimensions()
    
    -- Flying Panel System
    flyingPanel = {
        -- พื้นฐาน
        x = 100,
        y = 100,
        width = 320,
        height = 220,
        
        -- การบิน
        isFlying = false,
        flightSpeed = 150,
        flightDirection = {x = 0, y = 0},
        fuelLevel = 100,
        maxFuel = 100,
        fuelConsumption = 15,
        
        -- หน้าต่าง
        title = "🚀 Flying Control Panel",
        isMinimized = false,
        isDragging = false,
        dragOffset = {x = 0, y = 0},
        
        -- ปุ่มควบคุม
        buttons = {
            fly = {x = 20, y = 50, w = 80, h = 30, text = "FLY", active = false, color = {0.2, 0.8, 0.2}},
            stop = {x = 110, y = 50, w = 80, h = 30, text = "STOP", active = false, color = {0.8, 0.2, 0.2}},
            refuel = {x = 200, y = 50, w = 80, h = 30, text = "REFUEL", active = false, color = {0.2, 0.5, 0.8}},
            minimize = {x = 290, y = 5, w = 20, h = 20, text = "_", color = {0.6, 0.6, 0.6}}
        },
        
        -- การควบคุม
        controls = {
            up = false,
            down = false,
            left = false,
            right = false
        },
        
        -- ข้อมูลการบิน
        altitude = 0,
        speed = 0,
        flightTime = 0,
        status = "Ready to fly!",
        
        -- เอฟเฟกต์
        particles = {},
        trailTimer = 0
    }
    
    -- ระบบแมพ
    currentMap = {
        name = "Default Map",
        gridsize = 50,
        obstacles = {}
    }
    
    -- สร้างสิ่งกีดขวางแบบสุ่มสำหรับแมพ
    generateMapObstacles()
    
    -- ตัวแปรเกม
    gameTime = 0
    score = 0
end

function love.update(dt)
    gameTime = gameTime + dt
    
    -- อัพเดท Flying Panel
    updateFlyingPanel(dt)
    
    -- อัพเดทการควบคุม
    updateControls()
    
    -- อัพเดทเอฟเฟกต์
    updateParticles(dt)
end

function love.draw()
    -- วาดพื้นหลังแมพ
    drawMapBackground()
    
    -- วาดสิ่งกีดขวาง
    drawObstacles()
    
    -- วาดเอฟเฟกต์
    drawParticles()
    
    -- วาด Flying Panel
    drawFlyingPanel()
    
    -- วาด UI ข้อมูล
    drawGameUI()
end

-- ระบบ Flying Panel
function updateFlyingPanel(dt)
    local panel = flyingPanel
    
    if panel.isFlying and panel.fuelLevel > 0 then
        -- คำนวณทิศทางการบิน
        local dirX, dirY = 0, 0
        if panel.controls.up then dirY = dirY - 1 end
        if panel.controls.down then dirY = dirY + 1 end
        if panel.controls.left then dirX = dirX - 1 end
        if panel.controls.right then dirX = dirX + 1 end
        
        -- ปรับทิศทางให้เป็นหน่วย
        local length = math.sqrt(dirX * dirX + dirY * dirY)
        if length > 0 then
            dirX = dirX / length
            dirY = dirY / length
        end
        
        panel.flightDirection.x = dirX
        panel.flightDirection.y = dirY
        
        -- เคลื่อนที่ Panel
        if not panel.isMinimized then
            panel.x = panel.x + dirX * panel.flightSpeed * dt
            panel.y = panel.y + dirY * panel.flightSpeed * dt
        end
        
        -- ลดน้ำมัน
        if length > 0 then
            panel.fuelLevel = math.max(0, panel.fuelLevel - panel.fuelConsumption * dt)
            panel.flightTime = panel.flightTime + dt
        end
        
        -- สร้างควันด้านหลัง
        panel.trailTimer = panel.trailTimer + dt
        if panel.trailTimer > 0.1 and length > 0 then
            createTrailParticle()
            panel.trailTimer = 0
        end
        
        -- อัพเดทข้อมูล
        panel.altitude = math.floor(panel.y)
        panel.speed = math.floor(panel.flightSpeed * length)
        panel.status = "Flying! Speed: " .. panel.speed
        
        -- ตรวจสอบขอบจอ
        checkScreenBounds()
        
        -- ตรวจสอบการชนสิ่งกีดขวาง
        checkObstacleCollision()
        
        -- ตรวจสอบน้ำมัน
        if panel.fuelLevel <= 0 then
            panel.isFlying = false
            panel.status = "Out of fuel! Landed."
            panel.buttons.fly.active = false
            panel.buttons.stop.active = false
        end
        
    elseif panel.isFlying and panel.fuelLevel <= 0 then
        panel.isFlying = false
        panel.status = "Out of fuel!"
    end
end

function drawFlyingPanel()
    local panel = flyingPanel
    
    if panel.isMinimized then
        -- วาดในโหมดย่อ
        drawMinimizedPanel()
        return
    end
    
    -- พื้นหลัง Panel
    love.graphics.setColor(0.1, 0.1, 0.2, 0.95)
    love.graphics.rectangle("fill", panel.x, panel.y, panel.width, panel.height, 10)
    
    -- ขอบ Panel
    love.graphics.setColor(0.3, 0.3, 0.6, 1)
    love.graphics.rectangle("line", panel.x, panel.y, panel.width, panel.height, 10)
    love.graphics.setLineWidth(2)
    
    -- แถบหัวเรื่อง
    love.graphics.setColor(0.2, 0.2, 0.4, 1)
    love.graphics.rectangle("fill", panel.x, panel.y, panel.width, 30, 5, 5, 0, 0)
    
    -- ข้อความหัวเรื่อง
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(panel.title, panel.x + 10, panel.y + 8)
    
    -- วาดปุ่มทั้งหมด
    for name, btn in pairs(panel.buttons) do
        drawButton(btn, panel.x + btn.x, panel.y + btn.y)
    end
    
    -- วาดเกจน้ำมัน
    drawFuelGauge()
    
    -- วาดข้อมูลการบิน
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Status: " .. panel.status, panel.x + 20, panel.y + 90)
    love.graphics.print("Altitude: " .. panel.altitude, panel.x + 20, panel.y + 110)
    love.graphics.print("Speed: " .. panel.speed, panel.x + 20, panel.y + 130)
    love.graphics.print("Flight Time: " .. string.format("%.1fs", panel.flightTime), panel.x + 20, panel.y + 150)
    love.graphics.print("Controls: Arrow Keys", panel.x + 20, panel.y + 170)
    love.graphics.print("Drag Title Bar to Move", panel.x + 20, panel.y + 190)
end

function drawMinimizedPanel()
    local panel = flyingPanel
    love.graphics.setColor(0.2, 0.2, 0.4, 0.9)
    love.graphics.rectangle("fill", panel.x, panel.y, panel.width, 30, 5)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(panel.title .. " [Minimized]", panel.x + 10, panel.y + 8)
    
    -- แสดงสถานะน้ำมันแบบย่อ
    love.graphics.setColor(1, 1 - panel.fuelLevel/100, 0)
    love.graphics.rectangle("fill", panel.x + panel.width - 60, panel.y + 10, 50, 10)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(math.floor(panel.fuelLevel).."%", panel.x + panel.width - 55, panel.y + 8)
end

function drawButton(button, x, y)
    local color = button.active and {button.color[1]*1.5, button.color[2]*1.5, button.color[3]*1.5} or button.color
    love.graphics.setColor(color[1], color[2], color[3])
    love.graphics.rectangle("fill", x, y, button.w, button.h, 5)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(button.text, x + button.w/2 - font:getWidth(button.text)/2, y + button.h/2 - 6)
end

function drawFuelGauge()
    local panel = flyingPanel
    local gaugeWidth = 200
    local gaugeX = panel.x + 60
    local gaugeY = panel.y + 20
    
    -- พื้นหลังเกจ
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", gaugeX, gaugeY, gaugeWidth, 15, 3)
    
    -- ระดับน้ำมัน
    local fuelPercent = panel.fuelLevel / panel.maxFuel
    local fuelColor = fuelPercent > 0.5 and {0.2, 0.8, 0.2} or 
                     fuelPercent > 0.2 and {1, 0.8, 0.2} or {0.8, 0.2, 0.2}
    
    love.graphics.setColor(fuelColor[1], fuelColor[2], fuelColor[3])
    love.graphics.rectangle("fill", gaugeX, gaugeY, gaugeWidth * fuelPercent, 15, 3)
    
    -- ขอบเกจ
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", gaugeX, gaugeY, gaugeWidth, 15, 3)
    
    -- ข้อความน้ำมัน
    love.graphics.print("FUEL", panel.x + 20, panel.y + 20)
end

-- ระบบแมพและสิ่งกีดขวาง
function generateMapObstacles()
    local obstacles = {}
    local gridSize = currentMap.gridsize
    
    -- สร้างสิ่งกีดขวางแบบสุ่ม
    for i = 1, 15 do
        table.insert(obstacles, {
            x = math.random(0, screenWidth/gridSize - 3) * gridSize,
            y = math.random(0, screenHeight/gridSize - 3) * gridSize,
            width = math.random(1, 4) * gridSize,
            height = math.random(1, 4) * gridSize,
            color = {math.random(0.3, 0.6), math.random(0.1, 0.3), math.random(0.1, 0.3)}
        })
    end
    
    currentMap.obstacles = obstacles
end

function drawMapBackground()
    -- พื้นหลัง gradient
    for y = 0, screenHeight, 2 do
        local factor = y / screenHeight
        love.graphics.setColor(0.1 + factor*0.1, 0.1 + factor*0.2, 0.2 + factor*0.3)
        love.graphics.line(0, y, screenWidth, y)
    end
    
    -- Grid แมพ
    love.graphics.setColor(0.3, 0.3, 0.4, 0.3)
    for x = 0, screenWidth, currentMap.gridsize do
        love.graphics.line(x, 0, x, screenHeight)
    end
    for y = 0, screenHeight, currentMap.gridsize do
        love.graphics.line(0, y, screenWidth, y)
    end
end

function drawObstacles()
    for _, obs in ipairs(currentMap.obstacles) do
        love.graphics.setColor(obs.color[1], obs.color[2], obs.color[3], 0.8)
        love.graphics.rectangle("fill", obs.x, obs.y, obs.width, obs.height, 5)
        love.graphics.setColor(0.8, 0.8, 1, 0.5)
        love.graphics.rectangle("line", obs.x, obs.y, obs.width, obs.height, 5)
    end
end

function checkObstacleCollision()
    local panel = flyingPanel
    local panelBounds = {
        x = panel.x + 10, y = panel.y + 40,
        width = panel.width - 20, height = panel.height - 50
    }
    
    for _, obs in ipairs(currentMap.obstacles) do
        if checkCollision(panelBounds, obs) then
            panel.isFlying = false
            panel.status = "Collision! Damage taken."
            panel.fuelLevel = math.max(0, panel.fuelLevel - 10)
            score = math.max(0, score - 50)
            return
        end
    end
end

function checkCollision(rect1, rect2)
    return rect1.x < rect2.x + rect2.width and
           rect1.x + rect1.width > rect2.x and
           rect1.y < rect2.y + rect2.height and
           rect1.y + rect1.height > rect2.y
end

-- ระบบเอฟเฟกต์
function createTrailParticle()
    local panel = flyingPanel
    table.insert(panel.particles, {
        x = panel.x + math.random(-10, 10),
        y = panel.y + panel.height - 10,
        size = math.random(3, 8),
        life = 1.0,
        color = {0.8, 0.8, 0.3},
        speed = math.random(20, 50),
        angle = math.random(math.pi, math.pi * 2)
    })
end

function updateParticles(dt)
    local panel = flyingPanel
    for i = #panel.particles, 1, -1 do
        local p = panel.particles[i](p.life) = p.life - dt
        p.size = p.size - dt * 2
        p.x = p.x + math.cos(p.angle) * p.speed * dt
        p.y = p.y + math.sin(p.angle) * p.speed * dt
        
        if p.life <= 0 or p.size <= 0 then
            table.remove(panel.particles, i)
        end
    end
end

function drawParticles()
    local panel = flyingPanel
    for _, p in ipairs(panel.particles) do
        love.graphics.setColor(p.color[1], p.color[2], p.color[3], p.life)
        love.graphics.circle("fill", p.x, p.y, p.size)
    end
end

-- ระบบการควบคุม
function updateControls()
    flyingPanel.controls.up = love.keyboard.isDown("up") or love.keyboard.isDown("w")
    flyingPanel.controls.down = love.keyboard.isDown("down") or love.keyboard.isDown("s")
    flyingPanel.controls.left = love.keyboard.isDown("left") or love.keyboard.isDown("a")
    flyingPanel.controls.right = love.keyboard.isDown("right") or love.keyboard.isDown("d")
end

function checkScreenBounds()
    local panel = flyingPanel
    if panel.x < 0 then panel.x = 0 end
    if panel.y < 0 then panel.y = 0 end
    if panel.x + panel.width > screenWidth then panel.x = screenWidth - panel.width end
    if panel.y + (panel.isMinimized and 30 or panel.height) > screenHeight then 
        panel.y = screenHeight - (panel.isMinimized and 30 or panel.height)
    end
end

function drawGameUI()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Delta Runner - Flying Panel System", 10, 10)
    love.graphics.print("Score: " .. score, 10, 30)
    love.graphics.print("Map: " .. currentMap.name, 10, 50)
    love.graphics.print("Game Time: " .. string.format("%.1fs", gameTime), 10, 70)
    
    -- คำแนะนำควบคุม
    love.graphics.print("Controls: Arrow/WASD = Fly | Click Buttons | Drag Panel | F = Fuel | R = Reset", 10, screenHeight - 60)
    love.graphics.print("M = New Map | Space = Toggle Fly | ESC = Quit", 10, screenHeight - 40)
end

-- การจัดการอินพุต
function love.mousepressed(x, y, button)
    if button == 1 then
        handleMouseClick(x, y)
    end
end

function handleMouseClick(x, y)
    local panel = flyingPanel
    
    -- ตรวจสอบการคลิกปุ่ม
    if not panel.isMinimized then
        for name, btn in pairs(panel.buttons) do
            local btnX, btnY = panel.x + btn.x, panel.y + btn.y
            if x >= btnX and x <= btnX + btn.w and y >= btnY and y <= btnY + btn.h then
                handleButtonAction(name)
                return
            end
        end
    end
    
    -- ตรวจสอบการลากแถบหัวเรื่อง
    if (panel.isMinimized and y >= panel.y and y <= panel.y + 30 and x >= panel.x and x <= panel.x + panel.width) or
       (not panel.isMinimized and y >= panel.y and y <= panel.y + 30 and x >= panel.x and x <= panel.x + panel.width) then
        panel.isDragging = true
        panel.dragOffset.x = x - panel.x
        panel.dragOffset.y = y - panel.y
    end
end

function love.mousemoved(x, y, dx, dy)
    local panel = flyingPanel
    if panel.isDragging then
        panel.x = x - panel.dragOffset.x
        panel.y = y - panel.dragOffset.y
        checkScreenBounds()
    end
end

function love.mousereleased(x, y, button)
    flyingPanel.isDragging = false
end

function handleButtonAction(buttonName)
    local panel = flyingPanel
    
    if buttonName == "fly" then
        if panel.fuelLevel > 0 then
            panel.isFlying = true
            panel.buttons.fly.active = true
            panel.buttons.stop.active = false
            panel.status = "Flying!"
            score = score + 10
        else
            panel.status = "Need fuel to fly!"
        end
    elseif buttonName == "stop" then
        panel.isFlying = false
        panel.buttons.fly.active = false
        panel.buttons.stop.active = true
        panel.status = "Landed safely."
    elseif buttonName == "refuel" then
        panel.fuelLevel = panel.maxFuel
        panel.status = "Refueled to 100%!"
        score = score + 5
    elseif buttonName == "minimize" then
        panel.isMinimized = not panel.isMinimized
    end
end

function love.keypressed(key)
    local panel = flyingPanel
    
    if key == "space" then
        -- สลับสถานะบิน
        panel.isFlying = not panel.isFlying
        if panel.isFlying and panel.fuelLevel > 0 then
            panel.status = "Flying!"
            panel.buttons.fly.active = true
            panel.buttons.stop.active = false
        else
            panel.status = "Landed"
            panel.buttons.fly.active = false
            panel.buttons.stop.active = true
        end
    elseif key == "f" then
        -- เติมน้ำมัน
        panel.fuelLevel = math.min(panel.maxFuel, panel.fuelLevel + 30)
        panel.status = "Fuel added!"
        score = score + 5
    elseif key == "r" then
        -- รีเซ็ต
        panel.x = 100
        panel.y = 100
        panel.isFlying = false
        panel.fuelLevel = panel.maxFuel
        panel.status = "System reset!"
        panel.buttons.fly.active = false
        panel.buttons.stop.active = false
        score = 0
        gameTime = 0
    elseif key == "m" then
        -- สร้างแมพใหม่
        generateMapObstacles()
        panel.status = "New map generated!"
        score = score + 100
    elseif key == "escape" then
        love.event.quit()
    end
end

function love.resize(w, h)
    screenWidth, screenHeight = w, h
    checkScreenBounds()
end

-- เริ่มต้นเกม
print("Flying Panel System for Delta Runner")
print("Controls: Arrow Keys/WASD to fly, Click buttons, Drag panel")
print("F = Fuel, R = Reset, M = New Map, Space = Toggle Fly")
