-- 🌟 ELIXIR HUB - Modern Modular Roblox GUI
-- Clean Design with Theme Switching

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- 🎨 ЦВЕТОВЫЕ ТЕМЫ (ТОЛЬКО 3: ЧЕРНАЯ, БЕЛАЯ, ФИОЛЕТОВАЯ)
local THEMES = {
    BLACK = {
        NAME = "Black",
        BACKGROUND = Color3.fromRGB(15, 15, 20),
        SIDEBAR = Color3.fromRGB(20, 20, 25),
        CONTENT = Color3.fromRGB(25, 25, 30),
        ACCENT = Color3.fromRGB(120, 200, 255),
        TEXT = Color3.fromRGB(230, 230, 240),
        TEXT_DARK = Color3.fromRGB(150, 150, 180),
        SUCCESS = Color3.fromRGB(80, 240, 120),
        WARNING = Color3.fromRGB(240, 180, 80),
        DANGER = Color3.fromRGB(240, 80, 80),
        TAB_TITLE = Color3.fromRGB(20, 20, 25)
    },
    WHITE = {
        NAME = "White",
        BACKGROUND = Color3.fromRGB(245, 245, 250),
        SIDEBAR = Color3.fromRGB(235, 235, 245),
        CONTENT = Color3.fromRGB(255, 255, 255),
        ACCENT = Color3.fromRGB(80, 160, 255),
        TEXT = Color3.fromRGB(30, 30, 40),
        TEXT_DARK = Color3.fromRGB(100, 100, 130),
        SUCCESS = Color3.fromRGB(60, 200, 100),
        WARNING = Color3.fromRGB(220, 160, 60),
        DANGER = Color3.fromRGB(220, 60, 60),
        TAB_TITLE = Color3.fromRGB(225, 225, 235)
    },
    PURPLE = {
        NAME = "Purple",
        BACKGROUND = Color3.fromRGB(35, 25, 45),
        SIDEBAR = Color3.fromRGB(45, 30, 55),
        CONTENT = Color3.fromRGB(55, 35, 65),
        ACCENT = Color3.fromRGB(180, 100, 255),
        TEXT = Color3.fromRGB(240, 230, 255),
        TEXT_DARK = Color3.fromRGB(180, 160, 220),
        SUCCESS = Color3.fromRGB(150, 255, 180),
        WARNING = Color3.fromRGB(255, 220, 100),
        DANGER = Color3.fromRGB(255, 100, 150),
        TAB_TITLE = Color3.fromRGB(40, 30, 50)
    }
}

-- 🏗️ МОДУЛЬНЫЙ ГУИ
local ElixirHub = {}
ElixirHub.__index = ElixirHub

-- Публичные методы и свойства
ElixirHub.THEMES = THEMES
ElixirHub.currentTheme = THEMES.BLACK
ElixirHub.COLORS = THEMES.BLACK
ElixirHub.currentTab = "VISUALS"
ElixirHub.tabButtons = {}
ElixirHub.tabContents = {}
ElixirHub.callbacks = {}
ElixirHub.modules = {} -- Для хранения ваших функций и модулей

-- 📦 ВНУТРЕННИЕ ПЕРЕМЕННЫЕ
local ScreenGui
local MainFrame
local ContentContainer
local RightPanel

-- 🏗️ КОНСТРУКТОР
function ElixirHub.new()
    local self = setmetatable({}, ElixirHub)
    self:initialize()
    return self
end

