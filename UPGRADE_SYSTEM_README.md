# Upgrade Drag-and-Drop System Implementation

This document explains how to implement the upgrade drag-and-drop system for your Godot project.

## Overview

The system allows players to:
1. Click on upgrade buttons in the HUD
2. Drag the upgrade over the BaseTerrain
3. See visual feedback for valid/invalid placement
4. Place the upgrade when conditions are met

## File Structure

```
scripts/
├── entities/
│   ├── upgrade_base.gd          # Base class for all upgrades
│   ├── mineshaft_upgrade.gd     # Specific mineshaft upgrade
│   └── mineshaft_entity.gd      # Mineshaft behavior when placed
├── managers/
│   └── upgrade_drag_manager.gd  # Handles drag-and-drop logic
├── ui/
│   └── upgrade_button.gd        # Button behavior
└── game/
    └── level_01.gd              # Updated level script

scenes/
├── entities/
│   └── mineshaft.tscn           # Mineshaft scene
└── ui/
    └── hud_upgrade_button.tscn  # Updated button scene
```

## Implementation Steps

### 1. Add the Upgrade Drag Manager to Level01

The `level_01.gd` script has been updated to include the `UpgradeDragManager`. This manager handles all drag-and-drop interactions.

### 2. Configure Upgrade Buttons

Each upgrade button in your HUD should:
- Use the `UpgradeButton` script
- Set the `upgrade_scene` property to the upgrade scene
- Configure `upgrade_name`, `upgrade_description`, and `upgrade_cost`

### 3. Create Upgrade Scenes

For each upgrade type:
1. Create a scene that extends `UpgradeBase`
2. Set the `upgrade_scene` property to the entity that will be instantiated
3. Configure placement validation logic

### 4. Add Visual Feedback

The system includes:
- **Preview sprites** during dragging
- **Placement indicators** showing valid/invalid areas
- **Color-coded feedback** (green for valid, red for invalid)
- **Tooltips** on button hover

## Usage Example

### Creating a New Upgrade Type

1. **Create the upgrade script:**
```gdscript
extends UpgradeBase
class_name MyUpgrade

func _ready() -> void:
    upgrade_name = "My Upgrade"
    upgrade_description = "Description here"
    upgrade_cost = 200
    super()

func _check_placement_validity(pos: Vector2) -> bool:
    # Add your custom validation logic
    return super._check_placement_validity(pos)
```

2. **Create the upgrade scene:**
```gdscript
# my_upgrade.tscn
[node name="MyUpgrade" type="Node2D"]
script = ExtResource("path/to/my_upgrade.gd")
upgrade_scene = ExtResource("path/to/my_entity.tscn")
```

3. **Configure the button:**
```gdscript
# In the button scene
script = ExtResource("path/to/upgrade_button.gd")
upgrade_scene = ExtResource("path/to/my_upgrade.tscn")
upgrade_name = "My Upgrade"
upgrade_description = "Description here"
upgrade_cost = 200
```

## Customization Options

### Placement Validation

Override `_check_placement_validity()` in your upgrade class to add custom rules:
- Distance from other entities
- Terrain type requirements
- Resource cost validation
- Height/slope restrictions

### Visual Feedback

Customize the visual feedback by modifying:
- `valid_placement_color` and `invalid_placement_color`
- Preview sprite appearance
- Placement indicator shape and size

### Entity Behavior

When an upgrade is placed, the instantiated entity can:
- Start resource extraction
- Provide buffs to nearby entities
- Generate income
- Unlock new features

## Integration with Existing Systems

### Resource Management

Connect to the `upgrade_placed` signal to:
- Deduct resources from player
- Update UI displays
- Trigger effects or animations

### Save/Load System

The upgrade system works with Godot's built-in save/load system. Just ensure your upgrade entities are properly serializable.

## Troubleshooting

### Common Issues

1. **Upgrade not dragging**: Check that the `UpgradeDragManager` is properly added to the scene
2. **No visual feedback**: Ensure the upgrade scene has a `preview_texture` set
3. **Invalid placement**: Verify your `_check_placement_validity()` logic
4. **Button not responding**: Check that the button has the correct script attached

### Debug Tips

- Use `print()` statements in `_check_placement_validity()` to debug placement logic
- Check the console for error messages about missing nodes
- Verify all scene references are correct in the editor

## Performance Considerations

- The grid system can be expensive with many cells - consider culling off-screen cells
- Limit the number of simultaneous drag operations
- Use object pooling for frequently created/destroyed preview sprites

## Future Enhancements

- **Grid snapping**: Snap upgrades to grid positions
- **Multi-select**: Select and move multiple upgrades
- **Undo/Redo**: Add undo functionality for placement
- **Templates**: Save and load upgrade configurations
- **Advanced validation**: Terrain analysis, slope detection, etc. 