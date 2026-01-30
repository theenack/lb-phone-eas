# LB Phone EAS Script

A script for FiveM that integrates with lb-phone to provide Emergency Alert System (EAS) notifications. It allows admins to send emergency alerts to all players with configurable departments and supports Discord logging for better moderation and auditing.

---

## Features
- **Emergency Alerts**: Send notifications to all players through the phone system.
- **Configurable Departments**: Add or modify departments easily in `config.lua`.
- **Discord Logging**: Log all alerts to a Discord channel for auditing.
- **Admin Permissions**: Restrict command usage to players with specific permissions.
- **Debugging**: Enable debug messages to troubleshoot issues.

---

## Installation

1. **Download and Add the Script to Your Server**:
   - Place the script in your `resources` folder under a directory named `phone-eas`.

2. **Add to `server.cfg`**:
   - Add the following line to your `server.cfg`:

     ensure phone-eas


3. **Ensure lb-phone is Installed**:
   - This script depends on the **lb-phone** resource. Make sure it is installed and configured correctly.

---

## Configuration

All configurations can be found in the `config.lua` file. Below are the available settings:

### Departments

Add or modify departments under the `Config.Departments` table:

Config.Departments = {
    LSPD = "Los Santos Police Department",
    BCSO = "Blaine County Sheriff's Office",
    LSCSO = "Los Santos County Sheriff's Office",
    SAST = "San Andreas State Troopers"
}


### Discord Logging

Enable or disable Discord logging with `Config.EnableDiscordLogging`. Set your Discord webhook URL under `Config.DiscordWebhook`.

Example:

Config.EnableDiscordLogging = true
Config.DiscordWebhook = "https://discord.com/api/webhooks/your_webhook_url_here"


**Note**: If Discord logging is enabled but the webhook URL is not updated, a warning will appear in the server console.

### Debugging

Enable debugging to print detailed logs in the console:

Config.EnableDebug = true


---

## Usage

### Command: `/phonealert`

**Syntax**:

/phonealert [departmentKey] [alertType]


**Examples**:
- Send a warning alert from the LSPD:

  /phonealert LSPD warning


- Send a danger alert from the BCSO:

  /phonealert BCSO danger


**Important**:
- The `departmentKey` must match a valid key in `Config.Departments`.
- If the `departmentKey` is missing or invalid, an error will appear in chat:

  Department key is required. Please specify a valid department key.


---

## Permissions

To use the `/phonealert` command, players must have the following ACE permission:

add_ace group.admin phonealert.admin allow


---

## Discord Logging

When enabled, the following details are logged to Discord:
- **Message**: The content of the alert.
- **Department**: The department sending the alert.
- **Alert Type**: `warning` or `danger`.
- **Player Details**: Name, FiveM ID, Steam ID, and Discord ID.

---

## Error Handling

### Missing Configuration
- If `config.lua` is missing or has syntax errors, the script will fail to load with the following error in the server console:

  [ERROR]: Failed to load config.lua! Please check the file for syntax errors or missing values.


### Invalid Department Key
- If an invalid or missing department key is provided, the player will see:

  Department key is required. Please specify a valid department key.


### Discord Logging Issues
- If the Discord webhook is not configured properly, a warning will appear in the console:

  [WARNING]: Discord logging is enabled, but the Discord webhook URL is not properly configured in config.lua!


---

## Debugging

Enable debug messages in `config.lua`:

Config.EnableDebug = true


When enabled, additional logs will appear in the server console for troubleshooting.

---

## Support

If you encounter issues or need further assistance:
- Check the server console for errors.
- Ensure your `config.lua` file is correctly configured.
- If no solution can be found, please contact the script developer.

---