-- 🚀 ИНИЦИАЛИЗАЦИЯ ГУИ
function ElixirHub:initialize()
    -- 🔧 Создаем главный GUI
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ElixirHub"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
    else
        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    -- 🎯 ГЛАВНЫЙ КОНТЕЙНЕР
    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = self.COLORS.BACKGROUND
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

    -- Обводка
    local FrameStroke = Instance.new("UIStroke")
    FrameStroke.Color = self.COLORS.ACCENT
    FrameStroke.Thickness = 1
    FrameStroke.Transparency = 0.4
    FrameStroke.Parent = MainFrame

    -- Скругленные углы
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 12)
    FrameCorner.Parent = MainFrame

    -- 🔝 ВЕРХНЯЯ ПАНЕЛЬ
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = self.COLORS.SIDEBAR
    TopBar.Size = UDim2.new(1, 0, 0, 60)

    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 12)
    TopBarCorner.Parent = TopBar

    -- Акцентная полоса
    local TopAccent = Instance.new("Frame")
    TopAccent.Name = "TopAccent"
    TopAccent.BackgroundColor3 = self.COLORS.ACCENT
    TopAccent.BackgroundTransparency = 0.7
    TopAccent.BorderSizePixel = 0
    TopAccent.Position = UDim2.new(0, 0, 1, -2)
    TopAccent.Size = UDim2.new(1, 0, 0, 2)

    -- Логотип (КРАСИВЫЙ ТЕКСТОВЫЙ) - ИЗМЕНЕНО
    local Logo = Instance.new("TextLabel")
    Logo.Name = "Logo"
    Logo.BackgroundTransparency = 1
    Logo.Position = UDim2.new(0, 10, 0.5, -20)
    Logo.Size = UDim2.new(0, 40, 0, 40)
    Logo.AnchorPoint = Vector2.new(0, 0.5)
    Logo.Font = Enum.Font.GothamBlack
    Logo.Text = "♦"  -- Бриллиант символ
    Logo.TextColor3 = self.COLORS.ACCENT
    Logo.TextSize = 32

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 60, 0, 0)
    Title.Size = UDim2.new(0, 230, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "ELIXIR HUB"
    Title.TextColor3 = self.COLORS.TEXT
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 60, 0, 35)
    Subtitle.Size = UDim2.new(0, 230, 0, 20)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = "v2.0 • Advanced Suite"
    Subtitle.TextColor3 = self.COLORS.TEXT_DARK
    Subtitle.TextSize = 12
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Кнопка закрытия (КРАСИВЫЙ ТЕКСТОВЫЙ КРЕСТИК) - ИЗМЕНЕНО
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundColor3 = self.COLORS.DANGER
    CloseButton.BackgroundTransparency = 0.2
    CloseButton.Position = UDim2.new(1, -40, 0.5, -17)
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 22

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)  -- Квадрат со скругленными углами
    CloseCorner.Parent = CloseButton

    -- Обводка для крестика
    local CloseStroke = Instance.new("UIStroke")
    CloseStroke.Color = Color3.fromRGB(255, 255, 255)
    CloseStroke.Thickness = 1
    CloseStroke.Transparency = 0.3
    CloseStroke.Parent = CloseButton

    -- 📱 ОСНОВНОЕ СОДЕРЖИМОЕ
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 0, 0, 60)
    Content.Size = UDim2.new(1, 0, 1, -60)

    -- Левая панель (вкладки)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.BackgroundColor3 = self.COLORS.SIDEBAR
    Sidebar.BackgroundTransparency = 0.05
    Sidebar.Position = UDim2.new(0, 0, 0, 0)
    Sidebar.Size = UDim2.new(0, 120, 1, 0)

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 12)
    SidebarCorner.Parent = Sidebar

    -- Разделитель
    local SidebarDivider = Instance.new("Frame")
    SidebarDivider.Name = "SidebarDivider"
    SidebarDivider.BackgroundColor3 = self.COLORS.ACCENT
    SidebarDivider.BackgroundTransparency = 0.5
    SidebarDivider.BorderSizePixel = 0
    SidebarDivider.Position = UDim2.new(1, -1, 0, 0)
    SidebarDivider.Size = UDim2.new(0, 1, 1, 0)

    -- Правая панель (контент)
    RightPanel = Instance.new("Frame")
    RightPanel.Name = "RightPanel"
    RightPanel.BackgroundColor3 = self.COLORS.CONTENT
    RightPanel.BackgroundTransparency = 0.05
    RightPanel.Position = UDim2.new(0, 121, 0, 0)
    RightPanel.Size = UDim2.new(1, -121, 1, 0)

    local RightCorner = Instance.new("UICorner")
    RightCorner.CornerRadius = UDim.new(0, 12)
    RightCorner.Parent = RightPanel

    -- Контейнер контента
    ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 20, 0, 20)
    ContentContainer.Size = UDim2.new(1, -40, 1, -40)

    -- 📦 СБОРКА ИЕРАРХИИ
    TopAccent.Parent = TopBar
    Logo.Parent = TopBar
    Title.Parent = TopBar
    Subtitle.Parent = TopBar
    CloseButton.Parent = TopBar
    TopBar.Parent = MainFrame

    SidebarDivider.Parent = Sidebar
    Sidebar.Parent = Content

    RightPanel.Parent = Content
    ContentContainer.Parent = RightPanel
    Content.Parent = MainFrame

    MainFrame.Parent = ScreenGui

    -- 🚀 ИНИЦИАЛИЗАЦИЯ ВКЛАДОК
    self:initializeTabs(Sidebar)

    -- 🔧 ФУНКЦИОНАЛ
    self:setupFunctionality(CloseButton, TopBar)

    -- Анимация появления
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundTransparency = 1

    TweenService:Create(MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -250, 0.5, -175),
        BackgroundTransparency = 0.05
    }):Play()

    -- Создаем дефолтный контент для вкладок
    self:createDefaultTabContents()
    
    -- Показываем стартовую вкладку
    self:switchTab("VISUALS")
end

