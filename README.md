# Roblox Exploit Framework UI

A professional, modular exploit framework with a clean dark-themed UI. Features automatic module loading, real-time settings adjustment, and smooth animations.

## 🎯 Features

✅ **Clean Dark Theme UI** - Modern, professional appearance
✅ **Modular Architecture** - Easy to add/remove features
✅ **Real-Time Settings** - Sliders, toggles, keybinds with live updates
✅ **Auto-Discovery** - Drop modules in folders, they load automatically
✅ **Smooth Animations** - Professional UI transitions
✅ **Category Organization** - Organize modules by type
✅ **Draggable Window** - Move the UI around freely
✅ **Persistent Settings** - Save/load configuration
✅ **Multi-Executor Support** - Works with Synapse, Script-Ware, Drift, Xeno, Solaris, etc.

## 📁 Repository Structure

```
roblox-exploit-framework/
├── src/
│   ├── loader.lua              # Entry point (use with loadstring)
│   ├── init.lua                # Framework initialization
│   │
│   ├── ui/
│   │   ├── theme.lua           # Dark theme configuration
│   │   ├── animations.lua      # Smooth animation system
│   │   ├── main.lua            # Main UI controller
│   │   │
│   │   └── components/
│   │       ├── slider.lua      # Slider component
│   │       ├── toggle.lua      # Toggle switch component
│   │       └── keybind.lua     # Keybind input component
│   │
│   ├── modules/
│   │   ├── moduleTemplate.lua  # Copy this for new modules
│   │   ├── moduleManager.lua   # Module manager
│   │   │
│   │   ├── combat/
│   │   │   └── aimAssist.lua
│   │   │
│   │   └── visuals/
│   │       └── playerEsp.lua
│   │
│   └── core/
│       ├── signal.lua          # Event system
│       └── utilities.lua       # Helper functions
```

## 🚀 Quick Start

### Installation

1. Create a new GitHub repository
2. Copy all files from `src/` folder
3. Update `src/loader.lua` with your GitHub username and repository name:

```lua
local REPO_URL = "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/src"
```

### Usage

Execute in your executor:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/src/loader.lua"))()
```

The UI will appear centered on your screen and is fully draggable.

## 📚 Using Modules

### View Available Modules

All modules are automatically loaded and appear in the UI organized by category:
- **Combat** - Combat-related features (Aim Assist, etc.)
- **Visuals** - Visual features (Player ESP, etc.)
- **Settings** - Global framework settings

### Enable/Disable Modules

1. Click the module name to toggle it on/off
2. Click the arrow (▼) to expand settings
3. Adjust sliders, toggles, and keybinds in real-time

### Current Modules

#### Aim Assist (Combat)
- **Smoothness** - How smooth the assistance is (0-100)
- **Range** - Maximum assistance range (10-500 studs)
- **Keybind** - Key to activate
- **Angle** - Maximum angle offset (0-90°)

#### Player ESP (Visuals)
- **Teammates Included** - Include teammates in ESP
- **Range** - Maximum display range (50-2000 studs)
- **Highlight** - Draw player boxes
- **Tracers** - Draw lines to players
- **Distance Display** - Show distance to players
- **Team Colors** - Color by team affiliation

## 🔧 Creating New Modules

### Step 1: Create Module File

Create `src/modules/[category]/[moduleName].lua`:

```lua
return {
    Name = "My Feature",
    Category = "combat",  -- or visuals, movement, utility, other
    Description = "What it does",
    
    Settings = {
        enabled = { type = "toggle", value = false, description = "Enable/disable" },
        range = { type = "slider", value = 50, min = 10, max = 100, description = "Range" },
        speed = { type = "slider", value = 100, min = 0, max = 200, description = "Speed %" },
        keybind = { type = "keybind", value = "Q", description = "Activation key" },
    },
    
    _state = {
        isActive = false,
        -- Add your custom state variables
    },
    
    Initialize = function(self)
        print("Module initialized")
    end,
    
    Enable = function(self)
        print("Module enabled")
    end,
    
    Disable = function(self)
        print("Module disabled")
    end,
    
    Destroy = function(self)
        print("Module destroyed")
    end,
    
    Update = function(self)
        -- Called every frame when enabled
    end,
    
    OnSettingChanged = function(self, settingName, newValue)
        print(settingName .. " = " .. tostring(newValue))
    end,
}
```

### Step 2: Add to Repository

1. Commit and push to GitHub
2. That's it! The module will auto-load

## 🎨 UI Components

### Slider
Adjust numeric values smoothly with real-time preview.

```lua
-- In a module's Settings:
range = {
    type = "slider",
    value = 50,      -- Default value
    min = 0,         -- Minimum
    max = 100,       -- Maximum
    description = "Range to attack from"
}
```

### Toggle
Simple on/off switch with smooth animation.

```lua
-- In a module's Settings:
teamkill = {
    type = "toggle",
    value = false,   -- Default: off
    description = "Can attack teammates"
}
```

### Keybind
Click to set a keyboard key.

```lua
-- In a module's Settings:
keybind = {
    type = "keybind",
    value = "Q",     -- Default key
    description = "Press to activate"
}
```

## 🎯 Customizing the Theme

Edit `src/ui/theme.lua` to customize:

```lua
-- Colors
Colors = {
    Primary = Color3.fromRGB(66, 135, 245),  -- Main accent
    Background = Color3.fromRGB(15, 15, 20),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    -- ... more colors
}

