# Home Assistant Automation Instructions

## Automation Storage

- Store manually managed automation source files in `home-assistant/`.
- Deploy each source file to `/homeassistant/automations/<filename>.yaml`.
- **MUST NOT** edit `/config/automations.yaml`. Home Assistant uses it for UI-managed automations.
- Manual automations load through `automation manual: !include_dir_merge_list automations/` in `/config/configuration.yaml`.

## File Format

- **MUST** make every file a YAML list, even when it contains one automation.
- Start each automation with `- alias:`.
- Include unique, stable `id` values.
- Use `description` to name the controlled device, trigger source, and integration.
- Use Home Assistant's plural top-level keys: `triggers`, `conditions`, and `actions`.
- Use `mode: queued` and a bounded `max` value when repeated button actions must be serialized.

```yaml
- alias: "Remote – Lamp control"
  id: remote_lamp_control
  description: Controls the lamp from the Zigbee2MQTT remote.
  mode: queued
  max: 10
  triggers:
    - trigger: mqtt
      id: toggle
      topic: zigbee2mqtt/REMOTE_FRIENDLY_NAME
      value_template: "{{ value_json.action == 'single_button_1' }}"
  actions:
    - action: light.toggle
      target:
        entity_id: light.target_lamp
```

## Zigbee2MQTT Button Automations

- Use the Zigbee2MQTT friendly name exactly in the MQTT topic: `zigbee2mqtt/<FRIENDLY_NAME>`.
- Match `value_json.action` against the action names exposed by the paired device.
- Confirm the action mapping in Zigbee2MQTT before writing triggers.
- Assign an `id` to every trigger and route actions with `condition: trigger` inside `choose` blocks.
- Clamp calculated brightness values between `1` and `100` percent.
- Set explicit `hs_color` or `color_temp_kelvin` values for fixed color scenes.
- Keep color cycles deterministic: test the lamp's current color, then select the next named color.

## Validation and Deployment

1. Validate YAML locally before deployment.
2. Copy only the intended file to `/homeassistant/automations/`.
3. Verify the local and remote file checksums match.
4. Run `ha core check` after the file is deployed.
5. Reload or restart Home Assistant Core only with explicit user confirmation.
6. If validation fails, remove the new manual automation file and report the failure.