-- 🏗️ ИНИЦИАЛИЗАЦИЯ ВКЛАДОК
function ElixirHub:initializeTabs(Sidebar)
    local tabs = {
        {icon = "📊", name = "VISUALS", color = self.COLORS.ACCENT},
        {icon = "🎯", name = "AIMBOT", color = self.COLORS.SUCCESS},
        {icon = "⚡", name = "PLAYER", color = self.COLORS.WARNING},
        {icon = "⚙️", name = "SETTINGS", color = self.COLORS.TEXT_DARK}
    }

    for i, tab in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tab.name .. "Tab"
        tabButton.BackgroundColor3 = self.COLORS.SIDEBAR
        tabButton.BackgroundTransparency = 0.85
        tabButton.Position = UDim2.new(0, 10, 0, 15 + (i-1)*58)
        tabButton.Size = UDim2.new(1, -20, 0, 50)
        tabButton.Font = Enum.Font.Gotham
        tabButton.Text = tab.icon .. "\n" .. tab.name
        tabButton.TextColor3 = self.COLORS.TEXT_DARK
        tabButton.TextSize = 13
        tabButton.TextWrapped = true
        tabButton.AutoButtonColor = false
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabButton
        
        local tabIndicator = Instance.new("Frame")
        tabIndicator.Name = "Indicator"
        tabIndicator.BackgroundColor3 = tab.color
        tabIndicator.BackgroundTransparency = 0.8
        tabIndicator.BorderSizePixel = 0
        tabIndicator.Position = UDim2.new(0, -10, 0.5, -8)
        tabIndicator.Size = UDim2.new(0, 3, 0, 0)
        tabIndicator.Visible = false
        tabIndicator.Parent = tabButton
        
        -- Анимация при наведении
        tabButton.MouseEnter:Connect(function()
            if self.currentTab ~= tab.name then
                TweenService:Create(tabButton, TweenInfo.new(0.25), {
                    BackgroundTransparency = 0.7,
                    TextColor3 = self.COLORS.TEXT
                }):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if self.currentTab ~= tab.name then
                TweenService:Create(tabButton, TweenInfo.new(0.25), {
                    BackgroundTransparency = 0.85,
                    TextColor3 = self.COLORS.TEXT_DARK
                }):Play()
            end
        end)
        
        -- Анимация переключения вкладок
        tabButton.MouseButton1Click:Connect(function()
            if self.currentTab == tab.name then return end
            
            if self.callbacks["beforeTabSwitch"] then
                self.callbacks["beforeTabSwitch"](self.currentTab, tab.name)
            end
            
            self:switchTab(tab.name)
            
            if self.callbacks["afterTabSwitch"] then
                self.callbacks["afterTabSwitch"](tab.name)
            end
        end)
        
        tabButton.Parent = Sidebar
        self.tabButtons[tab.name] = tabButton
        
        -- Устанавливаем первую вкладку как активную
        if i == 1 then
            tabButton.BackgroundTransparency = 0.3
            tabButton.TextColor3 = self.COLORS.TEXT
            tabIndicator.Visible = true
            tabIndicator.Size = UDim2.new(0, 3, 0, 25)
        end
    end
end

-- ⚙️ НАСТРОЙКА ФУНКЦИОНАЛА
function ElixirHub:setupFunctionality(CloseButton, TopBar)
    -- Закрытие GUI
    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.4), {
            Position = UDim2.new(0.5, -250, 0.5, -200),
            BackgroundTransparency = 1
        }):Play()
        wait(0.4)
        ScreenGui:Destroy()
    end)

    -- Анимация для крестика
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {
            BackgroundTransparency = 0,
            Size = UDim2.new(0, 38, 0, 38)
        }):Play()
        TweenService:Create(CloseButton.UIStroke, TweenInfo.new(0.2), {
            Transparency = 0
        }):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2,
            Size = UDim2.new(0, 35, 0, 35)
        }):Play()
        TweenService:Create(CloseButton.UIStroke, TweenInfo.new(0.2), {
            Transparency = 0.3
        }):Play()
    end)
    
    -- Эффект при нажатии
    CloseButton.MouseButton1Down:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.1), {
            Size = UDim2.new(0, 32, 0, 32)
        }):Play()
    end)
    
    CloseButton.MouseButton1Up:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.1), {
            Size = UDim2.new(0, 35, 0, 35)
        }):Play()
    end)

    -- Перемещение GUI
    local dragging = false
    local dragStart, startPos

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            TweenService:Create(TopBar, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.1
            }):Play()
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if dragging then
                dragging = false
                
                TweenService:Create(TopBar, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0
                }):Play()
            end
        end
    end)

    -- Горячие клавиши
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed then
            if input.KeyCode == Enum.KeyCode.Insert then
                MainFrame.Visible = not MainFrame.Visible
            elseif input.KeyCode == Enum.KeyCode.Delete then
                ScreenGui:Destroy()
            end
        end
    end)
end