-- Sizes
Sizes = {
    WindowWidth = 450,
    WindowHeight = 600,
    TextSizeNormal = 12,
    -- ... more sizes
}

-- Animation speeds
AnimationSpeeds = {
    Normal = 0.3,
    Slow = 0.5,
    -- ... more speeds
}
```

Changes apply immediately on next load.

## 📊 Module Settings Storage

Settings are automatically saved to executor storage. The format:

```json
{
  "uiSettings": {
    "scale": 1.0,
    "animationSpeed": 0.3
  },
  "modules": {
    "combat": {
      "aimAssist": {
        "enabled": false,
        "smoothness": 50,
        "range": 100,
        "keybind": "Q",
        "angle": 30
      }
    },
    "visuals": {
      "playerEsp": {
        "enabled": true,
        "range": 500
      }
    }
  }
}
```

## 🔗 Accessing Framework Globally

```lua
-- After loading, access via:
local Framework = _G.ExploitFramework

-- Access module manager
local ModuleManager = Framework.ModuleManager
ModuleManager:EnableModule("aimAssist")

-- Get settings
local range = ModuleManager:GetSetting("aimAssist", "range")

-- Update setting
ModuleManager:UpdateModuleSetting("aimAssist", "range", 150)
```

## 🐛 Troubleshooting

### UI doesn't appear
- Check executor compatibility (should work with Synapse, Script-Ware, Drift, Xeno, Solaris)
- Verify game has loaded: `if not game:IsLoaded() then game.Loaded:Wait() end`

### Modules not loading
- Ensure folder structure is correct: `src/modules/[category]/[name].lua`
- Check browser console for errors
- Verify module returns a table with required fields

### Settings not saving
- Ensure your executor supports `readfile`/`writefile`
- Check file permissions in executor
- Try with a different path

## 📝 Example: Creating a Simple Module

Create `src/modules/movement/speed.lua`:

```lua
return {
    Name = "Speed",
    Category = "movement",
    Description = "Run faster",
    
    Settings = {
        enabled = { type = "toggle", value = false, description = "Enable speed" },
        speedBoost = { type = "slider", value = 1.5, min = 1, max = 5, description = "Speed multiplier" },
        keybind = { type = "keybind", value = "W", description = "Sprint key" },
    },
    
    _state = {
        isActive = false,
        originalSpeed = 1,
    },
    
    Initialize = function(self)
        print("[Speed] Module loaded")
    end,
    
    Enable = function(self)
        print("[Speed] Enabled with boost: " .. self.Settings.speedBoost.value)
    end,
    
    Disable = function(self)
        print("[Speed] Disabled")
    end,
    
    Destroy = function(self)
        -- Cleanup
    end,
    
    Update = function(self)
        -- Update logic here
        local player = game:GetService("Players").LocalPlayer
        if player and player.Character then
            -- Modify player speed based on settings
        end
    end,
    
    OnSettingChanged = function(self, settingName, newValue)
        if settingName == "speedBoost" then
            print("[Speed] Boost changed to: " .. newValue)
        end
    end,
}
```

Done! The module will appear in the UI automatically.

## 🎓 Module API Reference

### Module Structure

Every module must have:

```lua
return {
    Name = "string",              -- Display name
    Category = "string",          -- Folder name
    Description = "string",       -- Tooltip text
    Settings = { ... },           -- Settings table
    _state = { isActive = false }, -- Internal state
    Initialize = function(self) end,
    Enable = function(self) end,
    Disable = function(self) end,
    Destroy = function(self) end,
    Update = function(self) end,
    OnSettingChanged = function(self, name, value) end,
}
```

### Lifecycle

1. **Initialize** - Called when module loads
2. **Enable** - Called when user toggles ON
3. **Update** - Called every frame if enabled
4. **Disable** - Called when user toggles OFF
5. **Destroy** - Called on script termination

## 📄 License

MIT License - Feel free to modify and distribute

## 🤝 Contributing

To contribute:
1. Fork the repository
2. Create a feature branch
3. Add your modules
4. Submit a pull request

## 💡 Tips

- **Performance**: Use `task.wait()` in Update loops to control tick rate
- **Settings**: Always validate new values in `OnSettingChanged`
- **Organization**: Keep related modules in the same category folder
- **Documentation**: Add descriptions to all settings for tooltips
- **Testing**: Use print statements to debug module behavior

## 📞 Support

If you encounter issues:
1. Check the troubleshooting section
2. Verify file structure matches the repo
3. Test with a simple module first
4. Check executor console for errors

---

**Made with ❤️ for Roblox developers**
