# Playerbot Spec Changer

Addon for AzerothCore and mod-playerbots to help switch specs and reroll bots. Just gives a visual interface allowing you to switch a bot spec.

## How to use it

Select a bot, and click on the new minimap button:

<img width="296" height="243" alt="00" src="https://github.com/user-attachments/assets/ae4f6d15-3384-4e24-84e1-dd01ba818b4a" />

A simple dialog shows up with a dropdown to switch to any of the out-of-the-box specs:

<img width="395" height="331" alt="01" src="https://github.com/user-attachments/assets/902ca654-6ee6-4c40-ba36-5b63d9934edf" />

When you confirm the changes, the following commands are sent to the selected bot:

```
talents spec <<selected spec>>
maitenance
reset botAI
autogear
```

## Limitations

- Currently it supports the out-of-the-box specs that come with [mod-playerbots](https://github.com/liyunfan1223/mod-playerbots). If you have custom specs, this addon is not designed to show them at the moment.
- If you have removed or renamed some of the default specs, the addon will also not work properly and you will have to switch specs manually.

## Future work

- Query the bot for the available specs instead of relying on the out-of-the-box spec list. This would make the dialog slightly slower to load.
- Pre-select the current spec on the dropdown, by inferring the name from the `talents` query response.