-- 📝 СОЗДАНИЕ ДЕФОЛТНОГО КОНТЕНТА ВКЛАДОК
function ElixirHub:createDefaultTabContents()
    -- Дефолтный контент для VISUALS
    self.tabContents["VISUALS"] = function()
        local container = Instance.new("Frame")
        container.Name = "VisualsContent"
        container.BackgroundTransparency = 1
        container.Size = UDim2.new(1, 0, 1, 0)
        
        -- КВАДРАТИК ДЛЯ НАЗВАНИЯ ВКЛАДКИ
        local titleBackground = Instance.new("Frame")
        titleBackground.Name = "TitleBackground"
        titleBackground.BackgroundColor3 = self.COLORS.TAB_TITLE
        titleBackground.BackgroundTransparency = 0.1
        titleBackground.Position = UDim2.new(0.5, -120, 0.1, 0)
        titleBackground.Size = UDim2.new(0, 240, 0, 40)
        
        local titleCorner = Instance.new("UICorner")
        titleCorner.CornerRadius = UDim.new(0, 8)
        titleCorner.Parent = titleBackground
        
        local titleStroke = Instance.new("UIStroke")
        titleStroke.Color = self.COLORS.ACCENT
        titleStroke.Thickness = 1
        titleStroke.Transparency = 0.3
        titleStroke.Parent = titleBackground
        
        local title = Instance.new("TextLabel")
        title.Text = "VISUALS"
        title.TextColor3 = self.COLORS.TEXT
        title.TextSize = 18
        title.Font = Enum.Font.GothamBold
        title.Size = UDim2.new(1, 0, 1, 0)
        title.BackgroundTransparency = 1
        title.TextXAlignment = Enum.TextXAlignment.Center
        title.TextYAlignment = Enum.TextYAlignment.Center
        title.Parent = titleBackground
        
        titleBackground.Parent = container
        
        -- Инструкция для добавления своих функций
        local instruction = Instance.new("TextLabel")
        instruction.Text = "Add your visual functions here"
        instruction.TextColor3 = self.COLORS.TEXT_DARK
        instruction.TextSize = 14
        instruction.Font = Enum.Font.Gotham
        instruction.Position = UDim2.new(0.5, -150, 0.3, 0)
        instruction.Size = UDim2.new(0, 300, 0, 100)
        instruction.BackgroundTransparency = 1
        instruction.TextXAlignment = Enum.TextXAlignment.Center
        instruction.TextYAlignment = Enum.TextYAlignment.Top
        instruction.TextWrapped = true
        instruction.Parent = container
        
        return container
    end
    
    -- Дефолтный контент для AIMBOT
    self.tabContents["AIMBOT"] = function()
        local container = Instance.new("Frame")
        container.Name = "AimbotContent"
        container.BackgroundTransparency = 1
        container.Size = UDim2.new(1, 0, 1, 0)
        
        local titleBackground = Instance.new("Frame")
        titleBackground.Name = "TitleBackground"
        titleBackground.BackgroundColor3 = self.COLORS.TAB_TITLE
        titleBackground.BackgroundTransparency = 0.1
        titleBackground.Position = UDim2.new(0.5, -120, 0.1, 0)
        titleBackground.Size = UDim2.new(0, 240, 0, 40)
        
        local titleCorner = Instance.new("UICorner")
        titleCorner.CornerRadius = UDim.new(0, 8)
        titleCorner.Parent = titleBackground
        
        local titleStroke = Instance.new("UIStroke")
        titleStroke.Color = self.COLORS.ACCENT
        titleStroke.Thickness = 1
        titleStroke.Transparency = 0.3
        titleStroke.Parent = titleBackground
        
        local title = Instance.new("TextLabel")
        title.Text = "AIMBOT"
        title.TextColor3 = self.COLORS.TEXT
        title.TextSize = 18
        title.Font = Enum.Font.GothamBold
        title.Size = UDim2.new(1, 0, 1, 0)
        title.BackgroundTransparency = 1
        title.TextXAlignment = Enum.TextXAlignment.Center
        title.TextYAlignment = Enum.TextYAlignment.Center
        title.Parent = titleBackground
        
        titleBackground.Parent = container
        
        local instruction = Instance.new("TextLabel")
        instruction.Text = "Add your aimbot functions here"
        instruction.TextColor3 = self.COLORS.TEXT_DARK
        instruction.TextSize = 14
        instruction.Font = Enum.Font.Gotham
        instruction.Position = UDim2.new(0.5, -150, 0.3, 0)
        instruction.Size = UDim2.new(0, 300, 0, 100)
        instruction.BackgroundTransparency = 1
        instruction.TextXAlignment = Enum.TextXAlignment.Center
        instruction.TextYAlignment = Enum.TextYAlignment.Top
        instruction.TextWrapped = true
        instruction.Parent = container
        
        return container
    end
    
    -- Дефолтный контент для PLAYER
    self.tabContents["PLAYER"] = function()
        local container = Instance.new("Frame")
        container.Name = "PlayerContent"
        container.BackgroundTransparency = 1
        container.Size = UDim2.new(1, 0, 1, 0)
        
        local titleBackground = Instance.new("Frame")
        titleBackground.Name = "TitleBackground"
        titleBackground.BackgroundColor3 = self.COLORS.TAB_TITLE
        titleBackground.BackgroundTransparency = 0.1
        titleBackground.Position = UDim2.new(0.5, -120, 0.1, 0)
        titleBackground.Size = UDim2.new(0, 240, 0, 40)
        
        local titleCorner = Instance.new("UICorner")
        titleCorner.CornerRadius = UDim.new(0, 8)
        titleCorner.Parent = titleBackground
        
        local titleStroke = Instance.new("UIStroke")
        titleStroke.Color = self.COLORS.ACCENT
        titleStroke.Thickness = 1
        titleStroke.Transparency = 0.3
        titleStroke.Parent = titleBackground
        
        local title = Instance.new("TextLabel")
        title.Text = "PLAYER"
        title.TextColor3 = self.COLORS.TEXT
        title.TextSize = 18
        title.Font = Enum.Font.GothamBold
        title.Size = UDim2.new(1, 0, 1, 0)
        title.BackgroundTransparency = 1
        title.TextXAlignment = Enum.TextXAlignment.Center
        title.TextYAlignment = Enum.TextYAlignment.Center
        title.Parent = titleBackground
        
        titleBackground.Parent = container
        
        local instruction = Instance.new("TextLabel")
        instruction.Text = "Add your player functions here"
        instruction.TextColor3 = self.COLORS.TEXT_DARK
        instruction.TextSize = 14
        instruction.Font = Enum.Font.Gotham
        instruction.Position = UDim2.new(0.5, -150, 0.3, 0)
        instruction.Size = UDim2.new(0, 300, 0, 100)
        instruction.BackgroundTransparency = 1
        instruction.TextXAlignment = Enum.TextXAlignment.Center
        instruction.TextYAlignment = Enum.TextYAlignment.Top
        instruction.TextWrapped = true
        instruction.Parent = container
        
        return container
    end
    
    -- Дефолтный контент для SETTINGS
    self.tabContents["SETTINGS"] = function()
        local container = Instance.new("Frame")
        container.Name = "SettingsContent"
        container.BackgroundTransparency = 1
        container.Size = UDim2.new(1, 0, 1, 0)
        
        local titleBackground = Instance.new("Frame")
        titleBackground.Name = "TitleBackground"
        titleBackground.BackgroundColor3 = self.COLORS.TAB_TITLE
        titleBackground.BackgroundTransparency = 0.1
        titleBackground.Position = UDim2.new(0.5, -120, 0.1, 0)
        titleBackground.Size = UDim2.new(0, 240, 0, 40)
        
        local titleCorner = Instance.new("UICorner")
        titleCorner.CornerRadius = UDim.new(0, 8)
        titleCorner.Parent = titleBackground
        
        local titleStroke = Instance.new("UIStroke")
        titleStroke.Color = self.COLORS.ACCENT
        titleStroke.Thickness = 1
        titleStroke.Transparency = 0.3
        titleStroke.Parent = titleBackground
        
        local title = Instance.new("TextLabel")
        title.Text = "SETTINGS"
        title.TextColor3 = self.COLORS.TEXT
        title.TextSize = 18
        title.Font = Enum.Font.GothamBold
        title.Size = UDim2.new(1, 0, 1, 0)
        title.BackgroundTransparency = 1
        title.TextXAlignment = Enum.TextXAlignment.Center
        title.TextYAlignment = Enum.TextYAlignment.Center
        title.Parent = titleBackground
        
        titleBackground.Parent = container
        
        local themeTitle = Instance.new("TextLabel")
        themeTitle.Text = "Select Theme"
        themeTitle.TextColor3 = self.COLORS.TEXT_DARK
        themeTitle.TextSize = 16
        themeTitle.Font = Enum.Font.Gotham
        themeTitle.Position = UDim2.new(0, 20, 0, 100)
        themeTitle.Size = UDim2.new(1, -40, 0, 25)
        themeTitle.BackgroundTransparency = 1
        themeTitle.TextXAlignment = Enum.TextXAlignment.Left
        themeTitle.Parent = container
        
        -- Кнопки тем
        local themeButtons = {}
        local buttonY = 135
        
        for i, themeName in ipairs({"BLACK", "WHITE", "PURPLE"}) do
            local themeData = THEMES[themeName]
            
            local themeBtn = Instance.new("TextButton")
            themeBtn.Name = themeData.NAME .. "ThemeBtn"
            themeBtn.BackgroundColor3 = themeData.BACKGROUND
            themeBtn.BackgroundTransparency = 0.3
            themeBtn.Position = UDim2.new(0, 20, 0, buttonY)
            themeBtn.Size = UDim2.new(1, -40, 0, 35)
            themeBtn.Font = Enum.Font.Gotham
            themeBtn.Text = themeData.NAME
            themeBtn.TextColor3 = themeData.TEXT
            themeBtn.TextSize = 14
            themeBtn.AutoButtonColor = false
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = themeBtn
            
            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = themeData.ACCENT
            btnStroke.Thickness = 1
            btnStroke.Transparency = 0.7
            btnStroke.Parent = themeBtn
            
            if themeData.NAME == self.currentTheme.NAME then
                themeBtn.BackgroundTransparency = 0.1
                btnStroke.Transparency = 0.3
            end
            
            -- Обработчик смены темы
            themeBtn.MouseButton1Click:Connect(function()
                TweenService:Create(themeBtn, TweenInfo.new(0.08), {
                    Size = UDim2.new(1, -45, 0, 32)
                }):Play()
                
                wait(0.08)
                
                TweenService:Create(themeBtn, TweenInfo.new(0.12), {
                    Size = UDim2.new(1, -40, 0, 35)
                }):Play()
                
                wait(0.1)
                
                -- Эффект волны
                local waveEffect = Instance.new("Frame")
                waveEffect.Name = "WaveEffect"
                waveEffect.BackgroundColor3 = themeData.ACCENT
                waveEffect.BackgroundTransparency = 0.8
                waveEffect.Size = UDim2.new(0, 0, 0, 0)
                waveEffect.Position = UDim2.new(0.5, 0, 0.5, 0)
                waveEffect.AnchorPoint = Vector2.new(0.5, 0.5)
                waveEffect.ZIndex = 100
                
                local waveCorner = Instance.new("UICorner")
                waveCorner.CornerRadius = UDim.new(1, 0)
                waveCorner.Parent = waveEffect
                
                waveEffect.Parent = MainFrame
                
                TweenService:Create(waveEffect, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(2, 0, 2, 0),
                    BackgroundTransparency = 1
                }):Play()
                
                -- Смена темы
                self:switchTheme(themeName)
                
                -- Сброс всех кнопок тем
                for _, btn in pairs(themeButtons) do
                    local btnThemeName = btn.Name:gsub("ThemeBtn", "")
                    local btnThemeData = THEMES[btnThemeName]
                    
                    if btnThemeData then
                        if btnThemeData.NAME == themeData.NAME then
                            TweenService:Create(btn, TweenInfo.new(0.3), {
                                BackgroundTransparency = 0.1
                            }):Play()
                            TweenService:Create(btn.UIStroke, TweenInfo.new(0.3), {
                                Transparency = 0.3
                            }):Play()
                        else
                            TweenService:Create(btn, TweenInfo.new(0.3), {
                                BackgroundTransparency = 0.3
                            }):Play()
                            TweenService:Create(btn.UIStroke, TweenInfo.new(0.3), {
                                Transparency = 0.7
                            }):Play()
                        end
                    end
                end
                
                wait(0.6)
                waveEffect:Destroy()
            end)
            
            themeBtn.MouseEnter:Connect(function()
                if themeData.NAME ~= self.currentTheme.NAME then
                    TweenService:Create(themeBtn, TweenInfo.new(0.2), {
                        BackgroundTransparency = 0.15
                    }):Play()
                end
            end)
            
            themeBtn.MouseLeave:Connect(function()
                if themeData.NAME ~= self.currentTheme.NAME then
                    TweenService:Create(themeBtn, TweenInfo.new(0.2), {
                        BackgroundTransparency = 0.3
                    }):Play()
                end
            end)
            
            themeBtn.Parent = container
            themeButtons[themeName] = themeBtn
            buttonY = buttonY + 45
        end
        
        return container
    end
end

-- 🎯 ПУБЛИЧНЫЕ МЕТОДЫ

-- 📋 ПЕРЕКЛЮЧЕНИЕ ВКЛАДКИ
function ElixirHub:switchTab(tabName)
    if self.currentTab == tabName then return end
    
    local previousTab = self.currentTab
    self.currentTab = tabName
    
    for name, btn in pairs(self.tabButtons) do
        if name ~= tabName then
            TweenService:Create(btn, TweenInfo.new(0.25), {
                BackgroundTransparency = 0.85,
                TextColor3 = self.COLORS.TEXT_DARK
            }):Play()
            btn.Indicator.Visible = false
            TweenService:Create(btn.Indicator, TweenInfo.new(0.25), {
                Size = UDim2.new(0, 3, 0, 0)
            }):Play()
        end
    end
    
    local activeBtn = self.tabButtons[tabName]
    if activeBtn then
        TweenService:Create(activeBtn, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.3,
            TextColor3 = self.COLORS.TEXT
        }):Play()
        activeBtn.Indicator.Visible = true
        TweenService:Create(activeBtn.Indicator, TweenInfo.new(0.25), {
            Size = UDim2.new(0, 3, 0, 25)
        }):Play()
    end
    
    self:updateTabContent(tabName)
end

-- 🔄 ПЕРЕКЛЮЧЕНИЕ ТЕМЫ
function ElixirHub:switchTheme(themeName)
    local newTheme = THEMES[themeName]
    if not newTheme then return end
    
    self.currentTheme = newTheme
    self.COLORS = newTheme
    
    MainFrame.BackgroundColor3 = self.COLORS.BACKGROUND
    
    local topBar = MainFrame:FindFirstChild("TopBar")
    if topBar then
        topBar.BackgroundColor3 = self.COLORS.SIDEBAR
        
        local logo = topBar:FindFirstChild("Logo")
        if logo then logo.TextColor3 = self.COLORS.ACCENT end
        
        local title = topBar:FindFirstChild("Title")
        if title then title.TextColor3 = self.COLORS.TEXT end
        
        local subtitle = topBar:FindFirstChild("Subtitle")
        if subtitle then subtitle.TextColor3 = self.COLORS.TEXT_DARK end
        
        local closeBtn = topBar:FindFirstChild("CloseButton")
        if closeBtn then
            closeBtn.BackgroundColor3 = self.COLORS.DANGER
            closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        
        local topAccent = topBar:FindFirstChild("TopAccent")
        if topAccent then
            topAccent.BackgroundColor3 = self.COLORS.ACCENT
        end
    end
    
    local content = MainFrame:FindFirstChild("Content")
    if content then
        local sidebar = content:FindFirstChild("Sidebar")
        if sidebar then
            sidebar.BackgroundColor3 = self.COLORS.SIDEBAR
            
            local divider = sidebar:FindFirstChild("SidebarDivider")
            if divider then
                divider.BackgroundColor3 = self.COLORS.ACCENT
            end
        end
    end
    
    if RightPanel then
        RightPanel.BackgroundColor3 = self.COLORS.CONTENT
    end
    
    for name, btn in pairs(self.tabButtons) do
        btn.BackgroundColor3 = self.COLORS.SIDEBAR
        
        if self.currentTab == name then
            btn.BackgroundTransparency = 0.3
            btn.TextColor3 = self.COLORS.TEXT
            if btn.Indicator then
                btn.Indicator.Visible = true
                btn.Indicator.Size = UDim2.new(0, 3, 0, 25)
                
                for _, tab in ipairs({
                    {name = "VISUALS", color = self.COLORS.ACCENT},
                    {name = "AIMBOT", color = self.COLORS.SUCCESS},
                    {name = "PLAYER", color = self.COLORS.WARNING},
                    {name = "SETTINGS", color = self.COLORS.TEXT_DARK}
                }) do
                    if tab.name == name then
                        btn.Indicator.BackgroundColor3 = tab.color
                        break
                    end
                end
            end
        else
            btn.BackgroundTransparency = 0.85
            btn.TextColor3 = self.COLORS.TEXT_DARK
            if btn.Indicator then
                btn.Indicator.Visible = false
                btn.Indicator.Size = UDim2.new(0, 3, 0, 0)
            end
        end
    end
    
    self:updateTabContent(self.currentTab)
end

-- 📝 ОБНОВЛЕНИЕ КОНТЕНТА ВКЛАДКИ
function ElixirHub:updateTabContent(tabName)
    ContentContainer:ClearAllChildren()
    
    if self.tabContents[tabName] then
        local content = self.tabContents[tabName]()
        content.Parent = ContentContainer
    else
        local defaultContent = Instance.new("TextLabel")
        defaultContent.Text = tabName
        defaultContent.TextColor3 = self.COLORS.TEXT
        defaultContent.TextSize = 18
        defaultContent.Font = Enum.Font.GothamBold
        defaultContent.Position = UDim2.new(0.5, -100, 0.5, -15)
        defaultContent.Size = UDim2.new(0, 200, 0, 30)
        defaultContent.BackgroundTransparency = 1
        defaultContent.TextXAlignment = Enum.TextXAlignment.Center
        defaultContent.Parent = ContentContainer
    end
end

-- ➕ ДОБАВЛЕНИЕ КОНТЕНТА ДЛЯ ВКЛАДКИ
function ElixirHub:setTabContent(tabName, contentFunction)
    if not self.tabButtons[tabName] then
        warn("Вкладка " .. tabName .. " не существует!")
        return
    end
    
    self.tabContents[tabName] = contentFunction
    
    if self.currentTab == tabName then
        self:updateTabContent(tabName)
    end
end

-- ➕ ДОБАВЛЕНИЕ CALLBACK-ФУНКЦИЙ
function ElixirHub:setCallback(eventName, callbackFunction)
    self.callbacks[eventName] = callbackFunction
end

-- 📦 РЕГИСТРАЦИЯ МОДУЛЯ (ВАША ФУНКЦИЯ)
function ElixirHub:registerModule(moduleName, moduleFunction)
    self.modules[moduleName] = moduleFunction
    print("✅ Module registered:", moduleName)
end

-- 🎯 ВЫЗОВ ВАШЕЙ ФУНКЦИИ
function ElixirHub:executeModule(moduleName, ...)
    if self.modules[moduleName] then
        return self.modules[moduleName](...)
    else
        warn("Module not found:", moduleName)
        return nil
    end
end

-- 🎨 ИЗМЕНЕНИЕ ЦВЕТОВОЙ СХЕМЫ
function ElixirHub:setColorScheme(background, sidebar, content, accent, text, textDark, tabTitle)
    self.COLORS.BACKGROUND = background
    self.COLORS.SIDEBAR = sidebar
    self.COLORS.CONTENT = content
    self.COLORS.ACCENT = accent
    self.COLORS.TEXT = text
    self.COLORS.TEXT_DARK = textDark
    self.COLORS.TAB_TITLE = tabTitle or sidebar
    
    self:switchTheme(self.currentTheme.NAME)
end

-- 🖼️ ПОЛУЧЕНИЕ ЭЛЕМЕНТОВ ГУИ
function ElixirHub:getGUIElements()
    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        ContentContainer = ContentContainer,
        RightPanel = RightPanel,
        CurrentTheme = self.currentTheme,
        Colors = self.COLORS
    }
end

-- 🔧 СОЗДАНИЕ ПРОСТОГО ЭЛЕМЕНТА УПРАВЛЕНИЯ
function ElixirHub:createToggle(name, defaultValue, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = name .. "Toggle"
    toggle.BackgroundColor3 = self.COLORS.SIDEBAR
    toggle.BackgroundTransparency = 0.1
    toggle.Size = UDim2.new(1, 0, 0, 40)
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggle
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Text = name
    label.TextColor3 = self.COLORS.TEXT
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(0.7, -10, 1, 0)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggle
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.BackgroundColor3 = defaultValue and self.COLORS.SUCCESS or self.COLORS.DANGER
    toggleButton.BackgroundTransparency = 0.2
    toggleButton.Position = UDim2.new(0.8, 0, 0.2, 0)
    toggleButton.Size = UDim2.new(0.2, -10, 0.6, 0)
    toggleButton.Text = defaultValue and "ON" or "OFF"
    toggleButton.TextColor3 = self.COLORS.TEXT
    toggleButton.TextSize = 12
    toggleButton.Font = Enum.Font.GothamBold
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = toggleButton
    
    local state = defaultValue
    
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        toggleButton.BackgroundColor3 = state and self.COLORS.SUCCESS or self.COLORS.DANGER
        toggleButton.Text = state and "ON" or "OFF"
        
        if callback then
            callback(state)
        end
    end)
    
    toggleButton.Parent = toggle
    
    return toggle
end

function ElixirHub:createSlider(name, minValue, maxValue, defaultValue, callback)
    local slider = Instance.new("Frame")
    slider.Name = name .. "Slider"
    slider.BackgroundColor3 = self.COLORS.SIDEBAR
    slider.BackgroundTransparency = 0.1
    slider.Size = UDim2.new(1, 0, 0, 60)
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = slider
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Text = name .. ": " .. defaultValue
    label.TextColor3 = self.COLORS.TEXT
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.Position = UDim2.new(0, 10, 0, 5)
    label.Size = UDim2.new(1, -20, 0, 20)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = slider
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.BackgroundColor3 = self.COLORS.CONTENT
    track.BackgroundTransparency = 0.3
    track.Position = UDim2.new(0, 10, 0, 35)
    track.Size = UDim2.new(1, -20, 0, 6)
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.BackgroundColor3 = self.COLORS.ACCENT
    fill.BackgroundTransparency = 0.3
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local thumb = Instance.new("TextButton")
    thumb.Name = "Thumb"
    thumb.BackgroundColor3 = self.COLORS.ACCENT
    thumb.BackgroundTransparency = 0.1
    thumb.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -8, 0, -4)
    thumb.Size = UDim2.new(0, 16, 0, 16)
    thumb.Text = ""
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    
    fill.Parent = track
    track.Parent = slider
    thumb.Parent = track
    
    local dragging = false
    
    local function updateSlider(value)
        local normalized = math.clamp(value, minValue, maxValue)
        fill.Size = UDim2.new((normalized - minValue) / (maxValue - minValue), 0, 1, 0)
        thumb.Position = UDim2.new((normalized - minValue) / (maxValue - minValue), -8, 0, -4)
        label.Text = name .. ": " .. math.floor(normalized * 100) / 100
        
        if callback then
            callback(normalized)
        end
    end
    
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    thumb.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local absolutePos = mousePos - track.AbsolutePosition.X
            local relative = math.clamp(absolutePos / track.AbsoluteSize.X, 0, 1)
            local value = minValue + (maxValue - minValue) * relative
            updateSlider(value)
        end
    end)
    
    return slider
end

-- 🚀 СОЗДАНИЕ И ВОЗВРАТ ЭКЗЕМПЛЯРА
local hub = ElixirHub.new()

return hub
